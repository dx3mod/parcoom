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
    let char = Source.get source index in
    if p char then aux @@ succ index else index
  in

  let end_index = aux 0 in

  ( Source.sub ~offset:end_index source,
    Ok (Source.sub ~offset:0 ~length:end_index source |> Source.to_string) )

let prefix prefix source =
  if Source.starts_with ~prefix source then
    (Source.sub ~offset:(String.length prefix) source, Ok prefix)
  else
    ( source,
      Error
        Error.
          {
            description = Printf.sprintf "not have prefix '%s'" prefix;
            start_offset = source.start_offset;
          } )

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
  let values = ref [] in

  let rec aux source =
    let source, result = parser source in
    Result.fold ~error:(Fun.const source)
      ~ok:(fun value ->
        values := value :: !values;
        aux source)
      result
  in

  let source = aux source in
  (source, Result.ok @@ List.rev !values)
(* (aux source, Result.ok @@ List.rev !values) *)

let any_char source = (Source.sub ~offset:1 source, Ok (Source.get source 0))

let char c source =
  if Source.get source 0 = c then (Source.sub ~offset:1 source, Ok c)
  else
    ( source,
      Error
        Error.
          {
            description = Printf.sprintf "it's not '%c'" c;
            start_offset = source.start_offset;
          } )

let parse parser = Fun.compose parser Source.of_string
