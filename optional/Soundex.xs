/* -*- c -*- */

/* (c) Copyright 1998 by Mark Mielke
 *
 * Freedom to use these sources for whatever you want, as long as credit
 * is given where credit is due, is hereby granted. You may make modifications
 * where you see fit but leave this copyright somewhere visible. As well try
 * to initial any changes you make so that if i like the changes i can
 * incorporate them into any later versions of mine.
 *
 *      - Mark Mielke <markm@nortel.ca>
 */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define SOUNDEX_ACCURACY (4)	/* The maximum code length... (should be>=2) */

static char *soundex_table =
  /*ABCDEFGHIJKLMNOPQRSTUVWXYZ*/
   "01230120022455012623010202";

static SV *sv_soundex (source)
     SV *source;
{
  char *p;
  STRLEN p_left;

  /* Skip to the interesting stuff... */
  p = (char *) SvPV(source, p_left);
  while (p_left && !isalpha(*p))
    p++, p_left--;

  /* We have a "nocode" here... */
  if (p_left == 0)
    return SvREFCNT_inc(perl_get_sv("Text::Soundex::nocode", FALSE));

  {
    register int code_left = (SOUNDEX_ACCURACY-1);
    register char *code, *code_p, last_code;

    New(0, code, SOUNDEX_ACCURACY + 1, char);
    code_p = &code[0];

    /* Always count first letter as special... (and record the last_code) */
    last_code = soundex_table[(*code_p++ = toupper(*p)) - 'A'];
    p++, p_left--;

    while (p_left && code_left)
      {
	/* If it's not an alphabetic we skip it totally... */
	if (!isalpha(*p))
	  {
	    p++, p_left--;
	    continue;
	  }

	/* Save the current code... */
	*code_p = soundex_table[toupper(*p) - 'A'];
	p++, p_left--;

	/* Make sure the current code isn't a duplicate... */
	if (last_code == *code_p)
	  continue;

	/* The sound only counts if it's not bogus... */
	if ((last_code = *code_p) != '0')
	  code_p++, code_left--;
      }

    /* Pad with 0's */
    while (code_left)
      *code_p++ = '0', code_left--;

    /* Don't forget the null... */
    *code_p = '\0';

    return newSVpv(code, SOUNDEX_ACCURACY);
  }
}

MODULE = Text::Soundex				PACKAGE = Text::Soundex

PROTOTYPES: DISABLE

void
soundex_xs (...)
PPCODE:
{
  int i;
  for (i = 0; i < items; i++)
    PUSHs(sv_2mortal(sv_soundex(ST(i))));
}
