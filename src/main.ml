open Containers
open Lwt
open Lwt_react
open Plugins
                                            
let () =
  let e, send = E.create () in
  let wl = [(Plugins.create 3. "date")
           ;(Plugins.create 1. "date")
           ] in
  let tl = List.map (fun w -> w#eval) wl in 
  let rec loop tl =
    Lwt.nchoose tl
    >>= fun lst ->
    String.concat " " lst
    |> send;
    List.map2 (fun w t -> w#update t) wl tl |> loop
  in
  let p = E.map print_endline e in
  Lwt_main.run (loop tl)

  
  (*
  let f1 = (pr_time % Unix.gettimeofday) in
  let f2 = (fun () -> print_endline "Hello!") in 
  main [(f1,0,0);(f2,1,2)]
   *)
