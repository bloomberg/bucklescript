(* Copyright (C) 2020 - Authors of BuckleScript
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


type ('a,'b) t 



val sort :
  ('a -> Parsetree.structure) ->
  ('b -> Parsetree.signature) ->
  ('a, 'b) t Map_string.t -> string Queue.t  



(**
   [build fmt files parse_implementation parse_interface]
   Given a list of files return an ast table 
*)
val collect_ast_map :
  Format.formatter ->
  string list ->
  (Format.formatter -> string -> 'a) ->
  (Format.formatter -> string -> 'b) ->
  ('a, 'b) t Map_string.t 

type dir_spec = 
  { dir : string ;
    mutable  excludes : string list 
  }

(** If the genereated queue is empty, it means 
    1. The main module  does not exist (does not exist due to typo)
    2. It does exist but not in search path
    The order matters from head to tail 
*)
val collect_from_main :
  ?extra_dirs:dir_spec list -> 
  ?excludes : string list -> 
  ?alias_map: string Hash_string.t ->
  Format.formatter ->
  (Format.formatter -> string -> 'a) ->
  (Format.formatter -> string -> 'b) ->
  ('a -> Parsetree.structure) ->
  ('b -> Parsetree.signature) ->
  string -> ('a, 'b) t Map_string.t * string Queue.t

val build_queue :
  Format.formatter ->
  string Queue.t ->
  ('b, 'c) t Map_string.t ->
  (Format.formatter -> string -> string -> 'b -> unit) ->
  (Format.formatter -> string -> string -> 'c -> unit) -> unit
  
val handle_queue :
  string Queue.t ->
  ('a, 'b) t Map_string.t ->
  (string -> string -> 'a -> unit) ->
  (string -> string -> 'b  -> unit) ->
  (string -> string -> string -> 'b -> 'a -> unit) -> unit


val build_lazy_queue :
  Format.formatter ->
  string Queue.t ->
  (Parsetree.structure lazy_t, Parsetree.signature lazy_t) t Map_string.t ->
  (Format.formatter -> string -> string -> Parsetree.structure -> unit) ->
  (Format.formatter -> string -> string -> Parsetree.signature -> unit) -> unit  


