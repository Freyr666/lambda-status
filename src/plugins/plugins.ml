open Widget
open Date_plugin

let (%%) f g x y = f (g x y)
   
exception No_plugin_avail

module Date = Make_widget (Date_worker)
open Date
            
let create = function
  | "date" -> Date.get_event_loop %% Date.create
  | _      -> raise No_plugin_avail

                    (*
let eval widget = widget#eval

let update widget thread = widget#update thread
 *)
