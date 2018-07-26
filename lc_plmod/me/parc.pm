package me::parc;
use strict;
use argola;
use wraprg;


my @filegenda = ();
my %allcmd = {};

sub opto__f__do {
  @filegenda = (@filegenda,&argola::getrg());
}

sub setfunc {
  $allcmd{$_[0]} = $_[1];
}

sub of_all_the_files {
  my $lc_arg;
  my $lc_cm;
  my $lc_con;
  my @lc_mlin;
  my $lc_eline;

  foreach $lc_arg (@filegenda)
  {
    $lc_cm = 'cat ' . &wraprg::bsc($lc_arg);
    $lc_con = `$lc_cm`;
    @lc_mlin = split(/\n/,$lc_con);
    foreach $lc_eline (@lc_mlin)
    {
      &do_the_cm($lc_eline);
    }
  }
}

sub do_the_cm {
  my $lc_cmlin;
  my $lc_cmtp;
  my $lc_functo;

  $lc_cmlin = 'xxx' . $_[0];
  &fetcho($lc_cmlin);
  $lc_cmtp = &fetcho($lc_cmlin);

  # If it is empty, it is a comment.
  if ( $lc_cmtp eq '' ) { return; }

  # If it is a valid command, run it.
  if ( exists($allcmd{$lc_cmtp}) )
  {
    $lc_functo = $allcmd{$lc_cmtp};
    return &$lc_functo($lc_cmlin);
  }

  die("\nNo such registered function: " . $lc_cmtp . " :\n\n");
}

sub universalopts {
  &argola::setopt('-f',\&opto__f__do);
}


sub competra {
  my $lc_nloc;
  $lc_nloc = index $_[2], $_[3];
  if ( $lc_nloc < $_[0] )
  {
    if ( $lc_nloc > ( 0 - 0.5 ) )
    {
      $_[0] = $lc_nloc;
      $_[1] = $_[3];
    }
  }
  if ( $_[0] < ( 0 - 0.5 ) )
  {
    $_[0] = $lc_nloc;
    $_[1] = $_[3];
  }
}

sub trim {
  my $lc_a;
  $lc_a = scalar reverse ($_[0]);
  $lc_a = 'xxx' . $lc_a;
  &fetcho($lc_a);
  $_[0] = scalar reverse $lc_a;
}


sub fetcho {
  my $lc_a;
  my $lc_b;
  my $lc_win_pos;
  my $lc_win_chr;
  $lc_win_pos = -1;
  $lc_win_chr = ':';
  #&competra($lc_win_pos,$lc_win_chr,$_[0],':');
  &competra($lc_win_pos,$lc_win_chr,$_[0],'/');
  ($lc_a,$lc_b) = split(quotemeta($lc_win_chr),$_[0],2);
  $_[0] = $lc_b;
  return $lc_a;
}

sub minutize {
  # Run this function on a variable to convert it from
  # minutes-seconds format to pure seconds format.
  my $lc_src;
  my @lc_seg;
  my $lc_ret;
  my $lc_each;
  my $lc_intm;
  $lc_src = $_[0];
  @lc_seg = split(quotemeta(':'),$lc_src);
  $lc_ret = 0;

  foreach $lc_each (@lc_seg)
  {
    $lc_intm = int(($lc_ret * 60) + 0.2);
    $lc_ret = $lc_intm + $lc_each;
  }

  $_[0] = $lc_ret;
}

1;

