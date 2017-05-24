open Lwt
open Lwt_react

let name = "pipe"

type config = unit

let default = ()

let create () =
  let fchan = Lwt_io.stdin in
  let e, send = E.create () in
  let rec loop () =
    Lwt_io.read_line fchan
    >>= fun line ->
    send line; loop ()
  in
  e, loop

let parse_config s = Ok ()

let string_of_config () = ""
