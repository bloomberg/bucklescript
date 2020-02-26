(* Copyright (C) 2017 Authors of BuckleScript
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

let bsdeps = ".bsdeps"

let (//) = Ext_path.combine

#if BS_NATIVE then 
let collect_dependency_info ~per_proj_dir ~config:(config : Bsb_config_types.t) = 
  let dependency_info : Bsb_dependency_info.t = {
    all_external_deps = [];
  } in

  Bsb_build_util.walk_all_deps per_proj_dir
    (fun {top; proj_dir} ->
      if not top then begin
      dependency_info.all_external_deps <- (proj_dir // (Lazy.force Bsb_global_backend.lib_ocaml_dir)) :: dependency_info.all_external_deps;
    end
  );
  dependency_info.all_external_deps <- List.rev dependency_info.all_external_deps;
  dependency_info
#end

(** Regenerate ninja file by need based on [.bsdeps]
    return None if we dont need regenerate
    otherwise return Some info
*)
let regenerate_ninja 
#if BS_NATIVE then
    ~dependency_info
    ~is_top_level
    ~root_project_dir
    ~main_config:(config : Bsb_config_types.t)
    ~ocaml_dir
#end
    ~(toplevel_package_specs : Bsb_package_specs.t option)
    ~forced ~per_proj_dir
  : Bsb_config_types.t option =  
#if BS_NATIVE then
  let toplevel = is_top_level in
#else
  let toplevel = toplevel_package_specs = None in 
#end
  let lib_artifacts_dir = Lazy.force Bsb_global_backend.lib_artifacts_dir in
  let lib_bs_dir =  per_proj_dir // lib_artifacts_dir  in 
  let output_deps = lib_bs_dir // bsdeps in
  let check_result  =
    Bsb_ninja_check.check 
      ~per_proj_dir:per_proj_dir  
      ~forced ~file:output_deps in
  Bsb_log.info
    "@{<info>BSB check@} build spec : %a @." Bsb_ninja_check.pp_check_result check_result ;
  match check_result  with 
  | Good ->
    None  (* Fast path, no need regenerate ninja *)
  | Bsb_forced 
  | Bsb_bsc_version_mismatch 
  | Bsb_file_not_exist 
  | Bsb_source_directory_changed  
  | Other _ -> 
    if check_result = Bsb_bsc_version_mismatch then begin 
      Bsb_log.warn "@{<info>Different compiler version@}: clean current repo@.";
      Bsb_clean.clean_self  per_proj_dir; 
    end ; 
    
#if BS_NATIVE = false then
    let config = 
      Bsb_config_parse.interpret_json 
        ~toplevel_package_specs
        ~per_proj_dir in 
#end
    (* create directory, lib/bs, lib/js, lib/es6 etc *)    
    Bsb_build_util.mkp lib_bs_dir;         
    Bsb_package_specs.list_dirs_by config.package_specs
      (fun x -> 
        let dir = per_proj_dir // x in (*Unix.EEXIST error*)
        if not (Sys.file_exists dir) then  Unix.mkdir dir 0o777);
    if toplevel then       
      Bsb_watcher_gen.generate_sourcedirs_meta
        ~name:(lib_bs_dir // Literals.sourcedirs_meta)
        config.file_groups
    ;
    Bsb_merlin_gen.merlin_file_gen ~per_proj_dir
       config;       
#if BS_NATIVE then  
    let dependency_info = match dependency_info with 
      | None -> 
        (* We check `is_top_level` to decide whether we need to walk the dependencies' graph or not.
           If we are building a dep, we use the top level project's entry.
           
           If we're aiming at building JS, we do NOT walk the external dep graph.
           
           If we're aiming at building Native or Bytecode, we do walk the external 
           dep graph and build a topologically sorted list of all of them. *)
        begin match Lazy.force Bsb_global_backend.backend with
        | Bsb_config_types.Js ->  Bsb_dependency_info.{ all_external_deps = []; }
        | Bsb_config_types.Bytecode
        | Bsb_config_types.Native ->
          if not is_top_level then 
            Bsb_dependency_info.{ all_external_deps = []; }
          else begin
            collect_dependency_info ~per_proj_dir ~config
          end
        end
      | Some all_deps -> all_deps in
#end
    Bsb_ninja_gen.output_ninja_and_namespace_map 
#if BS_NATIVE then
    ~dependency_info 
    ~ocaml_dir 
    ~root_project_dir 
#end
      ~per_proj_dir  ~toplevel config ;             
    (* PR2184: we still need record empty dir 
        since it may add files in the future *)  
    Bsb_ninja_check.record ~per_proj_dir ~file:output_deps 
      (Literals.bsconfig_json::config.file_groups.globbed_dirs) ;
    Some config 


