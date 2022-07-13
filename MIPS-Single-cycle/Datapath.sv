module Datapath(input clk , rst , jlselD , jlselR , jsel , jrsel , ALUsrc , RegDst , RegWrite , MemRead , MemWrite , PCSrc , MemtoReg , input [2 : 0]ALUop
		    , output zero , output [5:0] opcode ,output [5:0] func);
    wire[31:0] pc_input;
    wire[31:0] pc_output , instruction;
    wire[31:0] incremented_pc;
    wire[31:0] proccessed_data_out;
    wire[31:0] write_data_in;
    wire[31:0] read1_out;
    wire[31:0] read2_out;
    wire[31:0] extended_instruction;
    wire[31:0] shifted_extended_output;
    wire[31:0] output_adder2;
    wire[31:0] pc_source_out;
    wire[31:0] shifted_ins_address;
    wire[31:0] j_data_out;
    wire[31:0] ALU_second_input;
    wire[31:0] ALU_output;
    wire[31:0] DataMem_out;
    wire[4:0] mux1out;
    wire[4:0] mux2out;
    wire temp;
    assign temp = rst;
    assign opcode = instruction[31:26];
    assign func = instruction[5:0];
    pc pc1(clk , temp , pc_input , pc_output);
    Inst_mem inst1(pc_output , instruction);
    Adder #(32) adder1(pc_output , 32'd4 , incremented_pc);
    mux2 #(5) m1(instruction[20 : 16] , instruction[15 : 11] , RegDst , mux1out);
    mux2 #(5) m2(mux1out , 5'd31 , jlselR , mux2out);
    mux2 #(32) m3(proccessed_data_out , incremented_pc , jlselD , write_data_in);
    RegisterFile regfile1(clk, rst, RegWrite, instruction[25 : 21] , instruction[20 : 16] , mux2out , write_data_in , read1_out , read2_out);
    sign_extendor signex(instruction[15:0] , extended_instruction);
    shifterleft2 shift2a(extended_instruction , shifted_extended_output);
    Adder #(32) adder2(incremented_pc , shifted_extended_output , output_adder2);
    mux2 #(32) m4(incremented_pc , output_adder2 , PCSrc , pc_source_out);
    shifterleft2 shift2b(instruction[25:0] , shifted_ins_address);
    mux2 #(32) m5({incremented_pc[31:28] ,shifted_ins_address} , read1_out , jrsel , j_data_out);
    mux2 #(32) m6(pc_source_out , j_data_out , jsel , pc_input);
    mux2 #(32) m7(read2_out , extended_instruction , ALUsrc , ALU_second_input);
    ALU alu(read1_out , ALU_second_input , ALUop , ALU_output , zero);
    DataMem datamem(clk , MemWrite , MemRead, ALU_output , read2_out , DataMem_out);
    mux2 #(32) m8(ALU_output , DataMem_out , MemtoReg , proccessed_data_out);
endmodule

    