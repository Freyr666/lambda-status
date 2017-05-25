open Containers
open Lwt_react
open Show

type item = string

let initial = "{\"version\":1}\n["

let item name = name

let show it vl =
  "{\"" ^ it ^
    "\":\"volume\",\"instance\":\"default.Master.0\",\"markup\":\"none\",\"full_text\":\"" ^
      vl ^ "\"}"
  
let pack arr =
  let l = Array.length arr in
  let ind = 0 in
  let res = arr.(ind) in
  let rec loop arr ind sep acc =
    if ind >= l then acc
    else loop arr (succ ind) sep (acc ^ sep ^ arr.(ind))
  in
  "[" ^ (loop arr ind "," res) ^ "],"
