`timescale 1ns/1ps
module stimulus_class();

  logic 	     Start;
  logic        reset;
  logic [63:0] Key;
  logic [55:0] count;
  logic [63:0] plaintext, ciphertext;
  //logic       up,down,working;


  
  localparam [55:0] countThreshold = 2**23;
  logic 	   keyFound;   
  
  logic 	   clk;   
  
  integer 	   outputFilePointer;
  integer 	   testVectorFilePointer;
  integer      testCounter;
  
  logic [31:0] vectornum;   

  

  
  assign plaintext = 64'h2c2f4516bcea4a32;
  assign ciphertext = 64'hef24fa5b5653c78e;   //real ciphertext
  //assign ciphertext = 64'h9bd53434a55cd2e5; //a ciphertext with a low key= 010101010101014a

                                                                        //0=up,1=down
          //clk, Start, reset,plaintext, ciphertext, count,  up, down, Key, Found  en1, en2
top dut_1 (clk, Start, reset, plaintext, ciphertext, count, Key, keyFound);

  

  initial 
    begin	
	  clk = 1'b0;
	  forever #5 clk = ~clk;
    end

  initial
    begin
	  vectornum = 0;
	  outputFilePointer = $fopen("count.out");
	end
	  

  always @(posedge clk) 
    begin
	  if (keyFound == 1'b1) begin

		#50 $fdisplay(outputFilePointer, "%h %b | %h", Key, keyFound, count);
		$display("Found key!");
		$stop();
      end
	end


  initial
    begin
	  // Initialize
	  #0   Start = 1'b0;	
	  #0   reset = 1'b1;
	  #101 reset = 1'b0;
	  #32  Start = 1'b1;

    

	  //#20  Start = 1'b0;


	  
    end 

endmodule // tb
