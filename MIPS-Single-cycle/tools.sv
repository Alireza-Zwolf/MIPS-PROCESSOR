module ALU(input[31:0] in0 , in1 , input[2:0] select , output reg[31:0]result , output zero);
    always @(in0 , in1 , select) begin
        case(select)
            3'b000: result = in0 + in1;
            3'b001: result = in0 - in1;
            3'b010: result = in0 & in1;
            3'b011: result = in0 | in1;
            3'b100: result = (in0 < in1) ? 1 : 0;
            default: result = 32'b0;
        endcase
    end
    assign zero = (result == 32'b0);
endmodule


module Adder #(parameter N)(input[N - 1 : 0] in1 , in2 , output[N - 1 : 0] out);
    assign out = in1 + in2;
endmodule


module mux2 #(parameter N)(input[N - 1 : 0] in0 , in1 , input select , output[N - 1 : 0] out);
    assign out = select ? in1 : in0;
endmodule


module sign_extendor(input[15:0] in , output[31:0] out);
    genvar i;
    generate
    for(i = 0 ; i < 32 ; i = i + 1)
        assign out[i] = (i < 15) ? in[i] : in[15];        
    endgenerate
endmodule


module shifterleft2(input [31:0] in , output [31:0] out);
    assign out = in << 2;
endmodule
