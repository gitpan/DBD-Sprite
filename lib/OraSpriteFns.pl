sub SUBSTR
{
	my ($s) = shift;
	my ($p) = shift;

	return ''  unless ($p);

	--$p  if ($p > 0);

	my ($l) = shift;
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

1
