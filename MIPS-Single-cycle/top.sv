module MIPS(input clk , rst);
    wire zero , jlselD , jlselR , jsel , jrsel , ALUsrc , RegDst , RegWrite , MemRead , MemWrite , PCSrc , MemtoReg;
    wire [2:0] ALUop;
	wire [5:0] opcode , func;
    Datapath Datapath(clk , rst , jlselD , jlselR , jsel , jrsel , ALUsrc , RegDst , RegWrite , MemRead , MemWrite , PCSrc , MemtoReg , ALUop , zero , opcode , func);
    Controller Controller(zero, opcode , func , clk , jlselD , jlselR , jsel , jrsel , ALUsrc , RegDst , RegWrite , MemRead , MemWrite , PCSrc , MemtoReg , ALUop);
endmodule