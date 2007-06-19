#!/usr/bin/env perl
use strict;
use warnings;

use Template;
use CGI;
use Carp;
use Data::Dumper;

use conf;
use Paste qw(get_paste_list);
use Highlight qw(vim_syntax_list);

my $offset = 0;
if (defined CGI::param('offset')) {
    $offset = CGI::param('offset');
}

my $tpl_vars = {
    pastes => [ get_paste_list($offset, $CONF{list_size}) ],
    list_size => $CONF{list_size},
    offset => $offset,
    using_rewrite => $CONF{using_rewrite},
};


print CGI::header(-type => "text/html", -charset => "utf-8");
my $tt = Template->new({
    INCLUDE_PATH =>  'templates:templates/widgets',
    INTERPOLATE  =>  1,
    POST_CHOMP    => 1});

$tt->process('list.tpl', $tpl_vars)
    or die $tt->error(), "\n";

1;
