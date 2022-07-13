module TB();
    reg clk = 0;
    reg rst = 0;

    MIPS mips(clk , rst);
    always #20 clk = ~clk;
    initial begin
        #5 rst = 1;
        #10 rst = 0;
        #15;
        rst = 0;
        #200000;
        $finish;
    end
endmodule