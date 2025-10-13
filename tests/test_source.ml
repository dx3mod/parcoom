open Alcotest

let source =
  testable
    Fmt.(
      record
        [
          field "text"
            (fun Parcoom.Source.{ text; _ } -> text)
            Format.pp_print_string;
          field "start_offset"
            (fun Parcoom.Source.{ start_offset; _ } -> start_offset)
            Format.pp_print_int;
          field "end_offset"
            (fun Parcoom.Source.{ end_offset; _ } -> end_offset)
            Format.pp_print_int;
        ])
    ( = )

let test_conversion_of_string () =
  (check source) "same string"
    Parcoom.Source.{ text = "hello"; start_offset = 0; end_offset = 5 }
    (Parcoom.Source.of_string "hello")

let test_conversion_to_string () =
  (check string) "same string" "llo"
    Parcoom.Source.(
      to_string { text = "hello"; start_offset = 2; end_offset = 5 })

let () =
  run "Parcoom.Source"
    [
      ( "conversion",
        [
          test_case "of_string" `Quick test_conversion_of_string;
          test_case "to_string" `Quick test_conversion_to_string;
        ] );
    ]
