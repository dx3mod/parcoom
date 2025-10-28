(** Parsing function type where the parser is a function that takes a source
    string and a result string, and returns either the parsed result or an
    error. *)

type 'a t = Source.t -> Source.t * ('a, Error.t) result
(** Parser type, *)

(** {1 Constructors} *)

val return : 'a -> 'a t
val fail : string -> _ t

(** {1 Monadic operations} *)

val map : ('a -> 'b) -> 'a t -> 'b t
val bind : 'a t -> ('a -> 'b t) -> 'b t
