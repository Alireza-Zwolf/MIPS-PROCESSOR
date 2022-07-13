module TB();
    reg clk = 0;
    reg rst = 0;

    MIPS mips(clk , rst);
    always #100 clk = ~clk;
    initial begin
        #20 rst = 1;
        #150;
        rst = 0;
        #30000;
        $finish;
    end
endmodule