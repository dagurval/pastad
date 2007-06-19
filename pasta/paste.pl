#!/usr/bin/env perl
use strict;
use warnings;

use CGI;
use Carp;
use Data::Dumper;

use conf;
use Paste qw(store_paste);

if (CGI::param('content')) {
    my $id;
    eval {
	$id = store_paste(
		CGI::param('filetype'), 
		CGI::param('name'),
		CGI::param('content'));
    };
    if ($@) {
	html_err("Unable to post: ", $@);
    }
    
    my $url = ($CONF{using_rewrite}) ? "/p/$id" : "view.pl?p=$id";
    print CGI::redirect($url);
}
else {
    html_err("There was no content in your paste. Try again.");
}

sub html_err {
    my $err = join " ", @_;
    print CGI::header(-type => "text/html", -charset => "utf-8");
    print "<html><body><h3>Error: ", $err, "</h3></body></html>";
    exit;
}

1;
