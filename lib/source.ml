type t = { text : string; offset : int; length : int }

let of_string text = { text; offset = 0; length = String.length text }

and to_string source =
  String.sub source.text source.offset (source.length - source.offset)

let sub ~offset ?length source =
  let offset = source.offset + offset in
  {
    source with
    offset;
    length = Option.fold ~none:source.length ~some:(( + ) offset) length;
  }

let get source index =
  let index = source.offset + index in
  assert (index < source.length);
  source.text.[index]

let starts_with ~prefix source =
  let length = String.length prefix in
  let rec aux index =
    if index = length then true
    else if get source index = prefix.[index] then aux @@ succ index
    else false
  in

  aux 0

let pp fmt { text; offset; length } =
  Format.pp_print_char fmt '"';
  for i = offset to pred length do
    Format.pp_print_char fmt text.[i]
  done;
  Format.pp_print_char fmt '"'
