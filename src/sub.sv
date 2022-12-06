// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2003 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0
// ======================================================================

module sub
(
   input clk,
   input reset,

   input[31:0] a,
   input[31:0] b,

   output var[31:0] c
);
   always_ff @(posedge clk)
   begin
      if (reset == 1'b1)
      begin
         c = 0;
      end
      else
      begin
         c = a - b;
      end
   end

endmodule
