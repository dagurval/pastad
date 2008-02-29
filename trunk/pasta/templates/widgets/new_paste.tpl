[% common_syntax = [
    'none',
    'c',
    'java',
    'perl'
    'php',
    'sh',
    'py',
    'js'] %]

    <form action="paste.pl" method="post">
<p>   
    <ul id="postOptions">
    <li>
    Syntaks
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
    </li>
    <li>Passord<sup><a href="#" onClick="alert('Valgfritt. Brukes til å kunne slette innlegget.')">?</a></sup>
        <input type="password" name="passwd" />
    </li>
    </ul>
    
</p>
    <textarea style="width : 600px; height : 400px;" name="content"></textarea><br />
    </p>
    Tittel: <br /><input type="text" value="[% default_anonymous %]" 
	name="name" onclick="if (this.value == this.defaultValue) this.value = '';" /> 

    <input type="submit" value="Send inn" style="font-size : large; background : #edf4fb"  />
    <input type="hidden" value="post" name="do" />
    </form>
