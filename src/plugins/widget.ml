open Lwt
open Lwt_react
   
module type WIDGET = sig
  type t
  type args
  val create : args -> t
  val get_event_loop : t -> string React.event * (unit -> unit Lwt.t)
end
