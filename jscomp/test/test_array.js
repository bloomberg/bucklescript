'use strict';

var $$Array = require("../../lib/js/array.js");
var Caml_array = require("../../lib/js/caml_array.js");

var v = /* @__PURE__ */Caml_array.caml_make_vect(6, 5);

Caml_array.caml_make_float_vect(30);

var h = $$Array.sub(v, 0, 2);

var hhh = $$Array.append([
      1,
      2,
      3,
      4
    ], [
      1,
      2,
      3,
      5
    ]);

var u = Caml_array.caml_array_concat({
      hd: [
        1,
        2
      ],
      tl: {
        hd: [
          2,
          3
        ],
        tl: {
          hd: [
            3,
            4
          ],
          tl: /* [] */0
        }
      }
    });

var hh = $$Array.blit;

exports.v = v;
exports.h = h;
exports.hh = hh;
exports.hhh = hhh;
exports.u = u;
/*  Not a pure module */
