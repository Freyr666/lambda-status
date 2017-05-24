open Containers
open Lwt
open Lwt_react
open Plugins
                                            
let () =
  let plug_db = init_plugins () in
  let wl = [ "date", "3."
           ; "date", "10."
           ; "pipe", ""
           ] in
  let plugs = List.map (fun (n, c) -> Widget.create_inst plug_db n c) wl in
  let eventloops = List.map get_event_loop plugs in
  let ev = List.map (fun (e,_) -> E.map print_endline e) eventloops in
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
