(* BuckleScript compiler
 * Copyright (C) 2015-2016 Bloomberg Finance L.P.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

(* Author: Hongbo Zhang  *)

val caml_sys_getcwd : unit -> string 


val caml_bswap16 : nativeint -> nativeint
val caml_int32_bswap : nativeint -> nativeint
val caml_nativeint_bswap : nativeint -> nativeint

val caml_convert_raw_backtrace_slot : 
  Printexc.raw_backtrace_slot -> Printexc.backtrace_slot

val imul :int32 -> int32 -> int32
val caml_string_get16 : string -> int -> int
val caml_string_get32 : string -> int -> int
