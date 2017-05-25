open Containers
open Lwt
open Lwt_react
open Plugins
open Show

module Dis = Display(I3bar)
   
let () =
  let plug_db = init_plugins () in
  let wl = [ "date", ["tm","3."]
           ; "date", ["tm","10."]
           ; "pipe", ["",""]
           ] in
  let plugs = List.map (fun (n, c) -> Interface.create plug_db n (snd @@ List.hd c)) wl in
  let names = List.map fst wl in
  let eventloops = List.map Interface.get_event_loop plugs in
  let ev = List.map (fun (e,_) -> e) eventloops in
  let _  = Dis.init () names ev in
  let tl = List.map (fun (_,p) -> p ()) eventloops in
  let rec loop tl =
    Lwt.choose tl
    >>= fun _ ->
    return ()
  in
  Lwt_main.run (loop tl)

  
  (*
  let f1 = (pr_time % Unix.gettimeofday) in
  let f2 = (fun () -> print_endline "Hello!") in 
  main [(f1,0,0);(f2,1,2)]
   *)
