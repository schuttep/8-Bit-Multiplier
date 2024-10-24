module reg_file(
        input logic ld_reg, clk, reset,
        input logic[15:0] bus, ir,
        input logic[2:0] drout, sr1in,
        output logic[15:0] sr1out, sr2out 
    );
    
    logic [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
    
    
    logic [2:0] sr2;
    assign sr2 = ir[2:0];
    
    always_ff @ (posedge clk)
    begin
        if(reset)
            begin
            r0 <= 16'h0000;
            r1 <= 16'h0000;
            r2 <= 16'h0000;
            r3 <= 16'h0000;
            r4 <= 16'h0000;
            r5 <= 16'h0000;
            r6 <= 16'h0000;
            r7 <= 16'h0000;
            end
         else if(ld_reg)
            begin
                unique case(drout)
                    3'b000 : r0[15:0] <= bus;
                    3'b001 : r1[15:0] <= bus;
                    3'b010 : r2[15:0] <= bus;
                    3'b011 : r3[15:0] <= bus;
                    3'b100 : r4[15:0] <= bus;
                    3'b101 : r5[15:0] <= bus;
                    3'b110 : r6[15:0] <= bus;
                    3'b111 : r7[15:0] <= bus;
                endcase
            end
    end
    always_comb
        begin
           unique case(sr1in)
                    3'b000 : sr1out = r0[15:0];
                    3'b001 : sr1out = r1[15:0];
                    3'b010 : sr1out = r2[15:0];
                    3'b011 : sr1out = r3[15:0];
                    3'b100 : sr1out = r4[15:0];
                    3'b101 : sr1out = r5[15:0];
                    3'b110 : sr1out = r6[15:0];
                    3'b111 : sr1out = r7[15:0];    
                    default: sr1out = 4'hx;             
          endcase
          case(sr2)
                    3'b000 : sr2out = r0[15:0];
                    3'b001 : sr2out = r1[15:0];
                    3'b010 : sr2out = r2[15:0];
                    3'b011 : sr2out = r3[15:0];
                    3'b100 : sr2out = r4[15:0];
                    3'b101 : sr2out = r5[15:0];
                    3'b110 : sr2out = r6[15:0];
                    3'b111 : sr2out = r7[15:0];    
                    default: sr2out = 4'hx;             
          endcase
       end
endmodule
