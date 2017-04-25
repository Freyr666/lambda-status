open Lwt
open Widget

let pr_time () =
  let tm = Unix.localtime @@ Unix.gettimeofday () in
  Printf.sprintf "%02d:%02d:%02d"
                 tm.Unix.tm_hour tm.Unix.tm_min tm.Unix.tm_sec

module Date_worker : WORKER with type args = string =
struct
  type args = string
  type t = { tm   : float
           ; info : string }
  let create f info =
    { tm = f; info = info }
  let timer t = t.tm
  let get_val t = t.info ^ pr_time ()
end
  
  (*
class date timeout =
object(self)
  inherit widget timeout

  val tm = timeout

  method eval =
    Lwt_unix.sleep tm >>= fun _ ->
    return @@ pr_time ()

  method update thread =
    match Lwt.state thread with
    | Lwt.Return _ -> self#eval
    | _            -> thread
                    
end 
   *)
