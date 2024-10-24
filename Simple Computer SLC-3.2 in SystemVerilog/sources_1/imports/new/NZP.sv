`timescale 1ns / 1ps


module NZP(
        input   ld_cc, clk, reset,
        input [15:0] bus,
        output N,Z,P
         );
  logic n,z,p;
  always_comb begin
                n = 1'b0;
                z = 1'b0;
                p = 1'b0;
        if(bus == 16'h0000)
            begin
                n = 1'b0;
                z = 1'b1;
                p = 1'b0;
            end
          else if(bus[15] == 1'b1)
            begin
                n = 1'b1;
                z = 1'b0;
                p = 1'b0;
            end
          else if(bus[15] == 1'b0)
            begin
                n = 1'b0;
                z = 1'b0;
                p = 1'b1;
            end
            else begin
                n = 1'b0;
                z = 1'b0;
                p = 1'b0;
            end
    end
 load_reg #(.DATA_WIDTH(1)) N_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_cc),
    .data_i(n),

    .data_q(N)
);
 load_reg #(.DATA_WIDTH(1)) Z_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_cc),
    .data_i(z),

    .data_q(Z)
);
 load_reg #(.DATA_WIDTH(1)) P_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_cc),
    .data_i(p),

    .data_q(P)
);
         
endmodule
