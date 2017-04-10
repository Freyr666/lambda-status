open Batteries

let pr_time t =
  let tm = Unix.localtime t in
  Printf.printf "\x1B[8D%02d:%02d:%02d%!"
                tm.Unix.tm_hour tm.Unix.tm_min tm.Unix.tm_sec

let pr_string =
  Printf.printf "\x1B[8D%s%!" 
  
let rec main ctx =
  let nctx = List.map (fun (f, t, tlim) ->
                 if t < tlim
                 then (f, (succ t), tlim)
                 else (f (); (f, 0, tlim)))
                      ctx
  in
  Unix.sleep 1;
  main nctx
  
let () =
  let f1 = (pr_time % Unix.gettimeofday) in
  let f2 = (fun () -> pr_string "Hello!") in 
  main [(f1,0,0);(f2,1,2)]
