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

(**
`jsoo_refmt_main` is the JSOO compilation entry point for building BuckleScript + Refmt + Res syntax as one bundle.
This is usually the file you want to build for the full playground experience.
*)

module Js = Jsoo_common.Js
module Sys_js = Jsoo_common.Sys_js

let export (field : string) v =
  Js.Unsafe.set (Js.Unsafe.global) field v
;;


module Lang = struct
  type t = OCaml | Reason | Res

  let fromString t = match t with
    | "ocaml" | "ml" -> Some OCaml
    | "reason" | "re" -> Some Reason
    | "res" -> Some Res
    | _ -> None

  let toString t = match t with
    | OCaml -> "ml"
    | Reason -> "re"
    | Res -> "res"
end

module BundleConfig = struct
  type t = {
    mutable module_system: Js_packages_info.module_system;
    mutable filename: string option;
    mutable warn_flags: string;
    mutable warn_error_flags: string;
  }

  let make () = {
    module_system=Js_packages_info.NodeJS;
    filename=None;
    warn_flags=Bsc_warnings.defaults_w;
    warn_error_flags=Bsc_warnings.defaults_warn_error;
  }


  let default_filename (lang: Lang.t) = "playground." ^ (Lang.toString lang)

  let string_of_module_system m = (match m with
    | Js_packages_info.NodeJS -> "nodejs"
    | Es6 -> "es6"
    | Es6_global -> "es6_global")
end

type locErrInfo = {
  fullMsg: string; (* Full report string with all context *)
  shortMsg: string; (* simple explain message without any extra context *)
  loc: Location.t;
}

module LocWarnInfo = struct
  type t = {
    fullMsg: string; (* Full super_error related warn string *)
    shortMsg: string; (* Plain warn message without any context *)
    warnNumber: int;
    isError: bool;
    loc: Location.t;
  }
end


exception NapkinParsingErrors of locErrInfo list

module ErrorRet = struct
  type err =
    | SyntaxErr of locErrInfo array
    | TypecheckErr of locErrInfo array
    | WarningFlagErr of string * string (* warning, warning_error flags *)
    | WarningErrs of LocWarnInfo.t array 
    | UnexpectedErr of string

  let locErrorAttributes ~(type_: string) ~(fullMsg: string) ~(shortMsg: string) (loc: Location.t) = 
    let (_file,line,startchar) = Location.get_pos_info loc.Location.loc_start in
    let (_file,endline,endchar) = Location.get_pos_info loc.Location.loc_end in
    Js.Unsafe.([|
      "fullMsg", inject @@ Js.string fullMsg;
      "row"    , inject line;
      "column" , inject startchar;
      "endRow" , inject endline;
      "endColumn" , inject endchar;
      "shortMsg" , inject @@ Js.string shortMsg;
      "type" , inject @@ Js.string type_;
    |])

  let makeWarning ~(type_: string) (e: LocWarnInfo.t) =
    let locAttrs = locErrorAttributes
        ~type_
        ~fullMsg: e.fullMsg
        ~shortMsg: e.shortMsg
        e.loc in
    let warnAttrs =  Js.Unsafe.([|
        "warnNumber", inject @@ (e.warnNumber |> float_of_int |> Js.number_of_float);
        "isError", inject @@ Js.bool e.isError;
      |]) in
    let attrs = Array.append locAttrs warnAttrs in
    Js.Unsafe.obj attrs

  let fromLocErrors ~(type_: string) (errors: locErrInfo array) =
    let jsErrors = Array.map
        (fun (e: locErrInfo) ->
           Js.Unsafe.(obj
                        (locErrorAttributes
                           ~type_
                           ~fullMsg: e.fullMsg
                           ~shortMsg: e.shortMsg
                           e.loc))) errors
    in
    Js.Unsafe.(obj [|
        "errors" , inject @@ Js.array jsErrors;
        "type" , inject @@ Js.string type_
      |])

  let fromTypingError (errors: locErrInfo array) =
    fromLocErrors ~type_:"type_error" errors

  let fromSyntaxErrors (errors: locErrInfo array) =
    fromLocErrors ~type_:"syntax_error" errors

  (* for raised errors caused by malformed warning / warning_error flags *)
  let makeWarningFlagError ~(warn_flags: string) ~(warn_error_flags: string) (msg: string)  =
    Js.Unsafe.(obj [|
        "msg" , inject @@ Js.string msg;
        "warn_flags", inject @@ Js.string warn_flags;
        "warn_error_flags", inject @@ Js.string warn_error_flags;
        "type" , inject @@ Js.string "warning_flag_error"
      |])

  let makeWarningError (errors: LocWarnInfo.t array) =
    let type_ = "warning_error" in
    let jsErrors = Array.map (makeWarning ~type_) errors in
    Js.Unsafe.(obj [|
        "errors" , inject @@ Js.array jsErrors;
        "type" , inject @@ Js.string type_
      |])


  (* for raised errors caused by warn-error enabled flags *)
      (*
  let makeWarningError msg =
    Js.Unsafe.(obj [|
        "msg" , inject @@ Js.string msg;
        "type" , inject @@ Js.string "warning_error"
      |])
         *)

  let makeUnexpectedError msg =
    Js.Unsafe.(obj [|
        "js_error_msg" , inject @@ Js.string msg;
        "type" , inject @@ Js.string "unexpected_error"
      |])

