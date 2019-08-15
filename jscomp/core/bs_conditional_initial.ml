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


let setup_env () =
  Clflags.compile_only := true;
  Clflags.bs_only := true;  
  Clflags.no_implicit_current_dir := true; 
  (* default true 
     otherwise [bsc -I sc src/hello.ml ] will include current directory to search path
  *)
  Clflags.assume_no_mli := Clflags.Mli_non_exists;
  Clflags.unsafe_string := false;
  Clflags.debug := true;
  Clflags.record_event_when_debug := false;
  Clflags.binary_annotations := true; 
  Clflags.transparent_modules := true;
  (* Turn on [-no-alias-deps] by default -- double check *)
  Oprint.out_ident := Outcome_printer_ns.out_ident;

#if undefined BS_RELEASE_BUILD then
    Printexc.record_backtrace true;
    (match Ext_sys.getenv_opt "BS_DEBUG_FILE" with 
     | None -> ()       
     | Some s -> 
       Js_config.set_debug_file s 
    );
    (if Ext_sys.getenv_opt "BS_DEBUG_CHROME" <> None then 
      Js_config.debug := true);
#end
  Lexer.replace_directive_bool "BS" true;
  Lexer.replace_directive_string "BS_VERSION"  Bs_version.version
#if false then
  ; Switch.cut := 100 (* tweakable but not very useful *)
#end  

