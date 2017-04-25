open Lwt
open Lwt_react

module type WORKER = sig
  type t
  type args
  val create : float -> args -> t
  val timer : t -> float
  val get_val : t -> string
end
   
module type WIDGET = sig
  type t
  type args
  val create : float -> args -> t
  val get_event_loop : t -> string React.event * (unit -> unit Lwt.t)
end
                   
module Make_widget (W : WORKER) : (WIDGET with type t = W.t and type args = W.args) =
struct
  type t = W.t
  type args = W.args

  let create = W.create

  let get_event_loop (t : t) =
    let e, send = E.create () in
    let rec loop () =
      Lwt_unix.sleep @@ W.timer t
      >>= fun _ ->
      Lwt.return @@ W.get_val t
      >>= fun r ->
      send r; loop ()
    in
    e, loop
end
   (*
class virtual widget timeout =
object(self)
  method virtual eval : string Lwt.t
  method virtual update : string Lwt.t -> string Lwt.t
end
    *)
