sub SUBSTR
{
	my ($s) = shift;
	my ($p) = shift;

	return ''  unless ($p);

	--$p  if ($p > 0);

	my ($l) = shift;
#print "-s=$s= p=$p= l=$l=\n";
#print "-lllllllllllllll=$l=\n"  unless ($l);
	return (substr($s, $p))  unless ($l);
	return substr($s, $p, $l);
}

sub LOWER
{
	my ($s) = shift;
	$s =~ tr/A-Z/a-z/;
	return $s;
}

sub UPPER
{
	my ($s) = shift;
	$s =~ tr/a-z/A-Z/;
	return $s;
}

sub TO_DATE
{
#print "<BR>TO_DATE called!\n";
	do 'to_date.pl';
	if ($err =~ /^Invalid/)
	{
		$errdetails = $err;
		$rtnTime = '';
		$self->display_error(-503);
	}
#print "<BR>err=$err= rtn=$rtnTime=\n";
	return $rtnTime;
}

sub CONCAT
{
#print "<BR>concat: args=$_[0]+$_[1]=\n";
	return $_[0].$_[1];
}

1
