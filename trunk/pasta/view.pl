#!/usr/bin/env perl
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
