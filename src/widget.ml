open Containers
open Lwt
open Lwt_react

exception Bad_config of string * string
                      
module type WIDGET = sig
  val name             : string
  type config
  val default          : config
  val create           : config -> string React.event * (unit -> unit Lwt.t)
  val parse_config     : string -> (config, string) Result.result
  val string_of_config : config -> string
end

module type WIDGET_INST = sig
  module W   : WIDGET
  val conf   : W.config
end
                        
module Widget_tbl = Hashtbl.Make(String)

let build_known_table known_widgets =
  let tbl = Widget_tbl.create 100 in
  let rec add = function
    | [] -> tbl
    | (module W : WIDGET)::tl ->
       Widget_tbl.add tbl W.name (module W : WIDGET); add tl
  in
  add known_widgets

let lookup_known_table tbl = Widget_tbl.find tbl

let create_inst tbl name conf =
  let (module Widget : WIDGET) = lookup_known_table tbl name in
  Widget.parse_config conf
  |> function
    | Error s -> raise (Bad_config (conf, s))
    | Ok conf ->
       (module struct
          module W = Widget
          let conf = conf
        end : WIDGET_INST)

