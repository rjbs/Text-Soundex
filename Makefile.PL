# -*- perl -*-

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

use ExtUtils::MakeMaker;

WriteMakefile
    ('NAME'         => 'Text::Soundex',
     'VERSION_FROM' => 'Soundex.pm', # finds $VERSION
     'INSTALLDIRS'  => 'perl',
     'NORECURS'     => 1,
     'dist'         => { COMPRESS => "gzip -v9Nf",
			 SUFFIX   => "gz" },
     );
