module ben(
    input logic [15:0] bus,
    input logic ld_cc, ld_ben, clk, reset,
    input logic [2:0] ir,
    output logic ben
    );
    
logic n, z, p, n_out, z_out, p_out;
always_ff @ (posedge clk)
    begin
        if(reset) begin
         ben <= 1'b0;
         {n_out, z_out, p_out} <= 3'b000;
        end else begin
         if (ld_ben) begin
            ben <= ((ir & {n_out, z_out, p_out}) !=3'b000);
         end
         if(ld_cc)
            begin
                n_out <= n;
                p_out <= p;
                z_out <= z;
            end
        end
    end
    
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
endmodule
