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

sub LOWER
{
	#@_ = &chkcolumnparms(@_);
	my ($s) = shift;
	$s =~ tr/A-Z/a-z/;
	return $s;
}

sub UPPER
{
	#@_ = &chkcolumnparms(@_);
	my ($s) = shift;
	$s =~ tr/a-z/A-Z/;
	return $s;
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

sub CONCAT
{

	#@_ = &chkcolumnparms(@_);
	return $_[0].$_[1];
}

1
