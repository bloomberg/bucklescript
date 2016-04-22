// Generated CODE, PLEASE EDIT WITH CARE
'use strict';
define(["exports", "../runtime/caml_builtin_exceptions", "../runtime/caml_primitive", "../runtime/caml_string"],
  function(exports, Caml_builtin_exceptions, Caml_primitive, Caml_string){
    'use strict';
    function to_buffer(buff, ofs, len, v, flags) {
      if (ofs < 0 || len < 0 || ofs > (buff.length - len | 0)) {
        throw [
              Caml_builtin_exceptions.invalid_argument,
              "Marshal.to_buffer: substring out of bounds"
            ];
      }
      else {
        return Caml_primitive.caml_output_value_to_buffer(buff, ofs, len, v, flags);
      }
    }
    
    function data_size(buff, ofs) {
      if (ofs < 0 || ofs > (buff.length - 20 | 0)) {
        throw [
              Caml_builtin_exceptions.invalid_argument,
              "Marshal.data_size"
            ];
      }
      else {
        return Caml_primitive.caml_marshal_data_size(buff, ofs);
      }
    }
    
    function total_size(buff, ofs) {
      return 20 + data_size(buff, ofs) | 0;
    }
    
    function from_bytes(buff, ofs) {
      if (ofs < 0 || ofs > (buff.length - 20 | 0)) {
        throw [
              Caml_builtin_exceptions.invalid_argument,
              "Marshal.from_bytes"
            ];
      }
      else {
        var len = Caml_primitive.caml_marshal_data_size(buff, ofs);
        if (ofs > (buff.length - (20 + len | 0) | 0)) {
          throw [
                Caml_builtin_exceptions.invalid_argument,
                "Marshal.from_bytes"
              ];
        }
        else {
          return Caml_primitive.caml_input_value_from_string(buff, ofs);
        }
      }
    }
    
    function from_string(buff, ofs) {
      return from_bytes(Caml_string.bytes_of_string(buff), ofs);
    }
    
    var to_channel = Caml_primitive.caml_output_value
    
    var from_channel = Caml_primitive.caml_input_value
    
    var header_size = 20;
    
    exports.to_channel   = to_channel;
    exports.to_buffer    = to_buffer;
    exports.from_channel = from_channel;
    exports.from_bytes   = from_bytes;
    exports.from_string  = from_string;
    exports.header_size  = header_size;
    exports.data_size    = data_size;
    exports.total_size   = total_size;
    
  })
/* No side effect */
