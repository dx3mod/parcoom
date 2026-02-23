(** Stupid parsing error type. *)

type t = { description : string; offset : int }

let error ~offset description = Error { offset; description }

let pp ppf { description; offset } =
  Format.fprintf ppf "{ offset = %d; description = \"%s\"  }" offset description
