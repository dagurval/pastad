package conf;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(%CONF);
our %CONF;

$CONF{pastes_dir} = "pastes";
$CONF{list_size} = 100;
$CONF{default_anonymous} = "Anonym Kjøttbolle";
$CONF{vim_syntax_dir} = "/usr/share/vim/vimcurrent/syntax/";
$CONF{type_default} = "perl";
$CONF{using_rewrite} = 1;

1;
