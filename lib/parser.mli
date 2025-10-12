type 'a t = Source.t -> Source.t * ('a, Error.t) result

val return : 'a -> 'a t
val fail : string -> Source.t -> Source.t * ('a, Error.t) result
val map : ('a -> 'b) -> 'a t -> 'b t
val bind : 'a t -> ('a -> 'b t) -> 'b t
