module pc(input clk , rst , input[31:0] in , output reg[31:0] out);
	reg start;
	always @ (posedge clk , rst) begin
		if(rst)begin
			start = 1'b0;
			out = 32'b0;
		end
		else if(!start)begin
			start = 1'b1;
			out <= out;
		end
		else
			out <= in;
	end
endmodule

module Inst_mem(input[31:0] address , output[31:0] instruction);
    reg[31:0] instructions[100:0];
    initial begin
		instructions[0] = 32'b10001100100000100000001111101000;		//lw
		instructions[4] = 32'b00100000100001000000000000000100;		//addi
		instructions[8] = 32'b00101000100001010000000001010000;		//slti
		instructions[12] = 32'b11100000101000000000000000000110;	//beq
		instructions[16] = 32'b10001100100000110000001111101000;	//lw
		instructions[20] = 32'b00000000010000110010100000000100;	//slt
		instructions[24] = 32'b11100000101000001111111111111010;	//beq
		instructions[28] = 32'b00000000011000000001000000000000;	//add
		instructions[32] = 32'b00000000100000000000100000000000;	//add
		instructions[36] = 32'b00010000000000000000000000000001;	//ja
		instructions[40] = 32'b10101100000000100000011111010000;	//sw
		instructions[44] = 32'b00100000001000010000001111101000;	//addi
		instructions[48] = 32'b10101100000000010000011111010010;	//sw
	end
        assign instruction = instructions[address];
endmodule

module RegisterFile(input clk, rst, reg_write, input [4 : 0]reg1 , reg2 , [4 : 0]write_reg,
                    input [31 : 0]write_data, output reg[31 : 0] data1 , output reg [31 : 0] data2);
	reg [31 : 0]registers[31 : 0];
	always@ (reg1, reg2) begin
			data1 = registers[reg1];
			data2 = registers[reg2];
	end
    integer i;
	always @(posedge clk, posedge rst)
	begin
		if (rst)
			for (i = 0; i < 32; i = i + 1)
				registers[i] = 0;
		else
			if (reg_write)
                if(write_reg != 4'b0)
				    registers[write_reg] = write_data;
	end
endmodule

module DataMem(input clk, mem_write , mem_read,  input [31 : 0]address, input [31 : 0]write_data, output reg [31 : 0]out);
	reg [31 : 0] mem[2036 : 0];
	initial begin
		mem[1000] = {29'b0, 3'b001};
		mem[1004] = {29'b0, 3'b101};
		mem[1008] = {29'b0, 3'b110};
		mem[1012] = {29'b0, 3'b000};
		mem[1016] = {29'b0, 3'b111};
		mem[1020] = {29'b0, 3'b100};
		mem[1024] = {29'b0, 3'b010};
		mem[1028] = {28'b0, 4'b1111};
		mem[1032] = {29'b0, 3'b000};
		mem[1036] = {29'b0, 3'b011};
		mem[1040] = {29'b0, 3'b101};
		mem[1044] = {28'b0, 4'b1000};
		mem[1048] = {29'b0, 3'b011};
		mem[1052] = {29'b0, 3'b101};
		mem[1056] = {29'b0, 3'b111};
		mem[1060] = {29'b0, 3'b101};
		mem[1064] = {29'b0, 3'b100};
		mem[1068] = {29'b0, 3'b110};
		mem[1072] = {29'b0, 3'b000};
		mem[1076] = {29'b0, 3'b001};


    end
	always@ (address) begin 
		if(mem_read)
			out = mem[address];
	end
	always @(posedge clk) begin
		if (mem_write)
			mem[address] = write_data;
	end
endmodule