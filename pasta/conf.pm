package conf;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(%CONF);
our %CONF;

$CONF{pastes_dir} = "pastes";
$CONF{list_size} = 100;
$CONF{default_anonymous} = "Anonym Kjøttbolle";
$CONF{vim_syntax_dir} = "/usr/share/vim/vimcurrent/syntax/";
$CONF{type_default} = "none";
$CONF{using_rewrite} = 1;

# Salt for password encryption. 
# Random data. Should be unique for installation.
$CONF{salt} = "dFEYHJjxhiR79y1KdIC6SA2dpMFtz1KlOTkwPf2m"; 

1;
