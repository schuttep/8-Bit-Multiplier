module register_unit (
	input  logic        Clk, 
	input  logic        Reset,
	input  logic        A_In,
	input  logic        Ld_B, 
	input  logic        Shift_En,
	input  logic [7:0]  D, 

	output logic        shift_out, 
	output logic [7:0]  d_out
);

logic [7:0] next;
    
always_ff @ (posedge Clk)
    begin
        d_out = next;
    end
always_comb
    begin
        next = d_out;
        if(Reset)
            next = 0;
        else if(Ld_B)
            next = D;
        else if (Shift_En)
            next = {A_In, d_out[7:1]};
     end
     assign shift_out = d_out[0];
     


endmodule

module reg_m (
	input  logic        Clk, 
	input  logic        Reset,
	input  logic        A_In,
	input  logic        Ld_B, 
	input  logic        Shift_En,
	input  logic        D, 

	output logic        shift_out, 
	output logic        d_out
);
    
logic next;

always_ff @ (posedge Clk)
    begin
        d_out = next;
    end
always_comb
    begin
        next = d_out;
        if(Reset)
            next = 0;
        else if(Ld_B)
            next = D;
        else if (Shift_En)
            next = A_In;
     end
     assign shift_out = d_out;

endmodule 