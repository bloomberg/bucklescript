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

let (//) = Ext_path.combine






let handle_generators oc 
    (group : Bsb_file_groups.file_group) 
    custom_rules =   
  let map_to_source_dir = 
    (fun x -> Bsb_config.proj_rel (group.dir //x )) in  
  Ext_list.iter group.generators (fun {output; input; command} -> 
      begin match String_map.find_opt custom_rules command with 
        | None -> Ext_pervasives.failwithf ~loc:__LOC__ "custom rule %s used but  not defined" command
        | Some rule -> 
          begin match output, input with
            | output::outputs, input::inputs -> 
              Bsb_ninja_util.output_build oc 
                ~outputs:(Ext_list.map  outputs  map_to_source_dir)
                ~inputs:(Ext_list.map inputs map_to_source_dir) 
                ~output:(map_to_source_dir output)
                ~input:(map_to_source_dir input)
                ~rule
            | [], _ 
            | _, []  -> Ext_pervasives.failwithf ~loc:__LOC__ "either output or input can not be empty in rule %s" command
          end
      end
    )


let make_common_shadows     
    package_specs 
    dirname 
    dir_index 
  : Bsb_ninja_util.shadow list 
  =
  
    { key = Bsb_ninja_global_vars.g_pkg_flg;
      op = 
        Append
          (Bsb_package_specs.package_flag_of_package_specs
             package_specs dirname
          )
    } ::
    (if Bsb_dir_index.is_lib_dir dir_index  then [] else
       [         
        { key =  Bsb_ninja_global_vars.g_dev_incls;
          op = OverwriteVar (Bsb_dir_index.string_of_bsb_dev_include dir_index);          
        }
       ]
    )   
  


let emit_impl_build
    (rules : Bsb_ninja_rule.builtin)  
    (package_specs : Bsb_package_specs.t)
    (group_dir_index : Bsb_dir_index.t) 
    oc 
    ~bs_suffix
    ~(no_intf_file : bool) 
    js_post_build_cmd
    ~is_re
    namespace
    filename_sans_extension
  : unit =    
  let is_dev = not (Bsb_dir_index.is_lib_dir group_dir_index) in
  let input = 
    Bsb_config.proj_rel 
      (if is_re then filename_sans_extension ^ Literals.suffix_re 
       else filename_sans_extension ^ Literals.suffix_ml  ) in
  let output_mlast = filename_sans_extension  ^ Literals.suffix_mlast in
  let output_mliast = filename_sans_extension  ^ Literals.suffix_mliast in
  let output_d = filename_sans_extension ^ Literals.suffix_d in
  let output_filename_sans_extension = 
    match namespace with 
    | None -> 
      filename_sans_extension 
    | Some ns -> 
      Ext_namespace.make ~ns filename_sans_extension
  in 
  let output_cmi =  output_filename_sans_extension ^ Literals.suffix_cmi in
  let output_cmj =  output_filename_sans_extension ^ Literals.suffix_cmj in
  let output_js =
    Bsb_package_specs.get_list_of_output_js package_specs bs_suffix output_filename_sans_extension in 
  let common_shadows = 
    make_common_shadows package_specs
      (Filename.dirname output_cmi)
      group_dir_index in  
  let ast_rule =             
    match is_dev, is_re with 
    | true, true -> rules.build_ast_from_re_dev
    | false, true -> rules.build_ast_from_re
    | true, false -> rules.build_ast_dev
    | false, false -> rules.build_ast in     
  Bsb_ninja_util.output_build oc
    ~output:output_mlast
    ~input
    ~rule:ast_rule;
  if not no_intf_file then begin           
    Bsb_ninja_util.output_build oc
      ~output:output_mliast
      (* TODO: we can get rid of absloute path if we fixed the location to be 
          [lib/bs], better for testing?
      *)
      ~input:(Bsb_config.proj_rel 
                (if is_re then filename_sans_extension ^ Literals.suffix_rei 
                 else filename_sans_extension ^ Literals.suffix_mli))
      ~rule:ast_rule
    ;
    Bsb_ninja_util.output_build oc
      ~output:output_cmi
      ~shadows:common_shadows
      ~order_only_deps:[output_d]
      ~input:output_mliast
      ~rule:(match is_re,is_dev with 
             | true, false -> rules.re_cmi 
             | true, true -> rules.re_cmi_dev 
             | false, false -> rules.ml_cmi
             | false, true -> rules.ml_cmi_dev             
             )
    ;
  end;
  Bsb_ninja_util.output_build
    oc
    ~output:output_d
    ~inputs:(if not no_intf_file then [output_mliast] else [])
    ~input:output_mlast
    ~rule:rules.build_bin_deps
    ?shadows:(if Bsb_dir_index.is_lib_dir group_dir_index then None
              else Some [{Bsb_ninja_util.key = Bsb_build_schemas.bsb_dir_group ; 
                          op = 
                            Overwrite (string_of_int (group_dir_index :> int)) }])
  ;
  let shadows =
    match js_post_build_cmd with
    | None -> common_shadows
    | Some cmd ->
      {key = Bsb_ninja_global_vars.postbuild;
       op = Overwrite ("&& " ^ cmd ^ Ext_string.single_space ^ String.concat Ext_string.single_space output_js)} 
      :: common_shadows
  in
  let rule , cm_outputs, implicit_deps =
    if no_intf_file then 
      (match is_re, is_dev with
      | true, false -> rules.re_cmj_cmi_js 
      | false, false ->  rules.ml_cmj_cmi_js
      | true, true -> rules.re_cmj_cmi_js_dev
      | false, true -> rules.ml_cmj_cmi_js_dev
      ), [output_cmi], []
    else  
      (match is_re, is_dev with
      | true, false -> rules.re_cmj_js 
      | false, false -> rules.ml_cmj_js
      | true, true -> rules.re_cmj_js_dev
      | false, true -> rules.ml_cmj_js_dev), []  , [output_cmi]
  in
  Bsb_ninja_util.output_build oc
    ~output:output_cmj
    ~shadows
    ~implicit_outputs:  (output_js @ cm_outputs)
    ~input:output_mlast
    ~implicit_deps
    ~order_only_deps:[output_d]
    ~rule



let handle_module_info 
    rules
    (group_dir_index : Bsb_dir_index.t)
    (package_specs : Bsb_package_specs.t) 
    js_post_build_cmd
    ~bs_suffix
    oc  module_name 
    ( {name_sans_extension = input} as module_info : Bsb_db.module_info)
    namespace
  : unit =
  emit_impl_build  rules
    package_specs
    group_dir_index
    oc 
    ~bs_suffix
    ~no_intf_file:(module_info.mli_info = Mli_empty)
    ~is_re:module_info.is_re
    js_post_build_cmd      
    namespace
    input 



let handle_file_group 
    oc 
    ~bs_suffix
    ~(rules : Bsb_ninja_rule.builtin)
    ~package_specs 
    ~js_post_build_cmd  
    (files_to_install : String_hash_set.t) 
    (namespace  : string option)
    (group: Bsb_file_groups.file_group ) 
  : unit =

  handle_generators oc group rules.customs ;
  String_map.iter group.sources   (fun  module_name module_info   ->
      let installable =
        match group.public with
        | Export_all -> true
        | Export_none -> false
        | Export_set set ->  
          String_set.mem set module_name in
      if installable then 
        String_hash_set.add files_to_install (Bsb_db.filename_sans_suffix_of_module_info module_info);
      (handle_module_info rules
        ~bs_suffix
         group.dir_index 
         package_specs js_post_build_cmd 
         oc 
         module_name 
         module_info
         namespace
      )
    ) 


let handle_file_groups
    oc 
    ~package_specs 
    ~bs_suffix
    ~js_post_build_cmd
    ~files_to_install 
    ~rules
    (file_groups  :  Bsb_file_groups.file_groups)
    namespace   =
  Ext_list.iter file_groups
    (handle_file_group 
       oc  
       ~bs_suffix ~package_specs ~rules ~js_post_build_cmd
       files_to_install 
       namespace
    ) 
  
