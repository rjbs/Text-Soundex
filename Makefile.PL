use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	   => 'Text::Soundex',
    'VERSION_FROM' => 'Soundex.pm', # finds $VERSION
    'INSTALLDIRS'  => 'perl',
);
