`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2024 08:00:36 PM
// Design Name: 
// Module Name: addr_test
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


module addr_test();

timeunit 10ns;
timeprecision 1ns;

logic  [15:0] a;
logic  [15:0] b;
logic         cin;
logic  [15:0] s;
logic         cout;
logic Clk;

adder4 la_adder(.*);

always begin : CLOCK_GENERATION;
    #1 Clk =~Clk;
end


initial begin: CLOCK_INITIALIZATION;
    Clk=0;
end

 initial begin: TEST
    a = 16'd1;
    b = 16'd0;
    cin = 16'd1;
end

endmodule
