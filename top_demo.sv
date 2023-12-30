`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/15/2021 06:40:11 PM
// Design Name: 
// Module Name: top_demo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_demo
(
  // input
  input  logic [7:0] sw,
  input  logic [3:0] btn,
  input  logic       sysclk_125mhz,
  input  logic       rst,
  // output  
  output logic [7:0] led,
  output logic sseg_ca,
  output logic sseg_cb,
  output logic sseg_cc,
  output logic sseg_cd,
  output logic sseg_ce,
  output logic sseg_cf,
  output logic sseg_cg,
  output logic sseg_dp,
  output logic [3:0] sseg_an
);

  logic [16:0] CURRENT_COUNT;
  logic [16:0] NEXT_COUNT;
  logic        smol_clk;
  
  logic 	     Start;
 // logic        reset;
  logic [63:0] Key;
  logic [55:0] count;
  logic [15:0] out;
    
  // Place TicTacToe instantiation here
    
    top dut_1 (smol_clk, sw[3], sw[2], 64'h2c2f4516bcea4a32, 64'hef24fa5b5653c78e, count, Key, led[1]);

 

  // 7-segment display
  segment_driver driver(
  .clk(smol_clk),
  .rst(btn[3]),
  .digit0(out[3:0]),
  .digit1(out[7:4]),
  .digit2(out[11:8]),
  .digit3(out[15:12]),
  .decimals({1'b0, btn[2:0]}),
  .segment_cathodes({sseg_dp, sseg_cg, sseg_cf, sseg_ce, sseg_cd, sseg_cc, sseg_cb, sseg_ca}),
  .digit_anodes(sseg_an)
  );

// Register logic storing clock counts
  always@(posedge sysclk_125mhz)
  begin
    if(btn[3])
      CURRENT_COUNT = 17'h00000;
    else
      CURRENT_COUNT = NEXT_COUNT;
  end
  
  // Increment logic
  assign NEXT_COUNT = CURRENT_COUNT == 17'd100000 ? 17'h00000 : CURRENT_COUNT + 1;

  // Creation of smaller clock signal from counters
  assign smol_clk = CURRENT_COUNT == 17'd100000 ? 1'b1 : 1'b0;

   mux41 mux (Key, sw[1:0], out);

endmodule


module mux41 (input logic [63:0] key,
              input logic [1:0] sel,
              output logic [15:0] out);
              
  always @ (*)
  begin
  
  case (sel)
 
  2'b00 : out <= key[63:48];
  2'b01 : out <= key[47:32];
  2'b10 : out <= key[31:16];
  2'b11 : out <= key[15:0];
  
  default : out <= 16'h0000;
  endcase
  end
  endmodule
