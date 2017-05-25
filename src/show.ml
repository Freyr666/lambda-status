open Containers
open Lwt_react
open Plugins
open CCArray

type config = unit

module type SHOW = sig
  type item

  val initial : string
  val item : string -> item
  val show : item -> string -> string
  val pack : string array -> string
end

module Display (S : SHOW) = struct

  let init ?(sep = "|") config names events =
    let upd_print tray ind item str =
      tray.(ind) <- (S.show item str);
      print_endline @@ S.pack tray
    in
    let rec install tray ind itms evts =
      match itms, evts with
      | [],[] -> ()
      | it::ms, ev::ts ->
         let _ = E.map (upd_print tray ind it) ev in
         install tray (succ ind) ms ts
      | _ -> raise (Failure "Display.install")
    in
    print_endline S.initial;
    let items = List.map S.item names in
    let tray = Array.of_list @@ List.map (fun i -> S.show i "") items in
    install tray 0 items events
end