end

let () =
  Bs_conditional_initial.setup_env ();
  Clflags.binary_annotations := false;
  Misc.Color.setup (Some Always);
  Lazy.force Super_main.setup

let error_of_exn e =
  (match Location.error_of_exn e with
  | Some (`Ok e) -> Some e
  | Some `Already_displayed
  | None -> None)

module Converter = Refmt_api.Migrate_parsetree.Convert(Refmt_api.Migrate_parsetree.OCaml_404)(Refmt_api.Migrate_parsetree.OCaml_406)
module Converter404 = Refmt_api.Migrate_parsetree.Convert(Refmt_api.Migrate_parsetree.OCaml_406)(Refmt_api.Migrate_parsetree.OCaml_404)

let get_filename ~(lang: Lang.t) opt =
  match opt with
  | Some fname -> fname
  | None -> BundleConfig.default_filename lang

let lexbuf_from_string ~filename str =
  let lexbuf = Lexing.from_string str in
  lexbuf.lex_start_p <- { lexbuf.lex_start_p with pos_fname = filename };
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = filename };
  lexbuf

let reason_parse ~filename str =
  lexbuf_from_string ~filename str |> Refmt_api.Reason_toolchain.RE.implementation |> Converter.copy_structure;;

let ocaml_parse ~filename str =
  lexbuf_from_string ~filename str |> Parse.implementation

module NapkinDriver = struct
  (* For now we are basically overriding functionality from Napkin_driver *)
  open Napkin_driver

  (* adds ~src parameter *)
  let setup ~src ~filename ~forPrinter () =
    let mode = if forPrinter then Napkin_parser.Default
      else ParseForTypeChecker
    in
    Napkin_parser.make ~mode src filename

  let parse_implementation ~sourcefile ~forPrinter ~src =
    Location.input_name := sourcefile;
    let parseResult =
      let engine = setup ~filename:sourcefile ~forPrinter ~src () in
      let structure = Napkin_core.parseImplementation engine in
      let (invalid, diagnostics) = match engine.diagnostics with
        | [] as diagnostics -> (false, diagnostics)
        | _ as diagnostics -> (true, diagnostics)
      in {
        filename = engine.scanner.filename;
        source = Bytes.to_string engine.scanner.src;
        parsetree = structure;
        diagnostics;
        invalid;
        comments = List.rev engine.comments;
      }
    in
    let () = if parseResult.invalid then
        let errors = parseResult.diagnostics
                     |> List.map (fun d ->
                         let fullMsg = Napkin_diagnostics.toString d parseResult.source in
                         let shortMsg = Napkin_diagnostics.explain d in
                         let loc = {
                           Location.loc_start = Napkin_diagnostics.getStartPos d;
                           Location.loc_end = Napkin_diagnostics.getEndPos d;
                           loc_ghost = false
                         } in
                         {
                           fullMsg;
                           shortMsg;
                           loc;
                         }

                       )
                     |> List.rev
        in
        raise (NapkinParsingErrors errors)
    in
    (parseResult.parsetree, parseResult.comments)
end

let napkin_parse ~filename src =
  let (structure, _ ) = NapkinDriver.parse_implementation ~forPrinter:true ~sourcefile:filename ~src
  in
  structure

