require DBI;

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..18\n"; }
END {print "not ok 1\n" unless $loaded;}
use DBD::Sprite;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

unlink "./test.sdb";

# 2: MAKE A TEST DATABASE.

system ("./makesdb.pl test test test \".\" \".stb\" \"\\r\\n\" \",\"") ? 
		print "not ok 2\n" : print "ok 2\n";
		
# 3: FETCH LIST OF DATABASES (SHOULD JUST BE ONE - OUR NEW TEST ONE)!

my @dataSources = DBI->data_sources('Sprite');
($#dataSources >= 0) ? print "ok 3\n" : print "not ok 3\n";

# 4: TEST CONNECT.
	
$dbh = DBI->connect('DBI:Sprite:test','test','test',{AutoCommit => 0}) || print "not ok 4\n";
print "ok 4\n"  if ($dbh);

# 5: DROP THE TEST TABLE, IF THERE (RERAN TEST).

$dbh->{PrintError} = 0;          #DON'T COMPLAIN THAT IT'S NOT THERE!
$res = $dbh->do('drop table testtable');
$dbh->{PrintError} = 1;
$res = $dbh->do(<<END_SQL);
	create table testtable (
		numfield  NUMBER(5), 
		charfield  CHAR(10), 
		vcharfield VARCHAR(20), 
			primary key (numfield)
	)
END_SQL
($res == 1) ? print "ok 5\n" : print "not ok 5\n";

# 6: (RE)CREATE A TEST TABLE NAMED "TESTTABLE".

$res = $dbh->do('create sequence testtable');
($res == 1) ?	print "ok 6\n" : print "not ok 6\n";

# 7: FETCH LIST OF ALL TABLES IN TEST DATABASE (SHOULD JUST BE ONE - TESTTABLE)!

my (@tables) = $dbh->tables();
($#tables == 0 && $tables[0] eq 'testtable') ?	print "ok 7\n" : 
		print "not ok 7\n";

# 8: PREPARE AN INSERT STATEMENT WITH BIND PARAMETERS.

$sth = $dbh->prepare(<<END_SQL);
	insert into testtable values (testtable.NEXTVAL, ?, ?) 
END_SQL
$sth ? print "ok 8\n" : print "not ok 8\n";

# 9-11: EXECUTE THE INSERT STATEMENT TO INSERT 3 SAMPLE DATA RECORDS.

$res = $sth->execute('REDS', 'Cincinatti');
($res == 1) ? print "ok 9\n" : print "not ok 9\n";

$res = $sth->execute('YANKEES', 'New York');
($res == 1) ?	print "ok 10\n" : print "not ok 10\n";

$res = $sth->execute('BRAVES', 'Atlanta');
($res == 1) ?	print "ok 11\n" : print "not ok 11\n";

$sth->finish();
$dbh->commit();

# 12: NOW PREPARE A SELECT QUERY TO FETCH BACK ONE OF THEM.

$sth = $dbh->prepare(<<END_SQL);
	select charfield, vcharfield 
	from testtable 
	where numfield = ? 
END_SQL
$sth ? print "ok 12\n" : print "not ok 12\n";

# 13: EXECUTE THE QUERY BINDING KEY VALUE=2.

$res = $sth->execute(2);
($res == 1) ? print "ok 13\n" : print "not ok 13\n";

# 14: FETCH THE TWO FIELDS OF THE RECORD BEING FETCHED AND SEE IF THEY ARE 
#     THE VALUES WE INSERTED!

my ($team, $city) = $sth->fetchrow_array();
($city eq 'New York' && $team eq 'YANKEES   ') ? print "ok 14\n" : 
		print "not ok 14($team/$city)\n";
$sth->finish();

# 15: NOW PREPARE A SELECT QUERY WITH A USER-DEFINED FUNCTION 
#     TO FETCH BACK ANOTHER ONE OF THEM.

use JSprite;

JSprite::fn_register('reverseUP',__PACKAGE__);

$sth = $dbh->prepare(<<END_SQL);
	select charfield, vcharfield 
	from testtable 
	where charfield like reverseUP(?) or charfield like 'x'
END_SQL
$sth ? print "ok 15\n" : print "not ok 15\n";

# 16: EXECUTE THE QUERY BINDING KEY VALUE=2.

$res = $sth->execute('%Sevarb');
($res == 1) ? print "ok 16\n" : print "not ok 16\n";

# 17: FETCH THE TWO FIELDS OF THE RECORD BEING FETCHED AND SEE IF THEY ARE 
#     THE VALUES WE INSERTED!

$sth->bind_columns(undef, \$team, \$city) ? print "ok 17\n" : print "not ok 17\n";

# 18: FETCH THE TWO FIELDS OF THE RECORD BEING FETCHED AND SEE IF THEY ARE 
#     THE VALUES WE INSERTED!

$sth->fetchrow_array();
($city eq 'Atlanta' && $team eq 'BRAVES    ') ? print "ok 18\n" : 
		print "not ok 18\n";
$sth->finish();

$dbh->disconnect();

sub reverseUP
{
		my ($t) = shift;
		$t =~ tr/a-z/A-Z/;
        return (scalar(reverse($t)));
}
