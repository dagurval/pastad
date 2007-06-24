package conf;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(%CONF);
our %CONF;

$CONF{pastes_dir} = "pastes";
$CONF{cache_dir} = "cache";
$CONF{list_size} = 100;
$CONF{default_anonymous} = "Anonym Kjøttbolle";
$CONF{vim_syntax_dir} = "/usr/share/vim/vimcurrent/syntax/";
$CONF{type_default} = "none";
$CONF{using_rewrite} = 1;
$CONF{use_hl_cache} = 1;

# Salt for password encryption. 
# Random data. Should be unique for installation.
$CONF{salt} = "DAS7Tf9hcBPGXdtMtGGkDv5SG1g0qD"; 

1;
