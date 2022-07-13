module Controller(input clk , rst , zero , input [3:0] opcode , input [8:0] func, output reg IorD , LRwrite , RegDst
                 , RegWrite , pcwrite , pcwritecond , MemRead , MemWrite ,
                  output reg [1:0] AluSrcA , AluSrcB , PCSrc, RegDataSel , output reg [2:0] ALUop);
    reg[4:0] ps , ns;
    parameter [4:0] Fetch_Ins = 0 , Ins_Decode = 1 , LoadW = 2 , StoreW = 3 , Jump = 4 , BranchZ = 5 , Ctype = 6 , Nop = 7
                    , Addi = 8 , Subi = 9 , Andi = 10 , Ori = 11 , Execution = 12 , LoadW_completion = 13 , MoveTO = 14
                    , MoveFrom = 15, Add = 16 , Sub = 17 , And = 18 , Or = 19 , Not = 20;

                    
    always @(zero , opcode , posedge clk) begin
        case(ps)
            Fetch_Ins:
                ns = Ins_Decode;
            Ins_Decode:
                case(opcode)
                    4'b0000:
                        ns = LoadW;
                    4'b0001:
                        ns = StoreW;
                    4'b0010:
                        ns = Jump;
                    4'b0100:
                        ns = BranchZ; 
                    4'b1000:
                        ns = Ctype;
                    4'b1100:
                        ns = Addi;
                    4'b1101:
                        ns = Subi;
                    4'b1110:
                        ns = Andi;
                    4'b1111:
                        ns = Ori;
                endcase
            Ctype: begin
                case(func)
                    9'b000000001:
                        ns = MoveTO;
                    9'b000000010:
                        ns = MoveFrom;
                    9'b000000100:
                        ns = Add;
                    9'b000001000:
                        ns = Sub;
                    9'b000010000:
                        ns = And;
                    9'b000100000:
                        ns = Or;
                    9'b001000000:
                        ns = Not;
                    9'b010000000:
                        ns = Nop;
                endcase
            end
            Add:
                ns = Execution;
            And:
                ns = Execution;
            Sub:
                ns = Execution;
            Or:
                ns = Execution;
            Not:
                ns = Execution;
            Addi:
                ns = Execution;
            Andi:
                ns = Execution;
            Subi:
                ns = Execution;
            Ori:
                ns = Execution;
            Execution:
                ns = Fetch_Ins;
            LoadW:
                ns = LoadW_completion;
            LoadW_completion:
                ns = Fetch_Ins;
            default:
                ns = Fetch_Ins;
        endcase
    end
    
    always@(ps)begin
        {IorD , LRwrite , RegDst , RegDataSel , RegWrite , MemRead , MemWrite , AluSrcA , AluSrcB , AluSrcA , AluSrcB , pcwrite , pcwritecond , ALUop} = 16'b0;
        case(ps)
            Fetch_Ins: begin pcwrite = 1 ; LRwrite = 1 ; MemRead = 1 ; IorD = 0 ; PCSrc = 2'b00 ; AluSrcA = 1 ; AluSrcB = 2'b10 ; ALUop = 3'b0; end
            Ins_Decode: begin AluSrcA = 1 ; AluSrcB = 2'b01 ; ALUop = 3'b0; end
            Addi: begin ALUop = 3'b000; AluSrcB = 2'b01; AluSrcA = 1'b0 ; end
            Ori: begin ALUop = 3'b011; AluSrcB = 2'b01; AluSrcA = 1'b0 ; end
            Subi: begin ALUop = 3'b001; AluSrcB = 2'b01; AluSrcA = 1'b0 ; end
            Andi: begin ALUop = 3'b010; AluSrcB = 2'b01; AluSrcA = 1'b0 ; end
            Jump: begin PCSrc = 2'b10; pcwrite = 1'b1; end
            BranchZ: begin PCSrc = 2'b11; pcwrite = 1'b0; AluSrcA = 1'b0; AluSrcB = 2'b0; ALUop = 3'b001; pcwritecond = 1'b1; end
            //Ctype:begin AluSrcA = 1'b0; AluSrcB = 2'b00; ALUop =   end
            MoveFrom: begin RegDst = 0; RegWrite = 1; RegDataSel = 2'b10; end
            MoveTO: begin RegDst = 1; RegWrite = 1; RegDataSel = 2'b01; end
            Nop: begin MemWrite = 0; RegWrite = 0; end
            Add: begin ALUop = 3'b000; AluSrcB = 2'b0; AluSrcA = 1'b0; end
            Sub: begin ALUop = 3'b001; AluSrcB = 2'b0; AluSrcA = 1'b0; end
            And: begin ALUop = 3'b010; AluSrcB = 2'b0; AluSrcA = 1'b0; end
            Not: begin ALUop = 3'b101; AluSrcB = 2'b0; AluSrcA = 1'b0; end
            LoadW: begin IorD = 1; MemRead = 1;end
            LoadW_completion: begin RegDst = 0; RegWrite = 1; RegDataSel = 2'b11; end
            StoreW: begin IorD = 1; MemWrite = 1; end
            Execution: begin RegDst = 0; RegWrite = 1; RegDataSel = 2'b00; end
        endcase
    end

    always@(posedge clk)begin
            ps <= ns;
    end

endmodule