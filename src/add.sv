module add
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
         c = a + b;
      end
   end

endmodule
