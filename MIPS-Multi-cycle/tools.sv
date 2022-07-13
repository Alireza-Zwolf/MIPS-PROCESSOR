module ALU(input[15:0] in0 , in1 , input[2:0] select , output reg[15:0]result , output zero);
    always @(in0 , in1 , select) begin
        case(select)
            3'b000: result = in0 + in1;
            3'b001: result = in0 - in1;
            3'b010: result = in0 & in1;
            3'b011: result = in0 | in1;
            3'b100: result = (in0 < in1) ? 1 : 0;
            3'b101: result = ~in1;                        // "Not" in1
            default: result = 16'b0;
        endcase
    end
    assign zero = (result == 16'b0);
endmodule

module Nreg #(parameter N)(input[N - 1 : 0] in , input clk,input rst,input LRwrite, output reg[N-1 : 0] out);
    always @(posedge clk) 
    begin
        if (rst)
        begin
            out <= 0;
        end
        else
        begin
            if (LRwrite)
            begin
                out <= in;
            end
        end
    end
endmodule

module Adder #(parameter N)(input[N - 1 : 0] in1 , in2 , output[N - 1 : 0] out);
    assign out = in1 + in2;
endmodule


module mux3 #(parameter N) (input [N-1:0] in0 , in1 , in2 , input [1:0] sel , output [N-1:0] out);
    assign out = (sel == 2'b00) ? in0 :
                 (sel == 2'b01) ? in1 : in2;
endmodule


module mux2 #(parameter N)(input[N - 1 : 0] in0 , in1 , input select , output[N - 1 : 0] out);
    assign out = select ? in1 : in0;
endmodule

module mux4 #(parameter N) (input [N-1:0] input1 , input [N-1:0] input2,input [N-1:0] input3,input [N-1:0] input4,input[1:0] sel, output [N-1:0] out);    
    assign out = (sel == 2'd0) ? input1 :
                 (sel == 2'd1) ? input2 :
                 (sel == 2'd2) ? input3 : input4; 

endmodule

module sign_extendor(input[11:0] in , output[15:0] out);
    genvar i;
    generate
    for(i = 0 ; i < 16 ; i = i + 1)
        assign out[i] = (i < 11) ? in[i] : in[11];        
    endgenerate
endmodule


module shifterleft2(input [15:0] in , output [15:0] out);
    assign out = in << 2;
endmodule
