# -*- perl -*-

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

use ExtUtils::MakeMaker;
use File::Copy;

my $useXS = 1;

foreach (@ARGV) {
    /^--use-xs$/ && do {
	$useXS = 1;
	next;
    };

    /^--no-xs$/ && do {
	$useXS = 0;
	next;
    };

    warn "WARNING: Option $_ was not recognized. (ignoring)\n";
}

if ($useXS) {
    print "The XS code will be compiled.\n" if -t STDOUT;
    unlink('Soundex.xs') if -e 'Soundex.xs';
    copy('optional/Soundex.xs', 'Soundex.xs') ||
	die "Copy from optional/Soundex.xs -> Soundex.xs failed: $!\n";
} elsif (-e 'Soundex.xs') {
    print "The XS code will not be compiled.\n" if -t STDOUT;
    unlink('Soundex.xs') ||
	die "Unlink of Soundex.xs failed: $!\n";
}

WriteMakefile
    ('NAME'         => 'Text::Soundex',
     'VERSION_FROM' => 'Soundex.pm', # finds $VERSION
     'INSTALLDIRS'  => 'perl',
     'NORECURS'     => 1,
     'dist'         => { COMPRESS => "gzip -v9Nf",
			 SUFFIX   => "gz" },
     );
