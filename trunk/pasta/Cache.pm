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


##
# Functions for caching HTML with highlighted code.
package Cache;

use strict;
use warnings;
use Exporter;
use Data::Dumper;
use Carp;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(cache_add is_cached cache_read cache_remove);

use conf;

sub cache_add {
    my ($paste_id, $html) = @_;

    _validate_paste($paste_id);
    croak "cache_add argument html is missing"
        unless defined $html;

    my $path = $CONF{cache_dir} . "/$paste_id.cache";
    open my $fh, ">", $path
        or carp "Unable to open cache file $path for writing, ", $!;
    carp $@ unless eval { print {$fh} $html };
    return ($@) ? 0 : 1;
}

sub is_cached {
    my $paste_id = shift;
    
    my $path = $CONF{cache_dir} . "/$paste_id.cache";
    
    return unless -r $path;
    1;
}

sub cache_read {
    my $paste_id = shift;
    
    _validate_paste($paste_id);
    croak "Paste is not cached"
        unless is_cached($paste_id);
    
    my $path = $CONF{cache_dir} . "/$paste_id.cache";
    open my $cacheh, "<", $path
        or croak "Unable to open cache file, ", $!;
    my @contents = <$cacheh>;
    return join q{}, @contents;
}

sub cache_remove {
    my $paste_id = shift;
    
    _validate_paste($paste_id);
    my $path = $CONF{cache_dir} . "/$paste_id.cache";

    unless (is_cached($paste_id)) {
        carp "Paste is not cached";
        return;
    }

    return unlink $path;
}

sub _validate_paste { croak "Invalid paste" unless $_[0] =~ /^\d+$/ }

1;
