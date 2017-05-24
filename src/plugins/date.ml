open Lwt
open Lwt_react

let name = "date"
   
type config = float

let default = 2.0
            
let pr_time () =
  let tm = Unix.localtime @@ Unix.gettimeofday () in
  Printf.sprintf "%02d:%02d:%02d"
                 tm.Unix.tm_hour tm.Unix.tm_min tm.Unix.tm_sec
         
let create conf =    
  let e, send = E.create () in
  let rec loop () =
    Lwt_unix.sleep conf
    >>= fun _ ->
    Lwt.return @@ pr_time ()
    >>= fun r ->
    send r; loop ()
  in
  e, loop

let parse_config s = Ok (float_of_string s)

let string_of_config = string_of_float