module Compile = struct
  (* Apparently it's not possible to retrieve the loc info from 
   * Location.error_of_exn properly, so we need to do some extra
   * overloading action
   * *)
  let warning_infos: LocWarnInfo.t array ref = ref [||]
  let warning_buffer = Buffer.create 512
  let warning_ppf = Format.formatter_of_buffer warning_buffer


  let flush_warning_buffer () =
    Format.pp_print_flush warning_ppf ();
    Buffer.contents warning_buffer

  let super_warning_printer loc ppf w =
    match Warnings.report w with
      | `Inactive -> ()
      | `Active { Warnings. number; is_error; } ->
        Super_location.super_warning_printer loc ppf w;
        let open LocWarnInfo in
        let fullMsg = flush_warning_buffer () in
        let shortMsg = Super_warnings.message w in
        let info = {
          fullMsg;
          shortMsg;
          warnNumber=number;
          isError=is_error;
          loc;
        } in
        warning_infos := Array.append !warning_infos [|info|]

  let () =
    Location.formatter_for_warnings := warning_ppf;
    Location.warning_printer := super_warning_printer

  let handle_err e =
    (match error_of_exn e with
     | Some error ->
       (* This branch handles all 
        * errors handled by the Location error reporting
        * system.
        *
        * Here we can differentiate between the different kinds
        * of error types just by looking at the raised exn names *)
       let type_ = match e with 
         | Typetexp.Error _
         | Typecore.Error _
         | Typemod.Error _ -> "type_error"
         | Lexer.Error _
         | Syntaxerr.Error _ -> "syntax_error"
         | _ -> "other_error"
       in
       let fullMsg = 
         Location.report_error Format.str_formatter error;
         Format.flush_str_formatter ()
       in
       let err = { fullMsg; shortMsg=error.msg; loc=error.loc; } in
       ErrorRet.fromLocErrors ~type_ [|err|]
     | None ->
       match e with
       | NapkinParsingErrors errors ->
         ErrorRet.fromSyntaxErrors(Array.of_list errors)
       | _ ->
         let msg = Printexc.to_string e in
         match e with
         | Warnings.Errors ->
           ErrorRet.makeWarningError !warning_infos
         | Refmt_api.Migrate_parsetree.Def.Migration_error (_,loc) ->
           let error = { fullMsg=msg; shortMsg=msg; loc; } in
           ErrorRet.fromSyntaxErrors [|error|]
         | Refmt_api.Reason_errors.Reason_error (reason_error,loc) ->
           let fullMsg =
             Refmt_api.Reason_errors.report_error Format.str_formatter ~loc reason_error;
             Format.flush_str_formatter ()
           in
           let error = { fullMsg; shortMsg=msg; loc; } in
           ErrorRet.fromSyntaxErrors [|error|]
         | _ -> ErrorRet.makeUnexpectedError msg)

  let implementation ~(config: BundleConfig.t) ~lang str  : Js.Unsafe.obj =
    let {BundleConfig.module_system; warn_flags; warn_error_flags} = config in
    try
      (* Wanna make sure that we don't carry any uncleared warnings *)
      warning_infos := [||];

      Warnings.parse_options false warn_flags;
      Warnings.parse_options true warn_error_flags;
      let filename = get_filename ~lang config.filename in
      let modulename = "Playground" in
      let impl = match lang with
        | Lang.OCaml -> ocaml_parse ~filename
        | Reason -> reason_parse ~filename
        | Res -> napkin_parse ~filename
      in
      (* let env = !Toploop.toplevel_env in *)
      (* Compmisc.init_path false; *)
      (* let modulename = module_of_filename ppf sourcefile outputprefix in *)
      (* Env.set_unit_name modulename; *)
      Lam_compile_env.reset () ;
      let env = Compmisc.initial_env() in (* Question ?? *)
      (* let finalenv = ref Env.empty in *)
      let types_signature = ref [] in
      Js_config.jsx_version := 3; (* default *)
      let ast = impl (str) in
      let ast = Ppx_entry.rewrite_implementation ast in
      let typed_tree =
        let (a,b,_,signature) = Typemod.type_implementation_more modulename modulename modulename env ast in
        (* finalenv := c ; *)
        types_signature := signature;
        (a,b) in
      typed_tree
      |>  Translmod.transl_implementation modulename
      |> (* Printlambda.lambda ppf *) (fun {Lambda.code = lam} ->
          let buffer = Buffer.create 1000 in
          let () = Js_dump_program.pp_deps_program
              ~output_prefix:"" (* does not matter here *)
              module_system
              (Lam_compile_main.compile ""
                 lam)
              (Ext_pp.from_buffer buffer) in
          let v = Buffer.contents buffer in
          Js.Unsafe.(obj [|
              "js_code", inject @@ Js.string v;
              "warnings",
              inject @@ (
                !warning_infos
                |> Array.map (ErrorRet.makeWarning ~type_:"warning")
                |> Js.array
                |> inject
              );
              "type" , inject @@ Js.string "success"
            |]))
    with
    | e -> 
      match e with
      | Arg.Bad msg ->
        ErrorRet.makeWarningFlagError ~warn_flags ~warn_error_flags msg
      | _ -> handle_err e;;

  let parse_and_print ?(filename: string option) ~(from:Lang.t) ~(to_:Lang.t) (src: string) =
    let open Lang in
    let filename = get_filename ~lang:from filename in
    let handle_ret ~lang str =
      Js.Unsafe.(obj [|
          "code", inject @@ Js.string str;
          "lang", inject @@ Js.string (Lang.toString lang);
          "type" , inject @@ Js.string "success"
        |])
    in
    try
      (match (from, to_) with
       | (Reason, OCaml) ->
         src
         |> lexbuf_from_string ~filename
         |> Refmt_api.Reason_toolchain.RE.implementation_with_comments
         |> Refmt_api.Reason_toolchain.ML.print_implementation_with_comments Format.str_formatter;
         handle_ret ~lang:OCaml (Format.flush_str_formatter ())
       | (OCaml, Reason) ->
         src
         |> lexbuf_from_string ~filename
         |> Refmt_api.Reason_toolchain.ML.implementation_with_comments
         |> Refmt_api.Reason_toolchain.RE.print_implementation_with_comments Format.str_formatter;
         handle_ret ~lang:Reason (Format.flush_str_formatter ())
       | (Reason, Res) ->
         let ast = 
           src
           |> lexbuf_from_string ~filename
           |> Refmt_api.Reason_toolchain.RE.implementation
           |> Converter.copy_structure
         in
         let structure = ast
                         |> Napkin_ast_conversion.normalizeReasonArityStructure ~forPrinter:true
                         |> Napkin_ast_conversion.structure
         in
         handle_ret ~lang:Res (Napkin_printer.printImplementation ~width:80 structure ~comments:[])
       | (Res, Reason) ->
         let (structure, _) =
           NapkinDriver.parse_implementation ~forPrinter:true ~sourcefile:filename ~src
         in
         let sanitized = structure
                         |> Napkin_ast_conversion.normalizeReasonArityStructure ~forPrinter:true
                         |> Napkin_ast_conversion.structure
         in
         Refmt_api.Reason_toolchain.RE.print_implementation_with_comments Format.str_formatter (Converter404.copy_structure sanitized, []);
         handle_ret ~lang:Reason (Format.flush_str_formatter ())
       | (OCaml, Res) ->
         let structure = 
           src
           |> lexbuf_from_string ~filename
           |> Parse.implementation
         in
         handle_ret ~lang:Res (Napkin_printer.printImplementation ~width:80 structure ~comments:[])
       | (Res, OCaml) ->
         let (structure, _) =
           NapkinDriver.parse_implementation ~forPrinter:true ~sourcefile:filename ~src
         in
         Pprintast.structure Format.str_formatter structure;
         handle_ret ~lang:OCaml (Format.flush_str_formatter ())
       | (Res, Res) ->
         (* Basically pretty printing *)
         let (structure, comments) =
           NapkinDriver.parse_implementation ~forPrinter:true ~sourcefile:filename ~src
         in
         handle_ret ~lang:Res (Napkin_printer.printImplementation ~width:80 structure ~comments)
       | (OCaml, OCaml) ->
         handle_ret ~lang:OCaml src
       | (Reason, Reason) ->
         let astAndComments = src
                              |> lexbuf_from_string ~filename
                              |> Refmt_api.Reason_toolchain.RE.implementation_with_comments
         in
         Refmt_api.Reason_toolchain.RE.print_implementation_with_comments Format.str_formatter astAndComments;
         handle_ret ~lang:Reason (Format.flush_str_formatter ())
      )
    with
    | e -> handle_err e
end



(* To add a directory to the load path *)
let dir_directory d =
  Config.load_path := d :: !Config.load_path
let () =
  dir_directory "/static"

module Export = struct
  let make_compiler ~config ~lang =
    let open Lang in
    let open Js.Unsafe in
    let baseAttrs = 
      [|"compile",
        inject @@
        Js.wrap_meth_callback
          (fun _ code ->
             (Compile.implementation ~config ~lang (Js.to_string code)));
        "version",
        inject @@
        Js.string 
          (match lang with
           | Reason -> Refmt_api.version
           | Res -> Bs_version.version
           | OCaml -> Sys.ocaml_version);
      |] in
    let attrs =
      if lang != OCaml then
        Array.append baseAttrs [|
          ("pretty_print",
           inject @@
           Js.wrap_meth_callback
             (fun _ code ->
                (match lang with
                 | OCaml -> ErrorRet.makeUnexpectedError ("OCaml pretty printing not supported")
                 | _ -> Compile.parse_and_print ?filename:config.filename ~from:lang ~to_:lang (Js.to_string code))))
        |]
      else
        baseAttrs
    in
    obj attrs

  let make_settings ~(config: BundleConfig.t) = 
    let open Lang in
    let set_module_system value =
      match value with
      | "es6" ->
        config.module_system <- Js_packages_info.Es6; true
      | "nodejs" ->
        config.module_system <- NodeJS; true
      | _ -> false in
    let set_filename value =
      config.filename <- Some value; true
    in
    let set_warn_flags value =
      config.warn_flags <- value; true
    in
    let set_warn_error_flags value =
      config.warn_error_flags <- value; true
    in
    (Js.Unsafe.(obj
                  [|
                    "setModuleSystem",
                    inject @@
                    Js.wrap_meth_callback
                      (fun _ value ->
                         (Js.bool (set_module_system (Js.to_string value)))
                      );
                    "setFilename",
                    inject @@
                    Js.wrap_meth_callback
                      (fun _ value ->
                         (Js.bool (set_filename (Js.to_string value)))
                      );
                    "setWarnFlags",
                    inject @@
                    Js.wrap_meth_callback
                      (fun _ value ->
                         (Js.bool (set_warn_flags (Js.to_string value)))
                      );
                    "setWarnErrorFlags",
                    inject @@
                    Js.wrap_meth_callback
                      (fun _ value ->
                         (Js.bool (set_warn_error_flags (Js.to_string value)))
                      );
                    "list",
                    inject @@
                    Js.wrap_meth_callback
                      (fun _ ->
                         (Js.Unsafe.(obj
                                       [|
                                         "module_system",
                                         inject @@ (
                                           config.module_system
                                           |> BundleConfig.string_of_module_system
                                           |> Js.string
                                         );
                                         "warn_flags",
                                         inject @@ (Js.string config.warn_flags);
                                         "warn_error_flags",
                                         inject @@ (Js.string config.warn_error_flags);
                                       |]))
                      );

                  |]))

  let convert ~(config: BundleConfig.t) = 
    let open Lang in 
    (Js.Unsafe.(obj
                  [|"reason_to_ocaml",
                    inject @@
                    Js.wrap_meth_callback
                      (fun _ code ->
                         (Compile.parse_and_print ?filename:config.filename ~from:Reason ~to_:OCaml (Js.to_string code)));
                    "ocaml_to_reason", inject @@
                    Js.wrap_meth_callback
                      (fun _ code ->
                         (Compile.parse_and_print ?filename:config.filename ~from:OCaml ~to_:Reason (Js.to_string code)));
                    "reason_to_res",
                    inject @@
                    Js.wrap_meth_callback
                      (fun _ code ->
                         (Compile.parse_and_print ?filename:config.filename ~from:Reason ~to_:Res (Js.to_string code)));
                    "res_to_reason",
                    inject @@
                    Js.wrap_meth_callback
                      (fun _ code ->
                         (Compile.parse_and_print ?filename:config.filename ~from:Res ~to_:Reason (Js.to_string code)));
                    "res_to_ocaml",
                    inject @@
                    Js.wrap_meth_callback
                      (fun _ code ->
                         (Compile.parse_and_print ?filename:config.filename ~from:Res ~to_:OCaml (Js.to_string code)));
                    "ocaml_to_res",
                    inject @@
                    Js.wrap_meth_callback
                      (fun _ code ->
                         (Compile.parse_and_print ?filename:config.filename ~from:OCaml ~to_:Res (Js.to_string code)));
                  |]))

  let make () =
    let config = BundleConfig.make () in
    (Js.Unsafe.(obj
                  [|
                    "version",
                    inject @@ Js.string Bs_version.version;
                    "ocaml",
                    inject @@ make_compiler ~config ~lang:OCaml;
                    "reason",
                    inject @@ make_compiler ~config ~lang:Reason;
                    "napkin",
                    inject @@ make_compiler ~config ~lang:Res;
                    "convert",
                    inject @@ convert ~config;
                    "settings",
                    inject @@ make_settings ~config
                  |]))

end

let () =
  let open Lang in
  export "bs_platform"
    (Js.Unsafe.(obj
                  [|
                    "make",
                    inject @@ Export.make
                  |]))

 

(* local variables: *)
(* compile-command: "ocamlbuild -use-ocamlfind -pkg compiler-libs -no-hygiene driver.cmo" *)
(* end: *)

