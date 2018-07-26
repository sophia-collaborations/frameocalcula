use strict;
use argola;
use me::parc;

my $tstart;
my $tstopo;
my $ttotal;
my $countor;

$tstart = &argola::getrg();
$tstopo = &argola::getrg();
$ttotal = &argola::getrg();

&me::parc::minutize($tstart);
&me::parc::minutize($tstopo);

print '0: ' . $tstart . "\n";

$countor = 1;
while ( $countor < ( $ttotal - 0.5 ) )
{
  print $countor . ': ';
  print ( $tstart + ( ( $tstopo - $tstart ) * ( $countor / $ttotal ) ) );
  print "\n";
  $countor = int($countor + 1.2);
}

print $ttotal . ': ' . $tstopo . "\n";


