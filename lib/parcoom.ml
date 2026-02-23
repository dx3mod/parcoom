module Source = Source
module Error = Error
module Parser = Parser
open Parser

let ( let* ) = bind
and ( >>= ) = bind

let ( let+ ) v f = map f v
and ( >|= ) v f = map f v

let take_while p source =
  let rec aux index =
    match Source.get_opt source index with
    | Some ch when p ch -> aux (succ index)
    | _ -> index
  in

  let end_index = aux 0 in

  ( Source.sub ~offset:end_index source,
    Ok (Source.sub ~offset:0 ~length:end_index source |> Source.to_string) )

let prefix prefix source =
  if Source.starts_with ~prefix source then
    (Source.sub ~offset:(String.length prefix) source, Ok prefix)
  else
    ( source,
      Error.error ~offset:source.start_offset
        (Printf.sprintf "not have prefix '%s'" prefix) )

let ( *> ) pa pb = bind pa @@ Fun.const pb
let ( <* ) pa pb = bind pa @@ fun a -> map (Fun.const a) pb
let ( <*> ) pa pb = bind pa @@ fun a -> map (fun b -> (a, b)) pb

let ( <|> ) pa pb source =
  let source, result = pa source in
  if Result.is_ok result then (source, result) else pb source

let optional parser source =
  let source, result = parser source in
  (source, Ok (Result.to_option result))

let many parser source =
  let rec aux values source =
    match parser source with
    | source, Error _ -> (source, values)
    | source, Ok value -> aux (value :: values) source
  in

  let source, values = aux [] source in
  (source, Result.ok @@ List.rev values)

let any_char source =
  match Source.get_opt source 0 with
  | Some ch -> (Source.sub ~offset:1 source, Ok ch)
  | _ -> (source, Error.error ~offset:source.start_offset "end of file")

let char c source =
  match Source.get_opt source 0 with
  | Some ch when ch = c -> (Source.sub ~offset:1 source, Ok c)
  | _ ->
      ( source,
        Error.error ~offset:source.start_offset
          (Printf.sprintf "it's not '%c' char" c) )

exception Not_full_parsed

let parse parser source = parser source

and parse_full parser source =
  match parser source with
  | source, Ok value when Source.is_empty source -> Ok value
  | _, Ok _ -> raise Not_full_parsed
  | _, Error err -> Error err

let parse_string parser str = Source.of_string str |> parse parser
and parse_string_full parser str = Source.of_string str |> parse_full parser
