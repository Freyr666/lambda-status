open Lwt
open Widget

let pr_time () =
  let tm = Unix.localtime @@ Unix.gettimeofday () in
  Printf.sprintf "%02d:%02d:%02d"
                 tm.Unix.tm_hour tm.Unix.tm_min tm.Unix.tm_sec

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
