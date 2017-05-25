open Widget

let (%) f g x = f (g x)
   
exception No_plugin_avail

type config_item = string * (string * string) list (* name, config list *)
        
type event_loop = string React.event * (unit -> unit Lwt.t)

type plugins = (module WIDGET) Widget_tbl.t

let known_widgets : (module WIDGET) list =
  [ (module Date)
  ; (module Pipe)
  ]

let init_plugins () : plugins = build_known_table known_widgets

module Interface = struct
         
  let create : (plugins -> string -> string -> (module WIDGET_INST)) = create_inst
                                                  
  let get_event_loop (module Plug : WIDGET_INST) =
    Plug.W.create Plug.conf

end 
