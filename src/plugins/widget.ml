open Lwt

class virtual widget timeout =
object(self)
  method virtual eval : string Lwt.t
  method virtual update : string Lwt.t -> string Lwt.t
end
