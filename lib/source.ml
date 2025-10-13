(** Abstraction over [string] for viewing substrings without copying them. *)

type t = {
  text : string;
  start_offset : int;
      (** The absolute position of the {b start} of the substring. *)
  end_offset : int;
      (** The absolute position of the {b end} of the substring. *)
}

(** [of_string text] make view for [text]. *)
let[@inline] of_string text =
  { text; start_offset = 0; end_offset = String.length text }

(** [to_string source] copy of substring view to new allocated string. *)
and[@inline] to_string source =
  String.sub source.text source.start_offset
    (source.end_offset - source.start_offset)

(** [sub ~offset ?length source] get substring's view in range from
    [start_offset + offset] to [end_offset + length].

    Example of usage:

    {[
      # Source.of_string "Hello World" |> Source.sub ~offset:6;;
      - : Source.t = "World"
    ]} *)
let[@inline] sub ~offset ?length source =
  let start_offset = source.start_offset + offset in
  {
    source with
    start_offset;
    end_offset = Option.fold ~none:source.end_offset ~some:(( + ) offset) length;
  }

(** [get source index] a char by index in substring's view range. *)
let[@inline] get source index =
  let index = source.start_offset + index in
  assert (index < source.end_offset);
  source.text.[index]

let starts_with ~prefix source =
  let length = String.length prefix in
  let rec aux index =
    if index = length then true
    else if get source index = prefix.[index] then aux @@ succ index
    else false
  in

  aux 0

let pp fmt { text; start_offset; end_offset } =
  Format.pp_print_char fmt '"';
  for i = start_offset to pred end_offset do
    Format.pp_print_char fmt text.[i]
  done;
  Format.pp_print_char fmt '"'
