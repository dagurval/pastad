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

use CGI;
use Carp;
use Data::Dumper;
use Cache;

use conf;
use Paste qw(store_paste delete_paste);
use Cache qw(is_cached cache_remove);

my $do = CGI::param('do');

if ($do eq "post") {
    if (CGI::param('content')) {
        my $id;
        eval {
            $id = store_paste(
                    CGI::param('filetype'), 
                    CGI::param('name'),
                    CGI::param('content'),
                    CGI::param('passwd'));
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
}

elsif ($do eq "del") {
        my ($id, $passwd) = (CGI::param('id'), CGI::param('passwd'));
        eval { delete_paste($id, $passwd) };
        cache_remove($id) if is_cached($id);
        html_err($@) if ($@);

        print CGI::header("text/html");
        print "<html><body><h3>Post deleted.</h3></body></html>";
}
    
else {
    html_err("Don't know what to do");
}

sub html_err {
    my $err = join " ", @_;
    print CGI::header(-type => "text/html", -charset => "utf-8");
    print "<html><body><h3>Error: ", $err, "</h3></body></html>";
    exit;
}

1;
