open Alcotest

let source =
  testable
    Fmt.(
      record
        [
          field "text"
            (fun Parcoom.Source.{ text; _ } -> text)
            Format.pp_print_string;
          field "offset"
            (fun Parcoom.Source.{ offset; _ } -> offset)
            Format.pp_print_int;
          field "length"
            (fun Parcoom.Source.{ length; _ } -> length)
            Format.pp_print_int;
        ])
    ( = )

let test_conversion_of_string () =
  (check source) "same string"
    Parcoom.Source.{ text = "hello"; offset = 0; length = 5 }
    (Parcoom.Source.of_string "hello")

let test_conversion_to_string () =
  (check string) "same string" "llo"
    Parcoom.Source.(to_string { text = "hello"; offset = 2; length = 5 })

let () =
  run "Parcoom.Source"
    [
      ( "conversion",
        [
          test_case "of_string" `Quick test_conversion_of_string;
          test_case "to_string" `Quick test_conversion_to_string;
        ] );
    ]
