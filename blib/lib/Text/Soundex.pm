package Text::Soundex;
require 5.000;

use DynaLoader;
use Exporter;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK $nocode $soundex_nocode);

@ISA       = qw(Exporter DynaLoader);
@EXPORT    = qw(&soundex $soundex_nocode);
    
$VERSION   = '2.13';

$nocode    = undef;
*soundex_nocode = \$nocode; # Alias for compatibility reasons.

sub soundex_noxs
{
    my @results = map {
    my $code = uc($_);
    my $firstchar = substr($code, 0, 1);
    $code =~ tr/A-Z//cd;

    if (length($code)) {
        $code =~ tr{AEHIOUWYBFPVCGJKQSXZDTLMNR}
                       {00000000111122222222334556}s;
        ($code = substr($code, 1)) =~ tr/0//d;
        substr($firstchar . $code . '000', 0, 4);
    } else {
        $nocode;
    }
    } @_;

    wantarray ? @results : $results[0];
}

{
    eval { __PACKAGE__->bootstrap() };
    if (defined(&soundex_xs)) {
    *soundex = \&soundex_xs;
    } else {
    *soundex = \&soundex_noxs;
    *soundex_xs = sub {
        require Carp;
        Carp::croak("The XS code for Text::Soundex was not compiled for ".
                        "this platform.\nsoundex_xs() may therefore not be ".
            "used");
    };
    }
}

1;

__END__

# Implementation of soundex algorithm as described by Knuth in volume
# 3 of The Art of Computer Programming.
#
# Perl re-coded by Mark Mielke <markm@nortel.ca> who both noticed the lack
# of speed and took the time to re-code it to take advantage of some "modern"
# perl features. As well he has written XS code to implement the soundex
# code at a speed approx. 7X faster.
#
# Mark Mielke <markm@nortel.ca>, 2 March 1998.
#
# Knuth's test cases are:
#
# Euler, Ellery -> E460
# Gauss, Ghosh -> G200
# Hilbert, Heilbronn -> H416
# Knuth, Kant -> K530
# Lloyd, Ladd -> L300
# Lukasiewicz, Lissajous -> L222
#

=head1 NAME

Text::Soundex - Implementation of the Soundex Algorithm as Described by Knuth

=head1 SYNOPSIS

  use Text::Soundex;

  $code = soundex $string;    # get soundex code for a string
  @codes = soundex @list;     # get list of codes for list of strings

  # set value to be returned for strings without soundex code

  $Text::Soundex::nocode = 'Z000';

=head1 DESCRIPTION

This module implements the soundex algorithm as described by Donald Knuth
in Volume 3 of B<The Art of Computer Programming>.  The algorithm is
intended to hash words (in particular surnames) into a small space using a
simple model which approximates the sound of the word when spoken by an English
speaker.  Each word is reduced to a four character string, the first
character being an upper case letter and the remaining three being digits.

The value returned for strings which have no soundex encoding is set in
the scalar C<$Text::Soundex::nocode>.  This is initially set to C<undef>,
but many people seem to prefer an I<unlikely> value like C<Z000>
(how unlikely this is depends on the data set being dealt with.)  Any value
can be assigned to C<$Text::Soundex::nocode>.

For backward compatibility with older versions of this module the
C<$Text::Soundex::nocode> is exported into the caller's namespace
as C<$soundex_nocode>.

In scalar context C<soundex> returns the soundex code of its first
argument, and in array context a list is returned in which each element is the
soundex code for the corresponding argument passed to C<soundex> e.g.

  @codes = soundex qw(Mike Stok);

leaves C<@codes> containing C<('M200', 'S320')>.

=head1 EXAMPLES

Knuth's examples of various names and the soundex codes they map to
are listed below:

  Euler, Ellery -> E460
  Gauss, Ghosh -> G200
  Hilbert, Heilbronn -> H416
  Knuth, Kant -> K530
  Lloyd, Ladd -> L300
  Lukasiewicz, Lissajous -> L222

so:

  $code = soundex 'Knuth';         # $code contains 'K530'
  @list = soundex qw(Lloyd Gauss); # @list contains 'L300', 'G200'

=head1 UNDERNEATH THE COVERS (a word from Mark)

To ease use for the user, the XS version is transparently accessible via
soundex() when it exists for the current platform. Basically what this
means is that if you are on a platform with XS code compiled, the call
to soundex() will complete about 7X faster. If for whatever reason you
care, and you want to choose which code to use, I have provided access
to the individual calls.

     # The following calls are split up by functionality.

     # Always uses the 100% perl version.
     ... = Text::Soundex::soundex_noxs(...);   

     # Always uses the XS version. (7X faster)
     ... = Text::Soundex::soundex_xs(...);

     # Use the XS version if possible, otherwise
     # it will revert to the 100% perl version.
     ... = Text::Soundex::soundex(...);
   
=head1 LIMITATIONS

As the soundex algorithm was originally used a B<long> time ago in the US
it considers only the English alphabet and pronunciation.

As it is mapping a large space (arbitrary length strings) onto a small
space (single letter plus 3 digits) no inference can be made about the
similarity of two strings which end up with the same soundex code.  For
example, both C<Hilbert> and C<Heilbronn> end up with a soundex code
of C<H416>.

=head1 AUTHOR

This code was originally implemented by Mike Stok (C<mike@stok.co.uk>)
as an example of unreadable perl 4 code and refined into a library.
The code is now maintained by Mark Mielke <markm@nortel.ca> who recast
the code and made it speedy in 1997. Mark has since added the XS code to
accomplish the encoding at a speed upwards of 7X faster. Please
report any bugs or other to Mark Mielke <markm@nortel.ca>.

Ian Phillips (C<ian@pipex.net>) and Rich Pinder (C<rpinder@hsc.usc.edu>)
supplied ideas and spotted mistakes for v1.x.

=cut
