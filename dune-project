(lang dune 3.6)

(name parcoom)

(generate_opam_files true)

(package
 (name parcoom)
 (synopsis "Parser combinators library in idiomatic OCaml")
 (depends
  ocaml
  dune
  (alcotest :with-test)
  (odoc :with-docs)))
