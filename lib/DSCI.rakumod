use v6;

unit module DSCI;

use YAMLish;

sub get-conf is export {

  my $conf-file = %*ENV<HOME> ~ '/dsci.yaml';

  my %conf = $conf-file.IO ~~ :f ?? load-yaml($conf-file.IO.slurp) !! Hash.new;

  #warn "rakudist web conf loaded: ", $conf-file;

  %conf;

}

sub http-root is export {

  %*ENV<DSCI_HTTP_ROOT> || "";

}
