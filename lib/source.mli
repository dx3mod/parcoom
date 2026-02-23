(** Abstraction over [string] for viewing substrings without copying them. *)

type t = {
  text : string;
  start_offset : int;
      (** The absolute position of the {b start} of the substring. *)
  end_offset : int;
      (** The absolute position of the {b end} of the substring. *)
}

val of_string : string -> t
(** [of_string text] make view for [text]. *)

val to_string : t -> string
(** [to_string source] copy of substring view to new allocated string. *)

val sub : offset:int -> ?length:int -> t -> t
(** [sub ~offset ?length source] get substring's view in range from
    [start_offset + offset] to [end_offset + length].

    Example of usage:

    {[
      # Source.of_string "Hello World" |> Source.sub ~offset:6;;
      - : Source.t = "World"
    ]} *)

val get : t -> int -> char
(** [get source index] a char by index in substring's view range.

    @raise End_of_file if [index] out of the bounds of substring's view range.
*)

val get_opt : t -> int -> char option
(** [get_opt source index] a char by index optionally in substring's view range.
*)

val is_empty : t -> bool
(** [is_empty source] checks that start offset and end offset are equal. *)

val starts_with : prefix:string -> t -> bool
(** [starts_with ~prefix source] checks if a substring's view starts with the
    [prefix]. *)

val pp : Format.formatter -> t -> unit
(** [pp ppf source] pretty-print substring's view. *)
