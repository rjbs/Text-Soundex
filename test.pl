# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..15\n"; }
END {print "not ok 1\n" unless $loaded;}
use Text::Soundex;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

$count = 1;

# 2 .. 7
#
# Knuth's test cases, scalar in, scalar out

@pairs = qw/Euler       E460
            Gauss       G200
            Hilbert     H416
            Knuth       K530
            Lloydi      L300
            Lukasiewicz L222
           /;

while (@pairs) {
  $count++;
  ($in, $expected) = splice @pairs, 0, 2;

  print "not " unless $expected eq soundex $in;
  print "ok $count\n";
}

# 8 .. 9
#
# check default "no code" code on a bad string and undef

for ('2 + 2 = 4', undef) {
  $count++;
  print "not " if defined (soundex $_);
  print "ok $count\n";
}

# 10 .. 11
#
# check list context with and without "no code"

@pairs = ([qw/Ellery Ghosh Heilbronn Kant Ladd Lissajous/],
          [qw/E460   G200  H416      K530 L300 L222     /],
          ['Mike', undef, 'Stok'],
          ['M200', undef, 'S320'],
         );

while (@pairs) {
  $count++;

  ($in, $expected) = splice @pairs, 0, 2;

  @out = soundex @$in;

  if (@out != @$expected) {
    print "not ";
  }
  else {
    while (@out) {
      if (defined ($out[0]) && defined ($expected->[0]) &&
          $out[0] ne $expected->[0]) {
        print "not ";
        last;
      }
      elsif ((defined ($out[0]) && !defined ($expected->[0])) ||
             (!defined ($out[0]) && defined ($expected->[0]))) {
        print "not ";
        last;
      }

      shift @out;
      shift @$expected;
    }
  }
  print "ok $count\n";
}

# 12 .. 13
#
# nocode
#
# check the deprecated $soundex_nocode and make sure it's reflected in
# the $Text::Soundex::nocode variable.

$nocodeValue = 'Z000';
$soundex_nocode = $nocodeValue;

$count++;
print "not " unless $nocodeValue eq soundex undef;
print "ok $count\n";

$count++;
print "not " unless $Text::Soundex::nocode eq $soundex_nocode;
print "ok $count\n";

# 14
#
# make sure an empty argument list returns an undefined scalar

$count++;
print "not " if defined (soundex ());
print "ok $count\n";

# 15
#
# test to detect an error in Mike Stok's original implementation, the
# error isn't in Mark Mielke's at all but the test should be kept anyway.
#
# originally spotted by Rich Pinder <rpinder@hsc.usc.edu>

$count++;
print "not " unless 'C622' eq soundex 'CZARKOWSKA';
print "ok $count\n";
