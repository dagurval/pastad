[% USE HTML %]
<div id="simple_list">
    <h3 style="margin: 0; padding : 0;">Recent pastes</h3>
    <ul style="margin-top : 0;">
	[% FOREACH pastes %]
	<li><a href="view.pl?p=[% time %]"><strong>[% HTML.escape(name) %]</strong></a> 
	    [% IF filetype %]([% HTML.escape(filetype) %])[% END %] [% HTML.escape(time_ago) %]</li>
	[% END #foreach %]
    </ul>
    <a href="list.pl">View full list</a>
</div>
