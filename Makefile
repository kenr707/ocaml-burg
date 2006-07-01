#
# vim: ts=8 noet sw=8:
#


TOP := 			.
include 		config.mk

config.mk: 		configure
			echo "Have you run ./configure? Please do."
			exit 1

BINDIR      		:= $(PREFIX)/bin
MAN1DIR     		:= $(PREFIX)/man/man1

OCAMLC_FLAGS            := -g -dtypes 
OCAMLOPT_FLAGS          := -p -dtypes 
OCAMLOPT_FLAGS          := -p -dtypes 
OCAMLOPT_FLAGS          :=    -dtypes 


# ------------------------------------------------------------------ 
# high-level targets
# ------------------------------------------------------------------ 

.PHONY: 	all clean install

all: 		ocamlburg.$(BINEXT) runtime.$(BINEXT) examples.$(BINEXT)

clean:
		rm -f *.cmo *.cmx *.o *.cmi *.ml *.mli *.mll *.mly
		rm -f *.byte *.opt 
		rm -f *.output *.annot

clobber: 	clean
		rm -f config.mk


install: 	ocamlburg.$(BINEXT) dirs
		cp ocamlburg.$(BINEXT) $(BINDIR)/ocamlburg
		cp ocamlburgfix $(BINDIR)
		cp ocamlburgfix.1 $(MAN1DIR)
		cp ocamlburg.1    $(MAN1DIR)
		# todo: install runtime files camlburg.*
		

dirs: 		$(BINDIR) $(MAN1DIR)
		test -d $(BINDIR)  || mkdir -p $(BINDIR)
		test -d $(MAN1DIR) || mkdir -o $(MAN1DIR)


# ------------------------------------------------------------------ 
# rules
# ------------------------------------------------------------------ 

%.cmi:		%.mli
		$(OCAMLC) $(OCAMLC_FLAGS) -c $<

%.cmo:		%.ml
		$(OCAMLC) $(OCAMLC_FLAGS) -c $<

%.o %.cmx:	%.ml
		$(OCAMLOPT) $(OCAMLO_FLAGS) -c $<

%.ml:		%.mll
		$(OCAMLLEX) $<

%.mli		\
%.ml		\
%.output:	%.mly
		$(OCAMLYACC) -v $<

%.ml:		%.nw
		$(NOTANGLE) -L'# %L "%F"%N' -R$@ $< > $@

%.mli:		%.nw
		$(NOTANGLE) -L'# %L "%F"%N' -R$@ $< > $@
		
# ------------------------------------------------------------------ 
# special rules to resolve ambiguities
# ------------------------------------------------------------------ 

parse.mly:	parse.nw
		$(NOTANGLE) -R$@ $< > $@

parse.ml:	parse.mly

lex.mll:	lex.nw
		$(NOTANGLE) -R$@ $< > $@
		
lex.ml:		lex.mll		

# ------------------------------------------------------------------ 
# files
# ------------------------------------------------------------------ 

ML =		pretty.ml 	\
		srcmap.ml	\
		code.ml		\
		mangler.ml	\
		spec.ml		\
		parseerror.ml	\
		parse.ml	\
		lex.ml		\
		norm.ml		\
		burg.ml		\
                noguardscheck.ml\
		main.ml		\
		
MLI =		pretty.mli 	\
		srcmap.mli	\
		burg.mli	\
		code.mli	\
		main.mli	\
		mangler.mli	\
		norm.mli	\
		parse.mli	\
		parseerror.mli	\
		spec.mli	\

NW := 		burg.nw 	\
		camlburg.nw 	\
		code.nw 	\
		lex.nw 		\
		main.nw 	\
		mangler.nw 	\
		noguardscheck.nw\
		norm.nw 	\
		parse.nw 	\
		parseerror.nw 	\
		sample.nw 	\
		spec.nw 	\

SCAN =		$(ML) $(MLI) \
		camlburg.ml camlburg.mli\
		sampleclient.ml\


CMO =		$(addsuffix .cmo,$(basename $(ML))) 
CMX =		$(addsuffix .cmx,$(basename $(ML))) 

# ------------------------------------------------------------------ 
# binaries
# ------------------------------------------------------------------ 

ocamlburg.byte:	$(CMO)
		$(OCAMLC) $(OCAMLC_FALGS) -o $@ $(CMO)

ocamlburg.opt:	$(CMX)
		$(OCAMLOPT) $(OCAMLO_FLAGS) -o $@ $(CMX)

# ------------------------------------------------------------------ 
# runtime code, examples
# ------------------------------------------------------------------ 

sample.mlb:	sample.nw
		$(NOTANGLE) -L'# %L "%F"%N' -R$@ $< > $@

sampleclient.ml:    sample.nw
		$(NOTANGLE) -L'# %L "%F"%N' -R$@ $< > $@
		
iburg.ml:	iburg.mlb ocamlburg.$(BINEXT) runtime.$(BINEXT)
		./ocamlburg.$(BINEXT) iburg.mlb | ./ocamlburgfix $@

sample.ml:	sample.mlb ocamlburg.$(BINEXT) runtime.$(BINEXT)
		./ocamlburg.$(BINEXT) sample.mlb | ./ocamlburgfix $@

runtime.byte:	camlburg.ml camlburg.cmo camlburg.cmi camlburg.mli
runtime.opt:	camlburg.ml camlburg.cmx camlburg.cmi camlburg.mli camlburg.o

examples.byte:	iburg.cmo sample.cmo sampleclient.cmo
examples.opt:	iburg.cmx sample.cmx sampleclient.cmx

# ------------------------------------------------------------------ 
# dependencies
# ------------------------------------------------------------------ 

DEPEND:     	$(SCAN)
		$(OCAMLDEP) $(SCAN) > DEPEND   

include	DEPEND

# ------------------------------------------------------------------ 


