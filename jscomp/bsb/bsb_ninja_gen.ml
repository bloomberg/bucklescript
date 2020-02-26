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

let (//) = Ext_path.combine

(* we need copy package.json into [_build] since it does affect build output
   it is a bad idea to copy package.json which requires to copy js files
*)




(* let dash_i = "-I" *)



let get_bsc_flags 
    (bsc_flags : string list)
  : string =       
  String.concat Ext_string.single_space bsc_flags



let emit_bsc_lib_includes 
    (bs_dependencies : Bsb_config_types.dependencies)
  (source_dirs : string list) 
  (external_includes) 
  (namespace : _ option)
  (oc : out_channel): unit = 
  (* TODO: bsc_flags contain stdlib path which is in the latter position currently *)
  let all_includes source_dirs  = 
    source_dirs @
    Ext_list.map bs_dependencies (fun x -> x.package_install_path) @ 
    (
      (* for external includes, if it is absolute path, leave it as is 
         for relative path './xx', we need '../.././x' since we are in 
         [lib/bs], [build] is different from merlin though
      *)
      Ext_list.map
        external_includes

        (fun x -> if Filename.is_relative x then Bsb_config.rev_lib_bs_prefix  x else x) 
    )
  in 
  Bsb_ninja_targets.output_kv
    Bsb_build_schemas.g_lib_incls 
    (Bsb_build_util.include_dirs 
       (all_includes 
          (if namespace = None then source_dirs 
           else Filename.current_dir_name :: source_dirs
           (*working dir is [lib/bs] we include this path to have namespace mapping*)
          )))  oc 


let output_static_resources 
    (static_resources : string list) 
    copy_rule 
    oc
  = 
  Ext_list.iter static_resources (fun output -> 
      Bsb_ninja_targets.output_build
        oc
        ~outputs:[output]
        ~inputs:[Bsb_config.proj_rel output]
        ~rule:copy_rule);
  if static_resources <> [] then
    Bsb_ninja_targets.phony
      oc
      ~order_only_deps:static_resources 
      ~inputs:[]
      ~output:Literals.build_ninja         


let output_ninja_and_namespace_map
    ~per_proj_dir 
    ~toplevel           
#if BS_NATIVE then
    ~dependency_info
    ~ocaml_dir         
    ~root_project_dir
#end
    ({
      bs_suffix;
      package_name;
      external_includes;
      bsc_flags ; 
      pp_file;
      ppx_files ;

      bs_dependencies;
      bs_dev_dependencies;
      refmt;
      js_post_build_cmd;
      package_specs;
      file_groups = { files = bs_file_groups};
      files_to_install;
      built_in_dependency;
      reason_react_jsx;
      generators ;
      namespace ; 
      warning;
      gentype_config; 
      number_of_dev_groups;
      entries;
    } as _config : Bsb_config_types.t) : unit 
  =
  let lib_artifacts_dir = Lazy.force Bsb_global_backend.lib_artifacts_dir in
  let cwd_lib_bs = per_proj_dir // lib_artifacts_dir in 
  
  
#if BS_NATIVE then
  let backend = Lazy.force Bsb_global_backend.backend in
  
  if backend <> Bsb_config_types.Js then begin
    let has_any_entry = List.exists (function
      | Bsb_config_types.JsTarget       _ -> backend = Bsb_config_types.Js
      | Bsb_config_types.NativeTarget   _ -> backend = Bsb_config_types.Native
      | Bsb_config_types.BytecodeTarget _ -> backend = Bsb_config_types.Bytecode
    ) entries in
    if not has_any_entry && toplevel then begin
      Bsb_exception.missing_entry (Lazy.force Bsb_global_backend.backend_string);
    end
  end;


  let g_stdlib_incl_ocaml = Bsb_global_paths.ocaml_lib_dir in
  let ocaml_flags = String.concat Ext_string.single_space Bsb_default.ocaml_flags in
  let ocaml_flags = (List.fold_left (fun acc v ->
     match v with
     | "threads"       -> "-thread " ^ acc
     | "compiler-libs" -> ("-I " ^ (g_stdlib_incl_ocaml // "compiler-libs")) ^ acc
     | _ -> acc
   ) ocaml_flags Bsb_default.ocaml_dependencies) in
  let ocaml_dependencies =
    String.concat
      Ext_string.single_space
      (List.map (Ext_string.inter2 "-add-ocaml-dependency") Bsb_default.ocaml_dependencies) in
  let bsb_helper_verbose = if !Bsb_log.log_level = Bsb_log.Debug then "-verbose" else "" in
  let ocamlc = "ocamlc" in
  let ocamlopt = "ocamlopt" in
  let exe = if Ext_sys.is_windows_or_cygwin then ".exe" else "" in
#end

  let ppx_flags = Bsb_build_util.ppx_flags ppx_files in
  let oc = open_out_bin (cwd_lib_bs // Literals.build_ninja) in          
  let g_pkg_flg , g_ns_flg, ns = 
    match namespace with
    | None -> 
      Ext_string.inter2 "-bs-package-name" package_name, Ext_string.empty, Ext_string.empty
    | Some s -> 
      Ext_string.inter4 
        "-bs-package-name" package_name 
        "-bs-ns" s
      ,
      Ext_string.inter2 "-bs-ns" s,
      s in
  let () = 
    Ext_option.iter pp_file (fun flag ->
        Bsb_ninja_targets.output_kv Bsb_ninja_global_vars.pp_flags
          (Bsb_build_util.pp_flag flag) oc 
      );
    Ext_option.iter gentype_config (fun x -> 
        (* resolved earlier *)
        Bsb_ninja_targets.output_kv Bsb_ninja_global_vars.gentypeconfig
          ("-bs-gentype " ^ x.path) oc
      );    
    Bsb_ninja_targets.output_kvs
      [|
        Bsb_ninja_global_vars.g_pkg_flg, g_pkg_flg ; 
        Bsb_ninja_global_vars.src_root_dir, per_proj_dir (* TODO: need check its integrity -- allow relocate or not? *);
        (* The path to [bsc.exe] independent of config  *)
        Bsb_ninja_global_vars.bsc, (Ext_filename.maybe_quote Bsb_global_paths.vendor_bsc);
        (* The path to [bsb_heler.exe] *)
        Bsb_ninja_global_vars.bsdep, (Ext_filename.maybe_quote Bsb_global_paths.vendor_bsdep) ;
        Bsb_ninja_global_vars.warnings, Bsb_warning.to_bsb_string ~toplevel warning ;
        Bsb_ninja_global_vars.bsc_flags, (get_bsc_flags bsc_flags) ;
        Bsb_ninja_global_vars.ppx_flags, ppx_flags;
#if BS_NATIVE then
        Bsb_ninja_global_vars.ns, if ns <> "" then "-open " ^ ns else "";
        Bsb_ninja_global_vars.g_stdlib_incl_ocaml, g_stdlib_incl_ocaml;
        Bsb_ninja_global_vars.ocaml_flags, ocaml_flags;
        Bsb_ninja_global_vars.ocaml_dependencies, ocaml_dependencies;
        Bsb_ninja_global_vars.ocamlc, (ocaml_dir // "bin" // ocamlc ^ ".opt" ^ exe);
        Bsb_ninja_global_vars.ocamlopt, (ocaml_dir // "bin" // ocamlopt ^ ".opt" ^ exe);
        Bsb_ninja_global_vars.bsb_helper_verbose, bsb_helper_verbose;
        Bsb_ninja_global_vars.external_deps_for_linking, Bsb_build_util.flag_concat "-I" dependency_info.Bsb_dependency_info.all_external_deps;
#end

        Bsb_ninja_global_vars.g_dpkg_incls, 
        (Bsb_build_util.include_dirs_by
           bs_dev_dependencies
           (fun x -> x.package_install_path));  
        Bsb_ninja_global_vars.g_ns , g_ns_flg ; 
        Bsb_build_schemas.bsb_dir_group, "0"  (*TODO: avoid name conflict in the future *)
      |] oc 
  in        
  let  bs_groups, bsc_lib_dirs, static_resources =    
    if number_of_dev_groups = 0 then
      let bs_group, source_dirs,static_resources  =
        Ext_list.fold_left bs_file_groups (Map_string.empty,[],[]) 
          (fun (acc, dirs,acc_resources) ({sources ; dir; resources } as x)   
            ->
            Bsb_db_util.merge  acc  sources ,  
            (if Bsb_file_groups.is_empty x then dirs else  dir::dirs) , 
            ( if resources = [] then acc_resources
              else Ext_list.map_append resources acc_resources (fun x -> dir // x ) )
          )  in
      Bsb_db_util.sanity_check bs_group;
      [|bs_group|], source_dirs, static_resources
    else
      let bs_groups = Array.init  (number_of_dev_groups + 1 ) (fun _ -> Map_string.empty) in
      let source_dirs = Array.init (number_of_dev_groups + 1 ) (fun _ -> []) in
      let static_resources =
        Ext_list.fold_left bs_file_groups [] (fun (acc_resources : string list) {sources; dir; resources; dir_index} 
           ->
            let dir_index = (dir_index :> int) in 
            bs_groups.(dir_index) <- Bsb_db_util.merge bs_groups.(dir_index) sources ;
            source_dirs.(dir_index) <- dir :: source_dirs.(dir_index);
            Ext_list.map_append resources  acc_resources (fun x -> dir//x) 
          ) in
      let lib = bs_groups.((Bsb_dir_index.lib_dir_index :> int)) in               
      Bsb_db_util.sanity_check lib;
      for i = 1 to number_of_dev_groups  do
        let c = bs_groups.(i) in
        Bsb_db_util.sanity_check c;
        Map_string.iter c 
          (fun k a -> 
            if Map_string.mem lib k  then 
              Bsb_db_util.conflict_module_info k a (Map_string.find_exn lib k)            
            ) ;
        Bsb_ninja_targets.output_kv 
          (Bsb_dir_index.(string_of_bsb_dev_include (of_int i)))
          (Bsb_build_util.include_dirs source_dirs.(i)) oc
      done  ;
      bs_groups,source_dirs.((Bsb_dir_index.lib_dir_index:>int)), static_resources
  in

  let digest = Bsb_db_encode.write_build_cache ~dir:cwd_lib_bs bs_groups in
  let rules : Bsb_ninja_rule.builtin = 
      Bsb_ninja_rule.make_custom_rules 
      ~refmt
      ~has_gentype:(gentype_config <> None)
      ~has_postbuild:(js_post_build_cmd <> None)
      ~has_ppx:(ppx_files <> [])
      ~has_pp:(pp_file <> None)
      ~has_builtin:(built_in_dependency <> None)
      ~reason_react_jsx
      ~bs_suffix
      ~digest
      generators in 
  
  emit_bsc_lib_includes bs_dependencies bsc_lib_dirs external_includes namespace oc;
  output_static_resources static_resources rules.copy_resources oc ;
  begin match Lazy.force Bsb_global_backend.backend with
  | Bsb_config_types.Js       ->
    (** Generate build statement for each file *)        
    Ext_list.iter bs_file_groups 
      (fun files_per_dir ->
        Bsb_ninja_file_groups.handle_files_per_dir oc  
          ~bs_suffix     
          ~rules
          ~js_post_build_cmd 
          ~package_specs 
          ~files_to_install    
          ~namespace files_per_dir)
    ;

  Ext_option.iter  namespace (fun ns -> 
      let namespace_dir =     
        per_proj_dir // lib_artifacts_dir  in
      Bsb_namespace_map_gen.output 
        ~dir:namespace_dir ns
        bs_file_groups; 
      Bsb_ninja_targets.output_build oc 
        ~outputs:[ns ^ Literals.suffix_cmi]
        ~inputs:[ns ^ Literals.suffix_mlmap]
        ~rule:rules.build_package
    );
  | Bsb_config_types.Native
  | Bsb_config_types.Bytecode ->
#if BS_NATIVE then
    let (compile_target, rule) =
      if backend = Bsb_config_types.Bytecode then
        Bsb_ninja_native.Bytecode, rules.build_package_build_cmi_bytecode
      else
        Bsb_ninja_native.Native, rules.build_package_build_cmi_native
    in
    Bsb_ninja_native.handle_file_groups oc
      ~bs_suffix
      ~rules
      ~js_post_build_cmd
      ~package_specs
      ~files_to_install
      ~toplevel
      ~compile_target
      ~backend
      ~dependency_info
      ~root_project_dir
      ~config:_config
      bs_file_groups
      namespace;
    Ext_option.iter  namespace (fun ns ->
      let namespace_dir =
        per_proj_dir // lib_artifacts_dir  in
      Bsb_namespace_map_gen.output
        ~dir:namespace_dir ns
        bs_file_groups;
      Bsb_ninja_targets.output_build oc
        ~outputs:[ns ^ Literals.suffix_mlast_simple]
        ~inputs:[ns ^ Literals.suffix_mlmap]
        ~rule:rules.build_package_gen_mlast_simple;
      Bsb_ninja_targets.output_build oc
        ~outputs:[ns ^ Literals.suffix_cmi]
        ~inputs:[ns ^ Literals.suffix_mlast_simple]
        (* When compiling the namespace file, we might not have the cmis ready yet, so we hide that warning. *)
        ~shadows:[{ Bsb_ninja_targets.key = Bsb_ninja_global_vars.warnings; op = Append ("-w -49") }]
        ~rule;
    );
#else
    failwith "Not implemented."
#end
  end;
  close_out oc
