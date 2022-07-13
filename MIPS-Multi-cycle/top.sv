module MIPS(input clk , rst);
    wire zero , IorD , LRwrite , RegDst , RegWrite , pcwrite , pcwritecond , MemRead , MemWrite;
    wire [1:0] AluSrcA , AluSrcB , PCSrc , RegDataSel;
    wire [2:0] ALUop;
    wire [3:0] opcode; 
	wire [8:0] func;
    Datapath datapath(clk , rst , RegDst , RegWrite , MemRead , MemWrite , pcwrite , pcwritecond , LRwrite , IorD ,
                      AluSrcA, AluSrcB , PCSrc , RegDataSel , ALUop , zero , opcode , func);
    Controller controller(clk , rst , zero ,  opcode , func, IorD , LRwrite , RegDst , RegWrite
                         , pcwrite , pcwritecond , MemRead , MemWrite , AluSrcA , AluSrcB , PCSrc, RegDataSel , ALUop);
endmodule