`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2024 06:22:07 PM
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench();

timeunit   10ns;
timeprecision 1ns;

logic[7:0] hex_seg;
logic[3:0] hex_grid;
logic Reset;
logic Execute;
logic [7:0] Din;
logic Clk;
logic [7:0] Aval;
logic [7:0] Bval;
logic Xval;

Processor mult(.*);

always begin : CLOCK_GENERATION;
    #1 Clk =~Clk;
 end
 
 initial begin: CLOCK_INITIALIZATION;
    Clk=0;
end;

initial begin: TEST
    Reset = 1;
    Execute = 0;
#10    Din = 8'd4;
#10    Reset = 0;
#10    Din = 8'd5;
#10    Execute = 1;
#10     Execute = 0;
end
endmodule
