# This Makefile is for the Text::Soundex extension to perl.
#
# It was generated automatically by MakeMaker version
# 2.20 (Revision: ) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#	ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker Parameters:

#	C => [q[Soundex.c]]
#	INSTALLDIRS => q[perl]
#	NAME => q[Text::Soundex]
#	NORECURS => q[1]
#	VERSION_FROM => q[Soundex.pm]
#	XS => { Soundex.xs=>q[Soundex.c] }
#	dist => { COMPRESS=>q[gzip -v9Nf], SUFFIX=>q[gz] }

# --- MakeMaker constants section:
NAME = Text::Soundex
DISTNAME = Text-Soundex
NAME_SYM = Text_Soundex
VERSION = 2.20
VERSION_SYM = 2_20
XS_VERSION = 2.20
INST_LIB = ::::lib
INST_ARCHLIB = ::::lib
PERL_LIB = ::::lib
PERL_SRC = ::::
PERL = ::::miniperl
FULLPERL = ::::perl
SOURCE =  Soundex.c

MODULES = Soundex.pm


.INCLUDE : $(PERL_SRC)BuildRules.mk


# FULLEXT = Pathname for extension directory (eg DBD:Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT.
# ROOTEXT = Directory part of FULLEXT (eg DBD)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
FULLEXT = Text:Soundex
BASEEXT = Soundex
ROOTEXT = Text:

# Handy lists of source code files:
XS_FILES= Soundex.xs
C_FILES = Soundex.c
H_FILES = 


.INCLUDE : $(PERL_SRC)ext:ExtBuildRules.mk


# --- MakeMaker dlsyms section:

dynamic :: Soundex.exp


Soundex.exp: Makefile.PL
	$(PERL) "-I$(PERL_LIB)" -e 'use ExtUtils::Mksymlists; Mksymlists("NAME" => "Text::Soundex", "DL_FUNCS" => {  }, "DL_VARS" => []);'


# --- MakeMaker dynamic section:

all :: dynamic

install :: do_install_dynamic

install_dynamic :: do_install_dynamic


# --- MakeMaker static section:

all :: static

install :: do_install_static

install_static :: do_install_static


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean ::
	$(RM_RF) Soundex.c
	$(MV) Makefile.mk Makefile.mk.old


# --- MakeMaker realclean section:

# Delete temporary files (via clean) and also delete installed files
realclean purge ::  clean
	$(RM_RF) Makefile.mk Makefile.mk.old


# --- MakeMaker postamble section:


# --- MakeMaker rulez section:

install install_static install_dynamic :: 
	$(PERL_SRC)PerlInstall -l $(PERL_LIB)
	$(PERL_SRC)PerlInstall -l "Bird:MacPerl Ä:site_perl:"

.INCLUDE : $(PERL_SRC)BulkBuildRules.mk


# End.
