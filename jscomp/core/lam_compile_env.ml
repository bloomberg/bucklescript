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








module E = Js_exp_make  
module S = Js_stmt_make

type path = string 

type ml_module_info = { 
  cmj_table : Js_cmj_format.t ;
  cmj_path : path;
}

type env_value = 
  | Visit of ml_module_info
  | Runtime  of ml_module_info
  (** 
     [Runtime (pure, path, cmj_format)]
     A built in module probably from our runtime primitives, 
      so it does not have any [signature]

  *)
  | External  
  (** Also a js file, but this belong to third party 
  *)




type ident_info = {
  (* id : Ident.t; *)
  name : string;
  arity : Js_cmj_format.arity; 
  closed_lambda : Lam.t option 
}

(*
   refer: [Env.find_pers_struct]
   [ find_in_path_uncap !load_path (name ^ ".cmi")]
*)



let cached_tbl  : env_value Lam_module_ident.Hash.t
   = Lam_module_ident.Hash.create 31
let (+>) = Lam_module_ident.Hash.add cached_tbl


(* For each compilation we need reset to make it re-entrant *)
let reset () = 
  Translmod.reset ();
  Lam_module_ident.Hash.clear cached_tbl 





(** We should not provide "#moduleid" as output
    since when we print it in the end, it will 
    be escaped quite ugly
*)
let add_js_module 
    (hint_name : External_ffi_types.module_bind_name)
    module_name : Ident.t 
  = 
  let id = 
    Ident.create @@ 
      (match hint_name with 
       | Phint_name hint_name -> 
        Ext_string.capitalize_ascii hint_name 
        (* make sure the module name is capitalized
           TODO: maybe a warning if the user hint is not good
        *)
       | Phint_nothing -> 
         Ext_modulename.js_id_name_of_hint_name module_name
      )
  in
  let lam_module_ident = 
    Lam_module_ident.of_external id module_name in  
  match Lam_module_ident.Hash.find_key_opt cached_tbl lam_module_ident with   
  | None ->
    Lam_module_ident.Hash.add 
      cached_tbl 
      lam_module_ident
      External;
    id
  | Some old_key ->
    old_key.id 






let cached_find_ml_id_pos (module_id : Ident.t) name : ident_info =
  let oid  = Lam_module_ident.of_ml module_id in
  match Lam_module_ident.Hash.find_opt cached_tbl oid with 
  | None -> 
    let cmj_path, cmj_table = 
      Js_cmj_load.find_cmj_exn (module_id.name ^ Literals.suffix_cmj) in
    oid  +> Visit {  cmj_table ; cmj_path  }  ;
    let arity, closed_lambda =        
      Js_cmj_format.query_by_name cmj_table name         
    in
    {
      name ;
      arity ;
      closed_lambda
    }
    
  | Some (Visit { cmj_table } )
    -> 
    let arity , closed_lambda =  
      Js_cmj_format.query_by_name cmj_table name 
    in
    { 
      name; 
      arity;
      closed_lambda
      (* TODO shall we cache the arity ?*) 
    } 
  | Some (Runtime _) -> assert false
  | Some External  -> assert false




(* TODO: it does not make sense to cache
   [Runtime] 
   and [externals]*)
type _ t = 
  | No_env :  (path * Js_cmj_format.t) t 
  | Has_env :  bool t (* Indicate it is pure or not *)


(* -FIXME: 
  Here [not_found] only means cmi not found, not cmj not found *)
