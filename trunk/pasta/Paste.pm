package Paste;
# Copyright (c) 2007, Dagur Valberg Johannsson
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the <organization> nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY Dagur Valberg Johannsson ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <copyright holder> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

use strict;
use warnings;

use Carp;
use Data::Dumper;
use Exporter;
use Time::Duration;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(get_paste_list store_paste read_paste delete_paste);

use conf;

use constant NAME_MAX_LENGHT => 30;
use constant FILETYPE_MAX_LENGHT => 10;

sub get_paste_list {
    my ($limit, $offset) = @_;

    croak "get_paste_list takes 2 arguments" 
		unless scalar @_ == 2;

    my @pastes;
    
    opendir my $dirh, $CONF{pastes_dir} 
	or die "Can't open paste dir $!";
    
    # Files are saved as 'unixtime.paste'
    my @files = grep { /\.paste$/ } readdir($dirh);
    @files = sort { $b cmp $a } @files;

    for (my $i = $limit;
	    $i < $limit + $offset; 
	    $i++) {

	last if ($i > (scalar @files - 1));
   
	my $head = _read_head("$CONF{pastes_dir}/$files[$i]");
	my %meta = _parse_head($head);
	$meta{time_ago} = ago(time() - $meta{time});
	push @pastes, \%meta;
    }

    return @pastes;
}

##
# Stores a paste in a file.
# 
# Arguments:
#   filetype - Filetype
#   name     - User name
#   content  - Paste contents
#   passwd   - Paste password
#
# Returns:
#   id - Paste id.
sub store_paste {
    my ($filetype, $name, $content, $passwd) = @_;

    croak "missing argument. store_paste takes at least 3 arguments"
	if scalar @_ < 3;

    $filetype = q{} unless $filetype;
    $name = q{} unless $name;

    if (length $filetype > FILETYPE_MAX_LENGHT) {
	$filetype = substr $filetype, 0, FILETYPE_MAX_LENGHT;
    }
    if (length $name > NAME_MAX_LENGHT) {
	$filetype = substr $name, 0, NAME_MAX_LENGHT;
    }

    my $time = time();

    # Post in the feature on collision
    while (-e "$CONF{pastes_dir}/$time.paste") {
	$time++;
    }

    open my $fh, ">", "$CONF{pastes_dir}/$time.paste"
	or croak "Unable to open paste file for writing, $!";

    # write head
    # Inspired by Kareha source (PD)
    my %meta = ( 'filetype' => $filetype,
		     'name' => $name,
		     'time' => $time );
    if (defined $passwd) {
	$meta{passwd} = crypt($passwd, $CONF{salt});
    }
    $Data::Dumper::Terse  = 1;
    $Data::Dumper::Indent = 0;
    print {$fh} "<!-- " . Dumper(\%meta) . " -->\n";
    # ..then paste.
    print {$fh} $content;
    close $fh;

    return $time;
}

sub read_paste {
    my $paste_id = shift;

    _validate_paste($paste_id);
    my $path = "$CONF{pastes_dir}/$paste_id.paste";

    open my $pasteh, "<", $path
	or croak "Unable to read paste, $!";

    my %paste = _parse_head(scalar <$pasteh>);
    my @content = <$pasteh>;
    close $pasteh;

    $paste{content} = join q{}, @content;

    return %paste;
    
}

##
# Delete a paste.
# 
# Arguments:
#   paste_id - Paste ID.
#   passwd   - Paste password
sub delete_paste {
    my ($paste_id, $passwd) = @_;

    croak "delete_paste takes 2 arguments"
	unless scalar @_ == 2;

    _validate_paste($paste_id);
    my $path = "$CONF{pastes_dir}/$paste_id.paste";
    my %meta = _parse_head( _read_head($path) );
    
    croak "Paste does not have a password set"
	unless defined $meta{passwd};

    my $passwd_hash = crypt($passwd, $CONF{salt});
    croak "Incorrect password provided"
	unless $passwd_hash eq $meta{passwd};
    
    unlink $path;

    1;
}

##
# Sanity check for a paste id.
# Croaks on error.
#
# Arguments:
#   paste_id - Paste ID.
sub _validate_paste {
    my $paste_id = shift;
    
    croak "Not a valid paste"
	unless $paste_id =~ /^\d+$/;
    
    my $path = "$CONF{pastes_dir}/$paste_id.paste";
    croak "Paste does not exist"
	unless -f $path;

    1;
}

##
# Parse data in meta-data header.
#
# Arguments:
#   head - Paste file head
sub _parse_head {
    my $head = shift;

    my ($code) = $head =~ /\<!--(.*)-->/;
    my %data = %{eval $code};

    $data{name} = $CONF{default_anonymous}
	unless $data{name};

    return %data;
}

sub _read_head {
    my $file_path = shift;

    open my $fh, "<", $file_path
	or croak "Unable to open paste file $file_path, $!";

    my $head = <$fh>;
    close $fh;

    return $head;
}

1;
