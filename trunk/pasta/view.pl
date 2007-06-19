#!/usr/bin/env perl
use strict;
use warnings;

use Template;
use CGI;
use Paste qw(read_paste);
use Highlight qw(html_highlight_paste);
use Carp;
use Data::Dumper;
use Time::Duration;
use conf;


my $paste;
unless (eval { $paste = +{ read_paste(CGI::param('p')) } } ) {
    print CGI::header("text/html");
    print "<h3>Error: ", $@, "</h3>";
    exit;
}

if (defined CGI::param('plain')) {
    print CGI::header("text/plain");
    print $paste->{'content'};
    exit;
}

# print html
print CGI::header(-type => "text/html", -charset => "utf-8");
html_highlight_paste($paste);
$paste->{content} = [ split "\n", $paste->{content} ];

my $human_time = gmtime $paste->{time};
$paste->{time_ago} = ago(time() - $paste->{time});

my $tpl_vars =
    { view_paste => $paste,
      using_rewrite => $CONF{using_rewrite},
      request_uri => $ENV{REQUEST_URI},
    };

my $tt = Template->new({
    INCLUDE_PATH =>  'templates:templates/widgets',
    INTERPOLATE  =>  1,
    POST_CHOMP    => 1});

$tt->process('view.tpl', $tpl_vars)
    or die $tt->error(), "\n";
1;
