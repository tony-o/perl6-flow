unit module Kangaroo::Utils::Cursor;

$_ = qx[stty -a </dev/tty 2>&1];
my $rows = +m/'rows '    <(\d+)>/;
my $cols = +m/'columns ' <(\d+)>/;

my %moves = 
  left  => 'tput cub1',
  right => 'tput cuf1',
  up    => 'tput cuu1',
  down  => 'tput cud1',
  home  => 'tput cr',
  tl    => 'tput home',
  eol   => "tput hpa $cols",
  br    => "tput cup $rows $cols";


sub left is export { mv(%moves<left>); }
sub right is export { mv(%moves<right>); }
sub up is export { mv(%moves<up>); }
sub down is export { mv(%moves<down>); }
sub home is export { mv(%moves<home>); }
sub tl is export { mv(%moves<tl>); }
sub eol is export { mv(%moves<eol>); }
sub br is export { mv(%moves<br>); }
