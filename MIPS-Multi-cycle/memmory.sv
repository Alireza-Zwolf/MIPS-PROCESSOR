
module pc(input clk , rst , input pc_write , input pcwritecond , input zero , input[15:0] in , output reg[15:0] out);
	reg start;
	always @ (posedge clk , posedge rst) begin
		if(rst)begin
			start <= 1'b0;
			out <= 9'b0;
		end
		else if(!start)begin
			start <= 1'b1;
			out <= out;
		end
		else
			if (pc_write || (pcwritecond && zero))
			begin
				out <= in;
			end
	end
endmodule

module RegisterFile(input clk, rst, reg_write , input [2 : 0] address0 , address1 , input [2:0] write_reg ,
                    input [15 : 0]write_data , output reg[15 : 0] data0 , output reg[15 : 0] data1);
	reg [15 : 0]registers[7 : 0];
	assign data0 = registers[0];
	assign data1 = registers[address1];
    integer i;
	always @(posedge clk, posedge rst)
	begin
		if (rst)
			for (i = 0; i < 8; i = i + 1)
				registers[i] = 0;
		else
			if (reg_write)
				registers[write_reg] = write_data;
	end
endmodule

module DataMem(input clk, mem_write , mem_read,  input [15 : 0]address, input [15 : 0]write_data, output reg [15 : 0]out);
	reg [15 : 0] mem[2036 : 0];
	initial begin
		/*
		mem[0] = {16'b0000000001100100};				//lw
		mem[1] = {16'b1100000001100100};				//addi
		mem[2] = {16'b1101000001000000};				//subi
		//mem[3] = {16'b1110000000100001};				//andi
		mem[3] = {16'b1000011000000001};				//MoveTo
		mem[4] = {16'b0001000011111010};				//SW	
		//mem[5] = {16'b0010000000000000};				//jump
		mem[5] = {16'b0100011000000000};				//bZ
		mem[100] = {13'b0, 3'b001};
		mem[104] = {13'b0, 3'b101};
		mem[108] = {13'b0, 3'b110};
		mem[112] = {13'b0, 3'b000};
		mem[116] = {13'b0, 3'b111};
		mem[120] = {13'b0, 3'b100};
		mem[124] = {13'b0, 3'b010};
		mem[128] = {13'b0, 3'b010};
		mem[132] = {13'b0, 3'b000};
		mem[136] = {13'b0, 3'b011};
		mem[140] = {13'b0, 3'b101};
		mem[144] = {13'b0, 3'b101};
		mem[148] = {13'b0, 3'b011};
		mem[152] = {13'b0, 3'b101};
		mem[156] = {13'b0, 3'b111};
		mem[160] = {13'b0, 3'b101};
		mem[164] = {13'b0, 3'b100};
		mem[168] = {13'b0, 3'b110};
		mem[172] = {13'b0, 3'b000};
		mem[176] = {13'b0, 3'b001};
		*/
		$readmemb("memory1.mem",mem,0);
    end
	//always@ (address , posedge memread) begin 
	//	if(mem_read)
	//		out = mem[address];
	//end
	assign out = mem_read ? mem[address] : 16'bz;
	always @(posedge clk) begin
		if (mem_write)
			mem[address] = write_data;
	end
endmodule