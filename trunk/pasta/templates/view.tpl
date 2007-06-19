[% INCLUDE 'header.tpl' %]

<h3>Innsent av [% view_paste.name %], [% view_paste.time_ago %]</h3>

[% IF using_rewrite %]
    [% rw_prefix = "../" %]
[% END %]


<ul class="nav">
    <li><a href="[% rw_prefix %]index.pl">Send inn ny</a></li>
    <li><a href="[% rw_prefix %]list.pl">Alle innsente</a></li>
    <li><a href="[% request_uri %]&amp;plain">Vis som ren tekst</a></li>
</ul>

[% PROCESS 'view_paste.tpl'  %]
</div>

[% INCLUDE 'footer.tpl' %]
