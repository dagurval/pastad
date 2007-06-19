    <pre><ol>[% c = 0 %]
	[% FOREACH line IN view_paste.content %]<li><div class="[% IF c; "hl1"; ELSE; "hl2"; END %]">[% line || "&nbsp;" %]</div></li>[% c = 1 - c %][% END %]
	</ol>
    </pre>
