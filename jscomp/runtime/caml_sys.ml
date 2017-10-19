(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)





external getEnv : 'a -> string -> string option = "" [@@bs.get_index] [@@bs.return undefined_to_opt]
let caml_sys_getenv s =
    match [%external process ] with 
    | None -> raise Not_found
    | Some x ->  
      begin match getEnv x##env s with 
      | None -> raise Not_found
      | Some x -> x 
      end


(* TODO: improve [js_pass_scope] to avoid remove unused n here *)

external now : unit -> float = "" [@@bs.val "Date.now"]


(* let caml_initial_time = now ()  *. 0.001 *)

type process
external uptime : process -> unit -> float = "" [@@bs.send]
external exit : process -> int -> 'a =  ""  [@@bs.send]

let caml_sys_time () =
  match [%external process] with 
  | None -> -1.
  | Some x -> uptime x ()

  (* (now () *. 0.001) -. caml_initial_time *)

external random : unit -> float = "Math.random" [@@bs.val]

let caml_sys_random_seed () : nativeint array = 
   [|
     Nativeint.of_float 
     ((Nativeint.to_float (Nativeint.logxor (Nativeint.of_float (now ()))
                             0xffffffffn)) *. random ()) |]

let caml_sys_getcwd () = 
  match [%external process] with 
  | None ->  "/"
  | Some x -> x##cwd ()

(* Called by {!Sys} in the toplevel, should never fail*)
let caml_sys_get_argv () : string * string array = 
  match [%external process] with 
  | None -> ("",[|""|])
  | Some process ->
    if Js.testAny process##argv then
      ("",[|""|])
    else
      (* The first 2 elements of node's process.argv are the node executable and
        the entry point JS script. This breaks any OCaml code which assumes the
        program's "real" argv starts at index 1. Here, we take process.argv[0] as
        Sys.executable_name, and process.argv[1..] as Sys.argv to get around that
        snag. *)
      (
        Array.unsafe_get process##argv 0,
        Caml_array.caml_array_sub process##argv 1 ((Array.length process##argv) - 1)
      )

(** {!Pervasives.sys_exit} *)
let caml_sys_exit exit_code = 
  match [%external process] with 
  | None -> ()
  | Some x -> exit x exit_code
