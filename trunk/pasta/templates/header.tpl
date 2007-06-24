<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
[% rw_prefix = "../" IF using_rewrite %]
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <title>[% IF title.defined %][% title %] - [% END %]Pasta</title>
    <link rel="stylesheet" href="style.css" type="text/css" />
    <link rel="stylesheet" href="vim_light.css" type="text/css" />
    <script type="text/javascript">
	function del_post(id) {
	    var passwd = prompt("Passord for sletting:");
	    if (!passwd) return;
	    window.location = "[% rw_prefix %]paste.pl?do=del&id=" + id + "&passwd=" + passwd;
	}
    </script>
</head>


<body>
