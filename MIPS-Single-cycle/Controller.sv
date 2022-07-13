module Controller (input zero, input [5:0] opcode ,input [5:0] func ,input clk , output reg jlselD , jlselR , jsel , jrsel , ALUsrc , RegDst , RegWrite , MemRead , MemWrite , PCSrc , MemtoReg , output reg [2:0] ALUop);
    always @(opcode, func) 
    begin
        {jlselD , jlselR , jsel , jrsel , ALUsrc , RegDst , RegWrite , MemRead , MemWrite , PCSrc , MemtoReg , ALUop}= 14'b0;
        case (opcode)
            6'b000000:// R Types 
                begin jlselD = 0; jlselR = 0; jsel =0 ;  ALUsrc = 0; RegDst = 1; RegWrite = 1;  PCSrc = 0; MemtoReg = 0; ALUop = func[2:0]; end
            6'b001000:// Add i
                begin jlselD = 0; jlselR = 0; jsel =0 ;  ALUsrc = 1; RegDst = 0; RegWrite = 1;  PCSrc = 0; MemtoReg = 0 ; ALUop = 3'b000 ; end
            6'b001010: // Slti
                begin jlselD = 0; jlselR = 0; jsel =0 ;  ALUsrc = 1; RegDst = 0; RegWrite = 1;  PCSrc = 0; MemtoReg = 0 ; ALUop = 3'b100 ; end
            6'b100011: // Load word 
                begin jlselD = 0; jlselR = 0; jsel =0 ;  ALUsrc = 1; RegDst = 0; RegWrite = 1; MemRead = 1; MemWrite = 0 ;PCSrc = 0; MemtoReg = 1 ; ALUop = 3'b000 ; end
            6'b101011: // Store word 
                begin jlselD = 0; jlselR = 0; jsel =0 ;  ALUsrc = 1; RegDst = 0; RegWrite = 0; MemRead = 0; MemWrite = 1 ;PCSrc = 0; MemtoReg = 0 ; ALUop = 3'b000 ; end
            6'b000010: // Jump Address 
                begin jlselD = 0; jlselR = 0; jsel =1 ; jrsel = 0 ; RegDst = 0; RegWrite = 0; MemRead = 0; MemWrite = 0 ;PCSrc = 0; MemtoReg = 0 ; ALUop = 3'b000 ; end
            6'b000011: // Jump and Link
                begin jlselD = 0; jlselR = 1; jsel =1; jrsel = 0 ;  ALUsrc = 0; RegDst = 0; RegWrite = 0; MemRead = 0; MemWrite = 0 ;PCSrc = 0; MemtoReg = 0 ; ALUop = 3'b000 ; end
            6'b000100: // Jump Register 
                begin jlselD = 0; jlselR = 0; jsel =1; jrsel = 1 ;  ALUsrc = 0; RegDst = 0; RegWrite = 0; MemRead = 0; MemWrite = 0 ;PCSrc = 0; MemtoReg = 0 ; ALUop = 3'b000 ; end
            6'b111000: // Branch Equal
                begin jlselD = 0; jlselR = 0; jsel =0; jrsel = 0 ;  ALUsrc = 0; RegDst = 0; RegWrite = 0; MemRead = 0; MemWrite = 0 ;PCSrc = zero; MemtoReg = 0 ; ALUop = 3'b001 ; end
        endcase
    end
endmodule