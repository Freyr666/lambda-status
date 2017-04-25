open Widget
open Date_plugin
open Pipe_plugin

let (%) f g x = f (g x)
   
exception No_plugin_avail
  
let create = function
  | "date" -> Date.get_event_loop % Date.create
  | "pipe" -> Pipe.get_event_loop % Pipe.create
  | _      -> raise No_plugin_avail
