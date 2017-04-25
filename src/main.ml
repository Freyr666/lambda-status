open Containers
open Lwt
open Lwt_react
open Plugins
                                            
let () =
  let wl = [(Plugins.create "date" 3. "test")
           ;(Plugins.create "date" 1. "test")
           ] in
  let ev = List.map (fun (e,_) -> E.map print_endline e) wl in
  let tl = List.map (fun (_,p) -> p ()) wl in 
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
