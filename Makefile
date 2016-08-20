# Unix C makefile for the Infocom tools

CC = cc
NROFF	= nroff

#Some systems declare getopt, others do not.  Pick whichever works
#CFLAGS = -O -DHAS_GETOPT
CFLAGS += -O2 -fstack-protector-strong --param=ssp-buffer-size=4 -w -D_FORTIFY_SOURCE=2
LDFLAGS = -Wl,-O2,-z,relro,--as-needed,--hash-style=gnu
LIBS =


# .SUFFIXES: .c .h .1 .man
.SUFFIXES: .c .h .1

# .1.man:
#	$(NROFF) -man $*.1 | col -b > $*.man

MANPAGES = infodump.1 inforead.1 txd.1 check.1 pix2gif.1

CINC =
COBJS = check.o

IINC = tx.h
IOBJS = infodump.o showhead.o showdict.o showobj.o showverb.o txio.o infinfo.o symbols.o

PINC = pix2gif.h
POBJS = pix2gif.o

TINC = tx.h
TOBJS = txd.o txio.o showverb.o infinfo.o symbols.o showobj.o

# "doc" target merely breaks manpages for modern systems
# all : check infodump pix2gif txd doc
all : check infodump pix2gif txd

check : $(COBJS)
	$(CC) -o $@ $(LDFLAGS) $(COBJS) $(LIBS)

$(COBJS) : $(CINC)

infodump : $(IOBJS)
	$(CC) -o $@ $(LDFLAGS) $(IOBJS) $(LIBS)

$(IOBJS) : $(IINC)

pix2gif : $(POBJS)
	$(CC) -o $@ $(LDFLAGS) $(POBJS) $(LIBS)

$(POBJS) : $(PINC)

txd : $(TOBJS)
	$(CC) -o $@ $(LDFLAGS) $(TOBJS) $(LIBS)

$(TOBJS) : $(TINC)

# "doc" target merely breaks manpages for modern systems
clean :
	# -rm *.o check infodump pix2gif txd $(FORMATTEDMAN)
	-rm *.o check infodump pix2gif txd

doc: $(FORMATTEDMAN)
