package Highlight;
use strict;
use warnings;

use Exporter;
use Carp;
use conf;
use Text::VimColor;

our @EXPORT_OK = qw(vim_syntax_list html_highlight_paste);
our @ISA = qw(Exporter);


sub vim_syntax_list {
    my @s_list;

    opendir my $dirh, $CONF{vim_syntax_dir}
	or croak "Unable to open vim syntax dir $!";

    @s_list = grep { ($_) = m{(.*)\.vim$}xms } readdir($dirh);
    @s_list = sort @s_list;
    return @s_list;
}

##
# Alters content of post to highlighted HTML.
sub html_highlight_paste {
    my $post_ref = shift;

    if ($post_ref->{filetype} eq "none") {
	return;
    }
    
    my $hl = Text::VimColor->new(
	string => $post_ref->{content},
	filetype => $post_ref->{filetype});
    $post_ref->{content} = $hl->html;
}

1;
