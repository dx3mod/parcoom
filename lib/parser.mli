type 'a t = Source.t -> Source.t * ('a, Error.t) result

val return : 'a -> 'a t
val fail : string -> Source.t -> Source.t * ('a, Error.t) result
val map : ('a -> 'b) -> 'a t -> 'b t
val ( let+ ) : 'a t -> ('a -> 'b) -> 'b t
val bind : 'a t -> ('a -> 'b t) -> 'b t
val ( let* ) : 'a t -> ('a -> 'b t) -> 'b t
val take_while : (char -> bool) -> string t
val prefix : string -> string t
val ( *> ) : _ t -> 'b t -> 'b t
val ( <* ) : 'a t -> _ t -> 'a t
val ( <*> ) : 'a t -> 'b t -> ('a * 'b) t
val ( <|> ) : 'a t -> 'a t -> 'a t
val optional : 'a t -> 'a option t
val any_char : char t
val char : char -> char t
