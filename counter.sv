`timescale 1ns/1ps
module UDL_Count  #(parameter WIDTH=56) 
   (clk, rst, up, down, load, in, out) ;

   input logic              clk;
   input logic 		    rst;
   input logic 		    up;
   input logic 		    down;
   input logic 		    load;
   input logic [55:0]  in;
   output logic [WIDTH-1:0] out;

   logic [WIDTH-1:0] 	    next;
   
   flop #(WIDTH) count(clk, next, out);

   always_comb begin
      if (rst)
	next = {WIDTH{64'b0}};
      else if (load)
	next = in;
      else if (up)
	next = out + 1'b1;
      else if (down)
	next = out - 1'b1;
      else
	next = out;
   end // always@ *
   
endmodule 

// ordinary flip-flop
module flop #(parameter WIDTH=56) ( 
  input  logic             clk,
  input  logic [WIDTH-1:0] d, 
  output logic [WIDTH-1:0] q);

  always_ff @(posedge clk)
    q <= d;
   
endmodule

module genParity(input logic [6:0] in, output logic [7:0] out);
  assign out[0] = ~^in;
  assign out[7:1] = in;
endmodule

module genParity8(input logic [55:0] in, output logic [63:0] out);
  genvar 						index;
  for(index = 0; index < 8; index++) begin
	genParity genParity(.in(in[7*index +: 7]), .out(out[8*index +: 8]));
  end
endmodule


