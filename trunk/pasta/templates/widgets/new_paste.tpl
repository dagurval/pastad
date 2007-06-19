[% common_syntax = [
    'none',
    'java',
    'perl'
    'php',
    'c' ] %]

    <form action="paste.pl" method="post">
<p>   
     Syntaks:
    <select name="filetype">
    [% FOREACH type IN common_syntax %]
	<option>[% type %]</option>
    [% END %]
    <option>---</option>
    [% FOREACH type IN types %]
    <option
	[% IF type == type_default %] selected="selected" [% END %]
	>[% type %]</option>
    [% END %]
    </select>
</p>
    <textarea style="width : 600px; height : 400px;" name="content"></textarea><br />
    </p>
    Ditt navn: <br /><input type="text" value="[% default_anonymous %]" 
	name="name" onclick="if (this.value == this.defaultValue) this.value = '';" /> 

    <input type="submit" value="Send inn" style="font-size : large; background : #edf4fb"  />
    </form>
