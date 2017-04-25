open Lwt
open Lwt_react
open Widget

module Date : WIDGET with type args = (float * string) =
struct
  type args = (float * string)
  type t = { tm   : float
           ; info : string }

  let pr_time () =
    let tm = Unix.localtime @@ Unix.gettimeofday () in
    Printf.sprintf "%02d:%02d:%02d"
                   tm.Unix.tm_hour tm.Unix.tm_min tm.Unix.tm_sec

  let get_val t = t.info ^ pr_time ()
         
  let create (f,info) =
    { tm = f; info = info }
    
  let get_event_loop (t : t) =
    let e, send = E.create () in
    let rec loop () =
      Lwt_unix.sleep t.tm
      >>= fun _ ->
      Lwt.return @@ get_val t
      >>= fun r ->
      send r; loop ()
    in
    e, loop
end
