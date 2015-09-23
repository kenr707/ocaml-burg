# Welcome to OCamlburg #

OCamlburg is a code generator generator that emits [Objective Caml](http://caml.inria.fr/) source code. Conceptually, OCamlburg is close to tools like OCamlYacc and OCamlLex: it reads a specification and emits code derived from this specification. Just as these tools, OCamlburg is most useful for compiler writers. While Lex and Yacc are typically used to generate compiler front ends, OCamlburg (and Burg-style code generators in general) are used to implement compiler back ends, that is, code emitters. For an example, see below.

## Download ##

The source code is available directly from this Subversion repository. See the tab _Source_ for instructions.
Since OCamlburg is a development tool, no binaries are available.

## Installation ##

To compile OCamlburg from source code, go to the top-level directory which contains `README` and `configure` and run the `configure` script. This should work on all Unix systems where Objective Caml is installed.

```
./configure
make
make install
```

The `configure` script tries to find all relevant tools on your system. If it fails, try running it again as `./configure -v` to see what it actually does. You need the following tools:

  * Objective Caml
  * Perl (for configure and nofake)
  * GNU Make

If you intend to modify the OCamlburg source code I recommend to install additionally the Noweb literate programming system.

## Documentation ##

The design on OCamlburg was inspired by iBurg, which emits C code. It is documented in Fraser and Hanson: ''Engineering a Simple, Efficient Code Generator Generator'', ACM Letters on Programming Languages and Systems 1, 3 (Sep 1992), 213-226. Reading this paper is a good start for understanding Burg-style code generators. OCamlburg itself is documented in a Unix-style ManualPage; the souce code comes with a [source:trunk/README].

## Copyright ##

OCamlburg is in the public domain, including all source code, examples, and documentation.

## Authors ##

Christian Lindig <lindig at cs.uni-sb.de>, Norman Ramsey <nr at eecs.harvard.edu>