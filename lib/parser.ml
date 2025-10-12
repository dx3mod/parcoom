type 'a t = Source.t -> Source.t * ('a, Error.t) result

let return value source = (source, Ok value)

and fail description source =
  (source, Error Error.{ description; start_offset = source.Source.offset })

let map f parser source =
  let source, result = parser source in
  (source, Result.map f result)

let bind parser f source =
  match parser source with
  | source, Ok value -> f value source
  | source, error -> (source, Obj.magic error)
