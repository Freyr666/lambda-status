open Widget
open Date_plugin
open Pipe_plugin

let (%) f g x = f (g x)
   
exception No_plugin_avail

type event_loop = string React.event * (unit -> unit Lwt.t)
        
type _ plugin =
  | Date : Date.args plugin
  | Pipe : Pipe.args plugin
  
let create : type a. a plugin -> a -> event_loop = function
  | Date -> Date.get_event_loop % Date.create
  | Pipe -> Pipe.get_event_loop % Pipe.create
