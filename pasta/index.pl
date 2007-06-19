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

my $tt = Template->new({
    INCLUDE_PATH =>  'templates:templates/widgets',
    INTERPOLATE  =>  1,
    POST_CHOMP    => 1});

my $tpl_vars = {
    types  => [ vim_syntax_list() ],
    type_default => $CONF{type_default},
    default_anonymous => $CONF{default_anonymous}
};


print CGI::header(-type => "text/html", -charset => "utf-8");
$tt->process('index.tpl', $tpl_vars)
    or die $tt->error(), "\n";

1;
