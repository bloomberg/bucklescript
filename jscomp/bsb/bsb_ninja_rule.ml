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






type t = { 
  mutable used : bool; 
  rule_name : string; 
  name : out_channel -> string 
}

let get_name (x : t) oc = x.name oc
let print_rule oc ~description ?(restat : unit option)  ?dyndep ~command   name  =
  output_string oc "rule "; output_string oc name ; output_string oc "\n";
  output_string oc "  command = "; output_string oc command; output_string oc "\n";
  Ext_option.iter dyndep (fun f ->
      output_string oc "  dyndep = "; output_string oc f; output_string oc  "\n"
    );
  (if restat <>  None then   
     output_string oc "  restat = 1\n");

  output_string oc "  description = " ; output_string oc description; output_string oc "\n"




(** allocate an unique name for such rule*)
let define
    ~command
    ?dyndep
    ?restat
    ?(description = "\027[34mBuilding\027[39m \027[2m${out}\027[22m") (* blue, dim *)
    rule_name : t 
  =

  let rec self = {
    used  = false;
    rule_name ;
    name = fun oc ->
      if not self.used then
        begin
          print_rule oc ~description  ?dyndep ?restat ~command rule_name;
          self.used <- true
        end ;
      rule_name
  } in 

  self




type command = string

type builtin = {
  build_ast : t;
  build_ast_dev : t;
  build_ast_from_re : t ;
  build_ast_from_re_dev : t;
  (* build_ast_from_rei : t ; *)


  (** platform dependent, on Win32,
      invoking cmd.exe
  *)
  copy_resources : t;
  (** Rules below all need restat *)
  build_bin_deps : t ;

  ml_cmj_js : t;
  ml_cmj_js_dev : t;
  ml_cmj_cmi_js : t ;
  ml_cmj_cmi_js_dev : t ;
  ml_cmi : t;
  ml_cmi_dev : t ;
  re_cmj_js : t ;
  re_cmj_js_dev: t;
  re_cmj_cmi_js : t ;
  re_cmj_cmi_js_dev : t ;
  re_cmi : t ;
  re_cmi_dev : t;
  build_package : t ;
  customs : t String_map.t
}


;;

