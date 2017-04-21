open Batteries
open Lwt
open Lwt_react

let pr_time t =
  let tm = Unix.localtime t in
  Printf.sprintf "%02d:%02d:%02d"
                 tm.Unix.tm_hour tm.Unix.tm_min tm.Unix.tm_sec

module type Widget = sig
  type t = string

  val get_event : unit -> t event * (unit -> unit)
end

module Time = struct
  let get_event () =
    let event, send' = E.create () in
    let send = fun () -> send' "time" in
    event, send
end

module String = struct
  let get_event () =
    let event, send' = E.create () in
    let send = fun () -> send' "string" in
    event, send
end 
    
type fmt = Time_fmt
         | String_fmt
  
let widgets = [(Time_fmt, 1.); (String_fmt, 3.)]
  
let rec main ctx =
  let nctx = List.map (fun (f, t, tlim) ->
                 if t < tlim
                 then (f, (succ t), tlim)
                 else (f (); (f, 0, tlim)))
                      ctx
  in
  Unix.sleep 1;
  main nctx

type widget = { tm : float
              ; arg    : string}
  
let construct w =
  Lwt_unix.sleep w.tm >>= fun _ ->
  return w.arg

let update w thread =
  match Lwt.state thread with
  | Lwt.Return _ -> construct w
  | _            -> thread                
                                            
let () =
  let e, send = E.create () in
  let wl = [{tm = 3.; arg = "Each 3 secs"};
            {tm = 1.; arg = "Each second"}
            ] in
  let tl = List.map construct wl in 
  let rec loop tl =
    Lwt.nchoose tl
    >>= fun lst ->
    BatString.concat " " lst
    |> send;
    List.map2 update wl tl |> loop
  in
  let p = E.map print_endline e in
  Lwt_main.run (loop tl)
  (*
  let f1 = (pr_time % Unix.gettimeofday) in
  let f2 = (fun () -> print_endline "Hello!") in 
  main [(f1,0,0);(f2,1,2)]
   *)
