use strict;
use argola;
use wraprg;
use me::parc;

my $startsecond = 0;
my $frambsec = 24;
my $charsin = 6;

my @allfiles = ();

my $fcount_talk_do = 0;

sub opto__f__do {
  @allfiles = (@allfiles,&argola::getrg());
}; &argola::setopt('-f',\&opto__f__do);

sub opto__chr__do {
  $charsin = &argola::getrg();
} &argola::setopt('-chr',\&opto__chr__do);

&argola::runopts();

{
  my $lc_a;
  foreach $lc_a (@allfiles) { &eachoffiles($lc_a); }
}
sub eachoffiles {
  my $lc_cm;
  my $lc_conta;
  my @lc_contb;
  my $lc_contc;
  $lc_cm = 'cat ' . &wraprg::bsc($_[0]);
  $lc_conta = `$lc_cm`;
  @lc_contb = split(/\n/,$lc_conta);
  foreach $lc_contc (@lc_contb)
  {
    &borealis($lc_contc);
  }
};

sub borealis {
  my $lc_conto;
  my $lc_comd;
  $lc_conto = $_[0];
  &me::parc::fetcho($lc_conto); # Toss everything before the first colon:
  $lc_comd = &me::parc::fetcho($lc_conto);
  if ( $lc_comd eq '' ) { return; }

  if ( $lc_comd eq 'talk' ) { return(&func__talk__do($lc_conto)); }
  
  die("\nNo such command: :" . $lc_comd . ":\n\n");
}

sub framerend {
  my $lc_remo; # Remaining from original string
  my $lc_reto; # What is to be returned;
  my $lc_rcount; # Num of characters remaining
  my $lc_chr; # Current Character
  my $lc_rawo; # Second-time adjusted for start-time
  $lc_rawo = ( $_[0] - $startsecond );
  if ( $lc_rawo < 0 ) { return 'xxxx'; }
  $lc_remo = int( ( $lc_rawo * $frambsec ) + 0.45);
  $lc_reto = '';
  $lc_rcount = $charsin;
  while ( $lc_rcount > 0.5 )
  {
    $lc_remo = '00' . $lc_remo;
    $lc_chr = chop($lc_remo);
    $lc_reto = $lc_chr . $lc_reto;
    $lc_rcount = int($lc_rcount - 0.8);
  }
  if ( $lc_remo > 0.5 ) { $lc_reto = 'zz ' . $lc_remo . $lc_reto; }
  return $lc_reto;
}

sub frameout {
  print &framerend($_[0]);
  print ' :';
  if ( $_[2] ne '' )
  {
    print $_[2] . ':';
  }
  print ' ';
  print $_[1];
  print "\n";
}

sub func__talk__do {
  my $lc_conto;
  my $lc_cur_point;
  my $lc_end_point;
  my $lc_seg_remain;
  my $lc_sylb_count;
  my $lc_nseg_remain;
  my $lc_dist_remain;
  my $lc_ndist_remain;
  my $lc_mdist_remain;

  $lc_sylb_count = 0;
  $lc_conto = $_[0];
  $fcount_talk_do = int($fcount_talk_do + 1.2);
  $lc_cur_point = &me::parc::fetcho($lc_conto);
  $lc_end_point = &me::parc::fetcho($lc_conto);
  $lc_seg_remain = &me::parc::fetcho($lc_conto);
  &frameout($lc_cur_point,('Talk Segment ' . $fcount_talk_do . ': ' . $lc_conto),'a');
  if ( $lc_seg_remain < 0.5 )
  {
    &frameout($lc_cur_point,('Start Empty Talk #' . $fcount_talk_do),'b');
    &frameout($lc_end_point,('End Empty Talk #' . $fcount_talk_do),'d');
    return;
  }
  $lc_dist_remain = ( $lc_end_point - $lc_cur_point );
  while ( $lc_seg_remain > 0.5 )
  {
    my $lc2_aa;
    $lc_nseg_remain = int($lc_seg_remain - 0.8);
    $lc_ndist_remain = ( $lc_dist_remain * ( $lc_nseg_remain / $lc_seg_remain ) );
    $lc_mdist_remain = ( ( $lc_dist_remain + $lc_ndist_remain ) / 2 );

    $lc2_aa = ( $lc_end_point - $lc_dist_remain );
    &frameout($lc2_aa,('CLOSED Talk Segment: ' . $fcount_talk_do . '-' . $lc_sylb_count . '-A closed'),'b');
    $lc2_aa = ( $lc_end_point - $lc_mdist_remain );
    &frameout($lc2_aa,('OPEN Talk Segment: ' . $fcount_talk_do . '-' . $lc_sylb_count . '-B open'),'c');

    $lc_dist_remain = $lc_ndist_remain;
    $lc_seg_remain = $lc_nseg_remain;
  }
  $lc_sylb_count = int($lc_sylb_count + 1.2);
  &frameout($lc_end_point,('CLOSED Talk Segment: ' . $fcount_talk_do . '-' . $lc_sylb_count . '-F closed'),'d');
}