let make_custom_rules 
  ~(has_gentype : bool)        
  ~(has_postbuild : bool)
  ~(has_ppx : bool)
  ~(has_dev_ppx : bool)
  ~(has_pp : bool)
  ~(has_builtin : bool)
  ~(bs_suffix : bool)
  ~(reason_react_jsx : Bsb_config_types.reason_react_jsx option)
  ~(digest : string)
  (custom_rules : command String_map.t) : 
  builtin = 
  (** FIXME: We don't need set [-o ${out}] when building ast 
      since the default is already good -- it does not*)
  let buf = Buffer.create 100 in     
  let mk_ml_cmj_cmd 
      ~read_cmi 
      ~is_re 
      ~is_dev 
      ~postbuild : string =     
    Buffer.clear buf;
    Buffer.add_string buf "$bsc -nostdlib $g_pkg_flg -color always";
    if bs_suffix then
      Buffer.add_string buf " -bs-suffix";
    if is_re then 
      Buffer.add_string buf " -bs-re-out -bs-super-errors";
    if read_cmi then 
      Buffer.add_string buf " -bs-read-cmi";
    if is_dev then 
      Buffer.add_string buf " $g_dev_incls";      
    Buffer.add_string buf " $g_lib_incls" ;
    if is_dev then
      Buffer.add_string buf " $g_dpkg_incls";
    if has_builtin then   
      Buffer.add_string buf " -I $g_std_incl";
    Buffer.add_string buf " $warnings $bsc_flags";
    if has_gentype then
      Buffer.add_string buf " $gentypeconfig";
    Buffer.add_string buf " -o $out -c  $in";
    if postbuild then
      Buffer.add_string buf " $postbuild";
    Buffer.contents buf
  in   
  let mk_ast ~has_pp ~has_ppx ~has_dev_ppx ~has_reason_react_jsx : string =
    Buffer.clear buf ; 
    Buffer.add_string buf "$bsc  $warnings -color always";
    (match has_pp with 
      | `regular -> Buffer.add_string buf " $pp_flags"
      | `refmt -> Buffer.add_string buf {| -pp "$refmt $refmt_flags"|}
      | `none -> ()
      );
    (match has_reason_react_jsx, reason_react_jsx with
    | false, _ 
    | _, None -> ()
    | _, Some Jsx_v2
      -> Buffer.add_string buf " -bs-jsx 2"
    | _, Some Jsx_v3 
      -> Buffer.add_string buf " -bs-jsx 3"
    );
    (match has_dev_ppx, has_ppx with
    | true, _ -> 
      Buffer.add_string buf " $dev_ppx_flags"
    | false, _ -> 
      if has_ppx then 
        Buffer.add_string buf " $ppx_flags"
     ); 
    Buffer.add_string buf " $bsc_flags -c -o $out -bs-syntax-only -bs-binary-ast $in";   
    Buffer.contents buf
  in  
  
  let build_ast =
    define
      ~command:(mk_ast 
                  ~has_pp:(if has_pp then `regular else `none) 
                  ~has_ppx 
                  ~has_dev_ppx:false
                  ~has_reason_react_jsx:false )
      "build_ast" in
  let build_ast_dev  =    
    if has_dev_ppx then 
      define
        ~command:(mk_ast 
                    ~has_pp:(if has_pp then `regular else `none) 
                    ~has_ppx 
                    ~has_dev_ppx:true
                    ~has_reason_react_jsx:false )
        "build_ast_dev" 
    else build_ast in 
  let build_ast_from_re =
    define
      ~command:(mk_ast 
                  ~has_pp:`refmt
                  ~has_ppx
                  ~has_dev_ppx:false
                  ~has_reason_react_jsx:true)
      "build_ast_from_re" in 
  let build_ast_from_re_dev =   
    if has_dev_ppx then 
      define
        ~command:(mk_ast 
                    ~has_pp:`refmt
                    ~has_ppx
                    ~has_dev_ppx:true
                    ~has_reason_react_jsx:true)
        "build_ast_from_re_dev" 
    else 
      build_ast_from_re
  in 
  let copy_resources =    
    define 
      ~command:(
        if Ext_sys.is_windows_or_cygwin then
          "cmd.exe /C copy /Y $in $out > null" 
        else "cp $in $out"
      )
      "copy_resource" in
  let build_bin_deps =
    define
      ~restat:()
      ~command:
      ("$bsdep -hash " ^ digest ^" $g_ns -g $bsb_dir_group $in")
      "build_deps" in 
  let aux ~name ~read_cmi  ~postbuild =
    let postbuild = has_postbuild && postbuild in 
    define
      ~command:(mk_ml_cmj_cmd 
                  ~read_cmi ~is_re:false ~is_dev:false 
                  ~postbuild)
      ~dyndep:"$in_e.d"
      ~restat:() (* Always restat when having mli *)
      name,
    define
      ~command:(mk_ml_cmj_cmd 
                  ~read_cmi ~is_re:false ~is_dev:true
                  ~postbuild)
      ~dyndep:"$in_e.d"
      ~restat:() (* Always restat when having mli *)
      (name ^ "_dev"),
    define
      ~command:(mk_ml_cmj_cmd 
                  ~read_cmi ~is_re:true ~is_dev:false 
                  ~postbuild)
      ~dyndep:"$in_e.d"
      ~restat:() (* Always restat when having mli *)
      (name ^ "_re"),
    define
      ~command:(mk_ml_cmj_cmd 
                  ~read_cmi ~is_re:true ~is_dev:true
                  ~postbuild)
      ~dyndep:"$in_e.d"
      ~restat:() (* Always restat when having mli *)
      (name ^ "_re_dev")  
  in 
  (* [g_lib_incls] are fixed for libs *)
  let ml_cmj_js, ml_cmj_js_dev, re_cmj_js, re_cmj_js_dev =
    aux ~name:"ml_cmj_only" ~read_cmi:true ~postbuild:true in   
  let ml_cmj_cmi_js, ml_cmj_cmi_js_dev, re_cmj_cmi_js, re_cmj_cmi_js_dev =
    aux
      ~read_cmi:false 
      ~name:"ml_cmj_cmi" ~postbuild:true in  
  let ml_cmi, ml_cmi_dev, re_cmi, re_cmi_dev =
    aux 
       ~read_cmi:false  ~postbuild:false
      ~name:"ml_cmi" in 
  let build_package = 
    define
      ~command:"$bsc -w -49 -color always -no-alias-deps -bs-cmi-only -c $in"
      ~restat:()
      "build_package"
  in 
  {
    build_ast ;
    build_ast_dev;
    build_ast_from_re  ;
    build_ast_from_re_dev  ;
    (** platform dependent, on Win32,
        invoking cmd.exe
    *)
    copy_resources;
    (** Rules below all need restat *)
    build_bin_deps ;

    ml_cmj_js ;
    ml_cmj_js_dev ;
    ml_cmj_cmi_js ;
    ml_cmi ;
    re_cmj_js_dev;
    re_cmi_dev;
    ml_cmj_cmi_js_dev;
    ml_cmi_dev;
    re_cmj_cmi_js_dev;
    re_cmj_js ;
    re_cmj_cmi_js ;
    re_cmi ;
    build_package ;
    customs =
      String_map.mapi custom_rules begin fun name command -> 
        define ~command ("custom_" ^ name)
      end
  }


