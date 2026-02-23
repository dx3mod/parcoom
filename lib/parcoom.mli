(** Parser combinators library in idiomatic OCaml. *)

(** {b Prefix parse functions} *)

val parse : 'a Parser.t -> Source.t -> Source.t * ('a, Error.t) result
(** [parse parser source] return partial parsed result with tail of the
    [source]. *)

val parse_string : 'a Parser.t -> string -> Source.t * ('a, Error.t) result
(** [parse_string string] return partial parsed result with tail of the
    [string]. *)

(** {b Full parse functions} *)

val parse_full : 'a Parser.t -> Source.t -> ('a, Error.t) result
(** [parse_full parser source] return parsed result of the [source].

    @raise End_of_file if the [source] is not full parsed. *)

val parse_string_full : 'a Parser.t -> string -> ('a, Error.t) result
(** [parse_string_full parser source] return parsed result of the [string].

    @raise End_of_file if the [string] is not full parsed. *)

(** {1 Monadic syntax}*)

val ( let* ) : 'a Parser.t -> ('a -> 'b Parser.t) -> 'b Parser.t
(** The same as {!Parser.bind}. *)

val ( let+ ) : 'a Parser.t -> ('a -> 'b) -> 'b Parser.t
(** The same as {!Parser.map}. *)

val ( >>= ) : 'a Parser.t -> ('a -> 'b Parser.t) -> 'b Parser.t
(** The same as {!Parser.bind}. *)

val ( >|= ) : 'a Parser.t -> ('a -> 'b) -> 'b Parser.t
(** The same as {!Parser.map}. *)

(** {1 Combinator parsers} *)

val ( *> ) : 'a Parser.t -> 'b Parser.t -> 'b Parser.t
val ( <* ) : 'a Parser.t -> 'b Parser.t -> 'a Parser.t
val ( <*> ) : 'a Parser.t -> 'b Parser.t -> ('a * 'b) Parser.t
val ( <|> ) : 'a Parser.t -> 'a Parser.t -> 'a Parser.t
val optional : ('a -> 'b * ('c, 'd) result) -> 'a -> 'b * ('c option, 'e) result
val many : 'a Parser.t -> 'a list Parser.t

(** {1 Text manipulation}*)

val take_while : (char -> bool) -> Source.t -> Source.t * (string, 'a) result
val prefix : string -> Source.t -> Source.t * (string, Error.t) result
val any_char : Source.t -> Source.t * (char, Error.t) result
val char : char -> Source.t -> Source.t * (char, Error.t) result

(** {1 Exported modules} *)

module Source = Source
module Error = Error
module Parser = Parser
