use strict;
use argola;
use me::parc;

my $time_needle_main;
my $time_needle_fram;
my @sublayers = ( );
my $max_set = 0;
my $max_is;
my $yet_intag;

$time_needle_main = ( 0 - 1 );
$time_needle_fram = ( 0 - 1 );

sub func__max__do {
  my $lc_rg;
  $lc_rg = $_[0];
  $max_set = 10;
  $max_is = &me::parc::fetcho($lc_rg);
} &me::parc::setfunc('max',\&func__max__do);

sub func__ctalk__do {
  # The 'ctalk' function is a modified version of the 'talk'
  # function where the new talk segment rather than having
  # its beginning specified in the directive instead simply
  # picks up where the previous 'talk' or 'ctalk' instance
  # left off.
  my $lc_rg;
  my $lc_time_start;
  my $lc_time_stop;
  my $lc_sylb_remain;
  my $lc_time_remain;

  $lc_rg = $_[0];
  $lc_time_start = $time_needle_main;
  $lc_time_stop = &me::parc::fetcho($lc_rg);
  $lc_sylb_remain = &me::parc::fetcho($lc_rg);
  $lc_time_remain = ( $lc_time_stop - $lc_time_start );

  # Now, without the Sonic Screwdriver, we will deal with
  # all Time Anomilies.
  if ( $lc_time_stop <= $lc_time_start )
  {
    die "\nAnd time must ALWAYS move forward.\n";
  }
  $time_needle_main = $lc_time_stop;


  while ( $lc_sylb_remain > 1.5 )
  {
    my $lc2_neosylb;
    my $lc2_time_rem;
    my $lc2_time_neo;

    $lc2_neosylb = int($lc_sylb_remain - 0.8);
    $lc2_time_rem = ( $lc_time_remain * ( $lc2_neosylb / $lc_sylb_remain ) );
    $lc2_time_neo = ( $lc_time_stop - $lc2_time_rem );

    &talk_a_flower($lc_time_start,$lc2_time_neo);

    $lc_time_start = $lc2_time_neo;
    $lc_time_remain = $lc2_time_rem;
    $lc_sylb_remain = $lc2_neosylb;
  }
  &talk_a_flower($lc_time_start,$lc_time_stop);
} &me::parc::setfunc('ctalk',\&func__ctalk__do);

sub func__talk__do {
  my $lc_rg;
  my $lc_time_start;
  my $lc_time_stop;
  my $lc_sylb_remain;
  my $lc_time_remain;

  $lc_rg = $_[0];
  $lc_time_start = &me::parc::fetcho($lc_rg);
  $lc_time_stop = &me::parc::fetcho($lc_rg);
  $lc_sylb_remain = &me::parc::fetcho($lc_rg);
  $lc_time_remain = ( $lc_time_stop - $lc_time_start );

  # Now, without the Sonic Screwdriver, we will deal with
  # all Time Anomilies.
  if ( $lc_time_start < $time_needle_main )
  {
    die "\nTime may only move forward, not backward.\n\n";
  }
  if ( $lc_time_stop <= $lc_time_start )
  {
    die "\nAnd time must ALWAYS move forward.\n";
  }
  $time_needle_main = $lc_time_stop;


  while ( $lc_sylb_remain > 1.5 )
  {
    my $lc2_neosylb;
    my $lc2_time_rem;
    my $lc2_time_neo;

    $lc2_neosylb = int($lc_sylb_remain - 0.8);
    $lc2_time_rem = ( $lc_time_remain * ( $lc2_neosylb / $lc_sylb_remain ) );
    $lc2_time_neo = ( $lc_time_stop - $lc2_time_rem );

    &talk_a_flower($lc_time_start,$lc2_time_neo);

    $lc_time_start = $lc2_time_neo;
    $lc_time_remain = $lc2_time_rem;
    $lc_sylb_remain = $lc2_neosylb;
  }
  &talk_a_flower($lc_time_start,$lc_time_stop);
} &me::parc::setfunc('talk',\&func__talk__do);

# <animated type="string">

sub func__olayr__do {
  my $lc_rg;
  my $lc_timeat;
  my @lc_nea;
  my @lc_neb;
  my $lc_nec;

  if ( $yet_intag > 5 )
  {
    die(
      "\nCan not have more than one 'olayr' "
    . "directive.\nPlease use a 'layer' "
    . "directive instead.\n\n"
    );
  }
  $yet_intag = 10;


  $lc_rg = $_[0];
  $lc_timeat = &me::parc::fetcho($lc_rg);
  &me::parc::trim($lc_rg);

  # BEGINNING THE START-OF-ANIMATION
  print '<animated type="string">' . "\n";
  print '<waypoint time="0s" before="clamped" after="clamped">
<string>' . $lc_rg . '</string>
</waypoint>' . "\n";
  # FINISHING THE START-OF-ANIMATION

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
} &me::parc::setfunc('olayr',\&func__olayr__do);

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



# #############################################



sub talk_a_flower {
  my $lc_diffra;
  my $lc_item;
  my $lc_elaps;
  my $lc_atto;

  #print $_[0] . ' ----- ' . $_[1] . " :\n"; # DEBUG
  $lc_diffra = ( $_[1] - $_[0] );
  foreach $lc_item (@sublayers)
  {
    $lc_elaps = ( $lc_diffra * ( $lc_item->[0] ) );
    $lc_atto = ( $lc_elaps + $_[0] );
    &talk_a_petal($lc_atto,($lc_item->[1]));
  }
}

sub talk_a_petal {
  #print "-- " . $_[0] . ' - ' . $_[1] . " :\n"; # DEBUG
  print "<waypoint time=\"" . $_[0];
  print "s\" before=\"clamped\" after=\"clamped\">\n<string>";
  print $_[1] . "</string>\n</waypoint>\n";
}


# #############################################


&me::parc::universalopts();

&argola::runopts();

&me::parc::of_all_the_files();

if ( $yet_intag > 5 )
{
  print "</animated>\n";
}




