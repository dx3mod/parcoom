type t = { text : string; offset : int; length : int }

let of_string text = { text; offset = 0; length = String.length text }

let sub ~offset ~length source =
  let offset = source.offset + offset in
  { source with offset; length = offset + length }

let get source index =
  let index = source.offset + index in
  assert (index < source.length);
  source.text.[index]

let pp fmt { text; offset; length } =
  Format.pp_print_char fmt '"';
  for i = offset to pred length do
    Format.pp_print_char fmt text.[i]
  done;
  Format.pp_print_char fmt '"'
