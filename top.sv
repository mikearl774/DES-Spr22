module top (input logic 	clk, Start, reset,
			input logic  [63:0] plaintext, ciphertext, 
			output logic [55:0] count,
		//	output logic        up, working,
		//	input logic         down,
			output logic  [63:0]  Key, 
			output logic        keyFound
				
      );
	  logic [63:0] counter_64;
      logic [63:0] tempText;

	  logic         en1;
      logic         en2;
      logic [63:0]  d1, d2, q1, q2;
	  logic up;	




                   //clk, reset, count, start, found, en1, en2, up
control control_1 (~clk, reset, Start, keyFound, en1, en2, up);

UDL_Count #(56) counter_1 (clk, reset, up, 1'b0, 1'b0, 56'h000_000_000_000_00, count);

genParity8 genParity8(count, counter_64);

DES des_1 (counter_64, plaintext, 1'b1, tempText);

flopenr ciphertext_Register (clk, reset, en1, tempText, q1);

comparator c (ciphertext,q1,keyFound);

flopenr key_Register (clk, reset, en2, counter_64, Key);

endmodule // top


