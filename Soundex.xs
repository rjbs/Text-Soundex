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
    SV *code = newSV(SOUNDEX_ACCURACY);
    register int code_left = (SOUNDEX_ACCURACY-1);
    register char *codep = SvPVX(code);
    register char last_code;

    /* Always count first letter as special... (and record the last_code) */
    last_code = soundex_table[(*codep++ = toupper(*p)) - 'A'];
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
	*codep = soundex_table[toupper(*p) - 'A'];
	p++, p_left--;

	/* Make sure the current code isn't a duplicate... */
	if (last_code == *codep)
	  continue;

	/* The sound only counts if it's not bogus... */
	if ((last_code = *codep) != '0')
	  codep++, code_left--;
      }

    /* Pad with 0's */
    while (code_left)
      *codep++ = '0', code_left--;

    /* Finish setting up the SV... */
    SvCUR_set(code, SOUNDEX_ACCURACY);
    *SvEND(code) = '\0';
    (void)SvPOK_only(code);

    return code;
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