let query_and_add_if_not_exist 
    (type u)
    (oid : Lam_module_ident.t) 
    (env : u t) ~not_found ~(found: u -> _) =
  match Lam_module_ident.Hash.find_opt cached_tbl oid with 
  | None -> 
    begin match oid.kind with
      | Runtime  -> 
        let (cmj_path, cmj_table) as cmj_info = 
          Js_cmj_load.find_cmj_exn (Lam_module_ident.name oid ^ Literals.suffix_cmj) in           
        oid +> Runtime {cmj_path;cmj_table} ; 
         (match env with 
          | Has_env  -> 
            found true
          | No_env -> 
            found cmj_info)        
      | Ml 
        -> 
        let (cmj_path, cmj_table) as cmj_info = 
          Js_cmj_load.find_cmj_exn (Lam_module_ident.name oid ^ Literals.suffix_cmj) in           
        oid +> Visit {cmj_table;cmj_path } ;  
        ( match env with 
          | Has_env  -> 
            found  (Js_cmj_format.is_pure cmj_table)
          | No_env -> 
            found cmj_info)


      | External _  -> 
        oid +> External;
        (** This might be wrong, if we happen to expand  an js module
            we should assert false (but this in general should not happen)
        *)
        begin match env with 
          | Has_env  
            -> 
            found false
          | No_env -> 
            found (Ext_string.empty, Js_cmj_format.no_pure_dummy)
            (* FIXME: #154, it come from External, should be okay *)
        end

    end
  | Some (Visit { cmj_table; cmj_path}) -> 
    begin match env with 
      | Has_env  -> 
        found   (Js_cmj_format.is_pure cmj_table)
      | No_env  -> found (cmj_path,cmj_table)
    end

  | Some (Runtime {cmj_path; cmj_table}) -> 
    begin match env with 
      | Has_env  -> 
        found true
      | No_env -> 
        found (cmj_path, cmj_table) 
    end
  | Some External -> 
    begin match env with 
      | Has_env  -> 
        found false
      | No_env -> 
        found (Ext_string.empty, Js_cmj_format.no_pure_dummy) (* External is okay *)
    end




let get_package_path_from_cmj 
    ( id : Lam_module_ident.t) 
   = 
  match Lam_module_ident.Hash.find_opt cached_tbl id with 
  | Some (Visit {cmj_table ; cmj_path}) -> 
     (cmj_path, 
          Js_cmj_format.get_npm_package_path cmj_table, 
          Js_cmj_format.get_cmj_case cmj_table )
  | Some (
   External | 
   Runtime _ ) -> 
    assert false  
      (* called by {!Js_name_of_module_id.string_of_module_id}
        can not be External
      *)
  | None -> 
    begin match id.kind with 
    | Runtime 
    | External _ -> assert false
    | Ml -> 
      let (cmj_path, cmj_table) = 
        Js_cmj_load.find_cmj_exn (Lam_module_ident.name id ^ Literals.suffix_cmj) in           
      id +> Visit {cmj_table;cmj_path };  
      (cmj_path, 
       Js_cmj_format.get_npm_package_path cmj_table, 
       Js_cmj_format.get_cmj_case cmj_table )              
    end 

let add = Lam_module_ident.Hash_set.add



(* let is_pure_module (id : Lam_module_ident.t) = 
  match id.kind with 
  | Runtime -> true 
  | External _ -> false
  | Ml -> 
    match Lam_module_ident.Hash.find_opt cached_tbl id with
    | Some (Visit {cmj_table = {pure}}) -> pure 
    | Some _ -> assert false 
    | None ->  *)



(* Conservative interface *)
let is_pure_module (id : Lam_module_ident.t)  = 
  id.kind = Runtime ||
  query_and_add_if_not_exist id No_env
    ~not_found:(fun _ -> false) 
    ~found:(fun (_,x) -> 
      Js_cmj_format.is_pure x)

let get_required_modules 
    extras 
    (hard_dependencies 
     : Lam_module_ident.Hash_set.t) : Lam_module_ident.t list =  
  Lam_module_ident.Hash.iter cached_tbl (fun id  _  ->
      if not @@ is_pure_module id 
      then add  hard_dependencies id);
  Lam_module_ident.Hash_set.iter extras (fun id  -> 
      (if not @@ is_pure_module  id 
       then add hard_dependencies id : unit)
    );
  Lam_module_ident.Hash_set.elements hard_dependencies
