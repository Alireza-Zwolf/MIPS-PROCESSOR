module TB();
    /*
    For testing the processor, intsructions.txt Read first 20 numbers of memmory starting from cell 1000,
    then find the maximum number and store the value and index of it in cell 2000 and 2004.
    */
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
