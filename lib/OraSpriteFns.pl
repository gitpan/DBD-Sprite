sub ABS
{
	return abs(shift);
}

sub ASCII
{
	return ord(shift);
}

sub CHR
{
	return chr(shift);
}

sub CONCAT
{

	#@_ = &chkcolumnparms(@_);
	#return $_[0].$_[1];
	return join('',@_);
}

sub COS
{
	return cos(shift);
}

sub FLOOR
{
	return int(shift);
}

sub INITCAP
{
	my ($s) = shift;
	$s =~ s/\b(\w)(\w*)/\U$1\L$2\E/g;
	return $s;
}

sub LENGTH
{
	return length(shift);
}

sub LENGTHB
{
	return length(shift);
}

sub LTRIM
{
	my ($x, $y) = @_;
	$x =~ s/^[$y]+//;
	return $x;
}

sub LOWER
{
	#@_ = &chkcolumnparms(@_);
	my ($s) = shift;
	$s =~ tr/A-Z/a-z/;
	return $s;
}

sub MOD
{
	my ($m, $n) = @_;
	return $m  unless ($n);
	return $m % $n;
}

sub POWER
{
	return $_[0] ** $_[1];
}

sub REPLACE
{
	my ($s, $x, $y) = (@_[0..2]);
	if ($_[3] eq 'i')
	{
		$s =~ s/\Q$x\E/\Q$y\E/ig;   #SPRITE EXTENSION, NOT SUPPORTED IN ORACLE!
	}
	else
	{
		$s =~ s/\Q$x\E/\Q$y\E/g;
	}
	return $s;
}

sub ROUND
{
	my ($m, $n) = @_;
	return sprintf("%.${n}f", $m)  if ($n >= 0);
	$m *= 10 ** $n;
	return (1 * sprintf('%.0f', $m)) / (10 ** $n);
}

sub RTRIM
{
	my ($x, $y) = @_;
	$x =~ s/[$y]+$//;
	return $x;
}

sub SIGN
{
	return -1  if ($_[0] < 0);
	return 0   unless ($_[0]);
	return 1;
}

sub SIN
{
	return sin(shift);
}

sub SUBSTR
{
	#@_ = &chkcolumnparms(@_);
	my ($s) = shift;
	my ($p) = shift;
	#($s, $p) = &chkcolumnparms(@_);

	return ''  unless ($p);

	--$p  if ($p > 0);

	my ($l) = shift;
	return (substr($s, $p))  unless ($l);
	return substr($s, $p, $l);
}

sub SUBSTRB
{
	return SUBSTR(@_);
}

sub TAN
{
	return tan(shift);
}

sub TO_CHAR
{
	do 'to_char.pl';
	if ($err =~ /^Invalid/)
	{
		$errdetails = $err;
		$rtnTime = '';
		$self->display_error(-503);
	}
	return $rtnTime;
}

sub TO_DATE
{
	#@_ = &chkcolumnparms(@_);
	do 'to_date.pl';
	if ($err =~ /^Invalid/)
	{
		$errdetails = $err;
		$rtnTime = '';
		$self->display_error(-503);
	}
	return $rtnTime;
}

sub TO_NUMBER
{
	$rtnTime = shift;
	my $fmt = shift;

	my $fmtstr = 'f';
	$fmtstr = $1  if ($rtnTime =~ s/(e)eee//i);
	$rtnTime =~ s/[^\d\.\+\-Vv]//g;
	my $dec = 0;
	$dec = length($2)  if ($fmt =~ /([\d\+\-]*)V(\d*)/);
	my ($dec) = length($2);
	$rtnTime *= (10 ** $dec);
	return sprintf('%.0f',$rtnTime);   #ROUND IT.
	return $rtnTime;
}

sub TRANSLATE
{
	my ($s, $a, $b) = @_;
	eval "\$s =~ tr/$a/$b/d";
	return $s;
}

sub TRUNC
{
	my ($m, $n) = @_;
	return int($m * (10 ** $n)) / (10 ** $n);
}

sub UPPER
{
	#@_ = &chkcolumnparms(@_);
	my ($s) = shift;
	$s =~ tr/a-z/A-Z/;
	return $s;
}

1
