`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2024 10:55:09 AM
// Design Name: 
// Module Name: legal_move
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


module legal_move(
        input logic [9:0]  BallX, 
        input logic [9:0]  BallY, 
        input logic [9:0]  BallS,
        input logic [9:0]  Ymax, 
        input logic [9:0]  Xmin, 
        input logic [9:0]  Xmax,
        output logic legalX, legalY
    );
    //checks boundries
    always_comb
        begin
            if ( (BallY + BallS) >= Ymax )  // Ball is at the bottom edge, BOUNCE!
        begin
            legalY = 0;
            legalX = 0;
        end
        else if ( (BallX + BallS) >= Xmax )  
        begin
            legalX = 0;
            legalY = 1;
        end
	    else if ( (BallX - BallS) <= Xmin )  
	    begin	
	        legalX = 0;
	        legalY = 1;
                    
		 end
		 else
		    legalX = 1;
		    legalY = 1;
            
        end
    
    
    
endmodule
