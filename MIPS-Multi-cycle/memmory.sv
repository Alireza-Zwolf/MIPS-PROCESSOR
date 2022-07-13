
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
		$readmemb("memory1.mem",mem,0);
    end
	assign out = mem_read ? mem[address] : 16'bz;
	always @(posedge clk) begin
		if (mem_write)
			mem[address] = write_data;
	end
endmodule
