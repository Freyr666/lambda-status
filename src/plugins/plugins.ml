open Widget
open Date

exception No_plugin_avail
                    
let create tm_interval = function
  | "date" -> new Date.date tm_interval
  | _      -> raise No_plugin_avail
