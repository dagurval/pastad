[% INCLUDE 'header.tpl' %]
[% USE HTML %]
<h2>Pastes</h2>
<ul class="nav">
    <li><a href="index.pl">Send inn ny</a></li>
</ul>
<ul style="list-style-type : none; padding-left : 0;">
[% color = 0 %]
[% FOREACH pastes %]
	<li>
	    <div [% IF color %]style="background : #f4f4f4"[% END %]>
		<a href=
		    [% IF using_rewrite %]"/p/[% time %]"
		    [% ELSE %]"view.pl?p=[% time %]"
		    [% END %]
		><strong>[% HTML.escape(name) %]</strong></a>
	<br /><span style="font-size: small;"><em>Syntaks: [% HTML.escape(filetype) %], sent inn [% HTML.escape(time_ago) %]</em></div></li>
    [% color = 1 - color %]
[% END  %]
</ul>

    <ul class="nav">
	[% IF offset %]
	    [% IF (offset - list_size) < 0 %]
		[% prev = 0 %]
	    [% ELSE %]
		[% prev = offset - list_size %]
	    [% END %]
	    <li><a href="list.pl?offset=[% prev %]">Forrige side</a></li>
	[% END %]
	[% IF pastes.size == list_size %]
	    <li><a href="list.pl?offset=[% list_size + offset %]">Neste side</a></li>
	[% END %]
    </ul>
    
[% INCLUDE 'footer.tpl' %]
