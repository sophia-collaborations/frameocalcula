use strict;
use argola;
use me::parc;

my $time_needle;
my @sublayers = ( );

sub func__layer__do {
  my $lc_rg;
  my $lc_timeat;
  my @lc_nea;
  my @lc_neb;
  my $lc_nec;

  $lc_rg = $_[0];
  $lc_timeat = &me::parc::fetcho($lc_rg);
  &me::parc::trim($lc_rg);

  @lc_nea = ();
  @lc_neb = ();
  foreach $lc_nec (@sublayers)
  {
    if ( ($lc_nec->[0]) < $lc_timeat ) { @lc_nea = (@lc_nea,$lc_nec); }
    if ( ($lc_nec->[0]) > $lc_timeat ) { @lc_neb = (@lc_neb,$lc_nec); }
  }
  $lc_nec = [$lc_timeat,$lc_rg];
  @sublayers = (@lc_nea,$lc_nec,@lc_neb);

  return;
} &me::parc::setfunc('layer',\&func__layer__do);




&me::parc::universalopts();

&argola::runopts();

&me::parc::of_all_the_files();


