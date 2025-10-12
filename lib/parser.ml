type 'a t = Source.t -> Source.t * ('a, Error.t) result

let return value source = (source, Ok value)

and fail description source =
  (source, Error Error.{ description; start_offset = source.Source.offset })

let map f parser source =
  let source, result = parser source in
  (source, Result.map f result)

let ( let+ ) v f = map f v

let bind parser f source =
  match parser source with
  | source, Ok value -> f value source
  | source, error -> (source, Obj.magic error)

let ( let* ) = bind

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
            start_offset = source.offset;
          } )

let ( *> ) pa pb = bind pa @@ Fun.const pb
let ( <* ) pa pb = bind pa @@ fun a -> map (Fun.const a) pb
let ( <*> ) pa pb = bind pa @@ fun a -> map (fun b -> (a, b)) pb

let ( <|> ) pa pb source =
  let source, result = pa source in
  if Result.is_ok result then (source, result) else pb source

let optional parser source =
  let source, result = parser source in
  (source, Ok (Result.fold ~error:(Fun.const None) ~ok:Option.some result))

let any_char source = (Source.sub ~offset:1 source, Ok (Source.get source 0))

let char c source =
  if Source.get source 0 = c then (Source.sub ~offset:1 source, Ok c)
  else
    ( source,
      Error
        Error.
          {
            description = Printf.sprintf "it's not '%c'" c;
            start_offset = source.offset;
          } )
