use DBI 1.03;
use DBI::DBD;
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'DBD::Sprite',
    'VERSION_FROM' => 'lib/DBD/Sprite.pm', # finds $VERSION
    'INC'	=> $DBI_INC_DIR,
	'EXE_FILES' => ['makesdb.pl'],
    'dist'	=> { 'SUFFIX' => '.gz',
		     'COMPRESS' => 'gzip -9f' },
    #'realclean'	=> '*.xsi'
    'realclean'	=> {FILES => '*.xsi'}
);

package MY;
sub postamble { "\n" . DBI::DBD::dbd_postamble(@_); }

sub libscan {
	my ($self, $path) = @_;
	($path =~ /\~$/) ? undef : $path;
}

