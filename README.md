# parcoom

Lightweight monadic parser combinator library in OCaml. No dependencies (almost).
It's rewritten version of [Tsoding's library](https://github.com/tsoding/parcoom) in more
idiomatic OCaml way.

## Quick Start

Requirements:
- :camel: OCaml >= 4.14
- :hammer: Dune build system
- :package: OPAM package manager (optional)
- :blue_book: Odoc documentation generator (optional)

Installation of latest development version's the library.
```console
$ opam install parcoom.dev https://github.com/dx3mod/parcoom.git
```

And for use in UTop (for example).
```ocaml
# #require "parcoom";;
```
```ocaml
# let open Parcoom in
  parse_string (char 'h' <*> any_char) "hello";;
- : _ * (char * char, _) result = ("llo", Ok ('h', 'e'))
```

View documentation you can using `odoc`.
```console
$ dune build @doc
$ open _build/default/_doc/_html/index.html
```

## References

- [Original Tsoding's repository](https://github.com/tsoding/parcoom)
- https://www.cs.nott.ac.uk/~pszgmh/monparsing.pdf
