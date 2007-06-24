[% INCLUDE 'header.tpl' %]

<h3>Innsent av [% view_paste.name %], [% view_paste.time_ago %]</h3>

[% IF using_rewrite %]
    [% rw_prefix = "../" %]
[% END %]


<ul class="nav">
    <li>
	[% IF view_paste.passwd %]<a href="javascript:del_post('[% view_paste.time %]')">Slett</a>
	[% ELSE %]Slett
	[% END %]
    </li>
    <li><a href="[% rw_prefix %]index.pl">Send inn ny</a></li>
    <li><a href="[% rw_prefix %]list.pl">Alle innsente</a></li>
    <li><a href="[% request_uri %]&amp;plain">Vis som ren tekst</a></li>
</ul>

[% PROCESS 'view_paste.tpl'  %]

[% INCLUDE 'footer.tpl' %]
