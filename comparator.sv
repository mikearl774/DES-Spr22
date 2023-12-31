module comparator #(parameter WIDTH = 64)
   (input logic [WIDTH-1:0] a, b,
    output logic eq);

   assign eq = (a == b);

endmodule // comparator


