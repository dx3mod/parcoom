type 'a t = Source.t -> Source.t * ('a, Error.t) result

let return value source = (source, Ok value)

and fail description source =
  ( source,
    Error Error.{ description; start_offset = source.Source.offset } )
