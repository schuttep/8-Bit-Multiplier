`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2024 11:23:02 AM
// Design Name: 
// Module Name: shapes
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


module shapes(
        input logic frame_clk, reset,
        input logic [7:0] keycode,
        input logic [9:0] DrawX, DrawY,
        output logic [9:0] BallXMax, BallXMin, BallYMax,    
        output logic [3:0] Red, Green, Blue
    );
    
    logic stop1, stop2, stop3, stop4;
    logic[9:0] BallX_1, BallX_2, BallX_3, BallX_4, BallY_1, BallY_2, BallY_3, BallY_4;
    logic[9:0] BallS;
    
    ball line1(
        .frame_clk (frame_clk),
        .Reset (reset),
        .keycode (keycode),
        .stop (stop),
        .BallX (BallX_1),
        .BallY (BallY_1),
        .BallS (BallS)
    );
    
     ball line2(
        .frame_clk (frame_clk),
        .Reset (reset),
        .keycode (keycode),
        .stop (stop),
        .BallX (BallX_2),
        .BallY (BallY_2),
        .BallS (BallS)
    );
    
     ball line3(
        .frame_clk (frame_clk),
        .Reset (reset),
        .keycode (keycode),
        .stop (stop),
        .BallX (BallX_3),
        .BallY (BallY_3),
        .BallS (BallS)
    );
    
     ball line4(
        .frame_clk (frame_clk),
        .Reset (reset),
        .keycode (keycode),
        .stop (stop),
        .BallX (BallX_4),
        .BallY (BallY_4),
        .BallS (BallS)
    );
    
    color_mapper ( 
        .BallX (BallX_1),
        .BallX1 (BallX_2),
        .BallX2 (BallX_3),
        .BallX3 (BallX_4),
        .BallY (BallY_1),
        .BallY1 (BallY_2),
        .BallY2 (BallY_3),
        .BallY3 (BallY_4),
        .DrawX (DrawX),
        .DrawY (DrawY),
        .Ball_size (BallS),
        .Red (Red),
        .Blue (Blue),
        .Green (Green)
    );
        
endmodule
