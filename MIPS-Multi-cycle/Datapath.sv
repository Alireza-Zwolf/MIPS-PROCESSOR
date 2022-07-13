module Datapath(input clk , rst , RegDst , RegWrite , MemRead , MemWrite , pcwrite , pcwritecond , LRwrite , IorD ,
                input [1:0] AluSrcA, AluSrcB , PCSrc , RegDataSel ,
                input [2 : 0]ALUop ,
		        output zero , output [3:0] opcode ,output [8:0] func);
    wire [15:0] pc_input;
    wire [15:0] pc_output , instruction;
    wire [15:0] extended_instruction;
    wire [15:0] ALU_reg_input;
    wire [15:0] DataMem_out;
    wire [4:0] mux1out;
    wire [15:0] alusrca_out_muxed;
    wire [15:0] alusrcb_out_muxed;
    wire [15:0] IorD_Mux_output;
    wire [15:0] IR_out;
    wire [15:0] MDR_out;
    wire [2:0] address_mux_output;
    wire [15:0] Areg_out;
    wire [15:0] Breg_out;
    wire [15:0] Areg_in;
    wire [15:0] Breg_in;
    wire [15:0] ALU_reg_output;
    wire [15:0] write_data_in;
    wire temp;
    assign temp = rst;
    assign opcode = IR_out[15:12];
    assign func = IR_out[8:0];
    pc pc1(clk , temp , pcwrite , pcwritecond , zero , pc_input , pc_output);
    mux2 #(16) IorDMux(pc_output , {4'b0 , IR_out[11:0]} , IorD , IorD_Mux_output);                                                //Multiplexing between the Data from the instruction or the pc counter address
    Nreg #(16) IR(DataMem_out , clk , rst , LRwrite , IR_out);
    Nreg #(16) MDR(DataMem_out , clk , rst , 1 , MDR_out);
    DataMem datamem(clk , MemWrite , MemRead, IorD_Mux_output , Areg_out , DataMem_out);
    mux2 #(3) address_mux(3'd0 , IR_out[11:9] , RegDst , address_mux_output);
    mux4 #(16) register_file_input_muxed(ALU_reg_output , Areg_out , Breg_out , MDR_out , RegDataSel , write_data_in);      // Write Mux
    RegisterFile regfile (clk , rst , RegWrite , 0 , IR_out[11:9] , address_mux_output , write_data_in , Areg_in , Breg_in);
    Nreg #(16) Areg(Areg_in , clk , rst , 1 , Areg_out);
    Nreg #(16) Breg(Breg_in , clk , rst , 1 , Breg_out);
    mux2 #(16) alu_src_a_in(Areg_out , pc_output , AluSrcA , alusrca_out_muxed);
    sign_extendor signex(IR_out[11:0] , extended_instruction);
    mux3 #(16) alu_src_b_in(Breg_out , extended_instruction , 1 , AluSrcB , alusrcb_out_muxed);
    ALU alu(alusrca_out_muxed , alusrcb_out_muxed , ALUop , ALU_reg_input , zero);
    Nreg #(16) ALU_register(ALU_reg_input , clk , rst , 1 , ALU_reg_output);
    mux4 #(16) pc_multiplxer(ALU_reg_input , ALU_reg_output , {4'b0 , IR_out[11:0]} , {7'b0 , IR_out[8:0]} , PCSrc , pc_input);
endmodule

    