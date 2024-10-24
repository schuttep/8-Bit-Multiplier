//4-bit logic processor top level module
//for use with ECE 385 Fall 2023
//last modified by Satvik Yellanki


//Always use input/output logic types when possible, prevents issues with tools that have strict type enforcement

module Processor (
	input  logic        Clk,     // Internal
	input  logic        Reset,   // Push button 0
	input  logic        Execute, // Push button 3
	input  logic [7:0]  Din,       

	output logic Xval,     
	output logic [7:0]  Aval,    // DEBUG
	output logic [7:0]  Bval,    // DEBUG
	output logic [7:0]  hex_seg, // Hex display control
	output logic [3:0]  hex_grid // Hex display control
); 

    //local logic variables go here
	logic Reset_SH;
	logic Execute_SH;
	logic[7:0] d_in_SH;
	logic[6:0] c;
	logic[7:0] c1, c3;
	logic[8:0] c2;
	 
//We can use the "assign" statement to do simple combinational logic
//	assign Aval = A;
//	assign Bval = B;

//Instantiation of modules here


	reg_m mult (
		.Clk        (Clk),
		.Reset      (c[2]),

		.Ld_B       (c[4]||c[5]),
		.Shift_En   (c[3]),
		.D          (c2[8]),
		.A_In       (Xval),
		
		.shift_out  (c[0]),
		.d_out      (Xval)
	);
                 
 register_unit reg_a (
		.Clk        (Clk),
		.Reset      (c[2]),

		.Ld_B       (c[4]||c[5]),
		.Shift_En   (c[3]),
		.D          (c2[7:0]),
		.A_In       (c[0]),
		
		.shift_out  (c[1]),
		.d_out      (Aval)
	);                  
	 
register_unit reg_b (
		.Clk        (Clk),
		.Reset      (1'b0),

		.Ld_B       (c[6]),
		.Shift_En   (c[3]),
		.D          (Din[7:0]),
		.A_In       (c[1]),
		
		.shift_out  (),
		.d_out      (Bval)
	);                     
	
nine_adder add(
    .A      (Aval[7:0]),
    .sw     (Din[7:0]),
    .sub    (c[5]),
    .s      (c2[8:0]),
    .cout   ()
);

control control(
	 .Clk              (Clk), 
	 .Reset            (Reset),
	 .Execute          (Execute),
	 .cleara_loadb     (Reset),
	 .mult            (Bval[0]),

	 .Shift_En         (c[3]), 
	 .add              (c[4]),
	 .loadb            (c[6]),
	 .cleara           (c[2]),
	 .sub              (c[5]) 

);
//When you extend to 8-bits, you will need more HEX drivers to view upper nibble of registers, for now set to 0
	HexDriver HexA (
		.clk        (Clk),
		.reset      (Reset_SH),

		.in         ({Aval[7:4], Aval[3:0], Bval[7:4], Bval[3:0]}),
		.hex_seg    (hex_seg),
		.hex_grid   (hex_grid)
	);
                            
//Input synchronizers required for asynchronous inputs (in this case, from the switches)
//These are array module instantiations
//Note: S stands for SYNCHRONIZED, H stands for active HIGH, in addition in synthesis they are also debounced

	  
endmodule
