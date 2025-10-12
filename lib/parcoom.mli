(** Parser combinators library in idiomatic OCaml. *)

val parse : (Source.t -> 'a) -> string -> 'a

(** {1 Monadic syntax}*)

val ( let* ) : 'a Parser.t -> ('a -> 'b Parser.t) -> 'b Parser.t
val ( let+ ) : 'a Parser.t -> ('a -> 'b) -> 'b Parser.t
val ( >>= ) : 'a Parser.t -> ('a -> 'b Parser.t) -> 'b Parser.t
val ( >|= ) : 'a Parser.t -> ('a -> 'b) -> 'b Parser.t

(** {1 Combinator parsers} *)

val ( *> ) : 'a Parser.t -> 'b Parser.t -> 'b Parser.t
val ( <* ) : 'a Parser.t -> 'b Parser.t -> 'a Parser.t
val ( <*> ) : 'a Parser.t -> 'b Parser.t -> ('a * 'b) Parser.t

val ( <|> ) :
  ('a -> 'b * ('c, 'd) result) ->
  ('b -> 'b * ('c, 'd) result) ->
  'a ->
  'b * ('c, 'd) result

val optional : ('a -> 'b * ('c, 'd) result) -> 'a -> 'b * ('c option, 'e) result

(** {1 Text manipulation}*)

val take_while : (char -> bool) -> Source.t -> Source.t * (string, 'a) result
val prefix : string -> Source.t -> Source.t * (string, Error.t) result
val any_char : Source.t -> Source.t * (char, 'a) result
val char : char -> Source.t -> Source.t * (char, Error.t) result

(** {1 Exported modules} *)

module Source = Source
module Error = Error
module Parser = Parser
