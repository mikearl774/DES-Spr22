module control(clk, reset, start, keyFound, en1, en2, up);

input logic clk;
input logic reset;
input logic start;
input logic keyFound;
output logic en1, en2, up;


typedef enum logic [1:0] {S0,S1,S2,S3} statetype;
statetype state, nextstate;

  // state register
   always_ff @(posedge clk, posedge reset)
     if (reset) state <= S0;
     else       state <= nextstate;

    // next state + output logic
    always_comb
    case(state)

    S0: begin//idle
        en1 <= 1'b0;
        en2 <= 1'b0;
        up <= 1'b0;
        if(start == 1'b1) begin
            nextstate <= S1;
        end
        else nextstate <= S0;
    end

    S1: begin//upCount
        en1 <= 1'b0;
        en2 <= 1'b0;
        up <= 1'b1;
        nextstate <= S2;

    end

    S2: begin//store
        en1 <= 1'b1;
        en2 <= 1'b0;
        up <= 1'b0;
        if (keyFound != 1'b1) begin
            nextstate <= S1;
        end
        else nextstate <= S3;
    end


    S3: begin//foundkey
        en1 <= 1'b0;
        en2 <= 1'b1;
        up <= 1'b0;
        
        if (start == 1'b1) begin
            nextstate <= S3;
        end
        else nextstate <= S0;

    end

    default: begin
       
        nextstate <= S0;
    end
endcase

endmodule
