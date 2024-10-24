//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf     03-01-2006                           --
//                                  03-12-2007                           --
//    Translated by Joe Meng        07-07-2013                           --
//    Modified by Zuofu Cheng       08-19-2023                           --
//    Modified by Satvik Yellanki   12-17-2023                           --
//    Fall 2024 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI Lab                                --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball 
( 
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,

    output logic stop,
    output logic [9:0]  BallX, 
    output logic [9:0]  BallY, 
    output logic [9:0]  BallS
);
    

	 
    parameter [9:0] Ball_X_Center=200;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=80;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=100;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=300;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=460;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    logic [9:0] Ball_X_Motion;
    logic [9:0] Ball_X_Motion_next;
    logic [9:0] Ball_Y_Motion;
    logic [9:0] Ball_Y_Motion_next;
    reg [5:0] counter;

    logic [9:0] Ball_X_next;
    logic [9:0] Ball_Y_next;
    
    logic legalX, legalY;
        
    always_comb begin
   
        Ball_Y_Motion_next = 10'd1; // set default motion to be same as prev clock cycle 
        Ball_X_Motion_next = 0;

        //modify to control ball motion with the keycodez
        //1A will control rotation write in the color mapper
        if (keycode == 8'h1A)
            begin         
            Ball_Y_Motion_next = -10'd50;
            Ball_X_Motion_next = 0;
            end
         if (keycode == 8'h04 && !(counter % 20))
         begin
            Ball_X_Motion_next = -10'd20;
            Ball_Y_Motion_next = 10'd5;
            end
         if (keycode == 8'h07 && !(counter % 20))
         begin
            Ball_X_Motion_next = 10'd20;
            Ball_Y_Motion_next = 10'd5;
            end
            if (keycode == 8'h16)
         begin
            Ball_X_Motion_next = 0;
            Ball_Y_Motion_next = 10'd1;
            end
         


        if ( (BallY + BallS) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
        begin
            Ball_Y_Motion_next = 0;  // set to -1 via 2's complement.]
            Ball_X_Motion_next = 0;
        end
        else if ( (BallX + BallS) >= Ball_X_Max )  
        begin
					      if( keycode == 8'h04 && (BallY + BallS) <= Ball_Y_Max && !(counter % 30))
         begin
            Ball_X_Motion_next = 10'd1;
            Ball_Y_Motion_next = 0;
            end
            else
                       Ball_X_Motion_next = 0;
					  end
		
		
       //fill in the rest of the motion equations here to bounce left and right
  
    end

//         //checks boundries
//        legal_move checkmove(
//            .BallX (BallX),
//            .BallY (BallY),
//            .BallS (BallS),
//            .Ymax (Ball_Y_Max),
//            .Xmax (Ball_X_Max),
//            .Xmin (Ball_X_Min),
//            .legalX (legalX),
//            .legalY (legalY)
//        );


//    always_comb
//        begin
//          if(legalX == 0)
//             Ball_X_Motion_next = 0;
         
//          if(legalY == 0)
//             Ball_Y_Motion_next = 0;
//        end

    assign BallS = 10;  // default ball size
    assign Ball_X_next = (BallX + Ball_X_Motion_next);
    assign Ball_Y_next = (BallY + Ball_Y_Motion_next);
    assign stop = legalX + legalY;
   
    always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    begin: Move_Ball
        if (Reset)
        begin 
            Ball_Y_Motion <= 10'd1; //Ball_Y_Step;
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
            
			BallY <= Ball_Y_Center;
			BallX <= Ball_X_Center;
			
			counter <= 5'b0;
        end
        else if(keycode == 8'h19)
            begin
                BallY <= Ball_Y_Center;
			     BallX <= Ball_X_Center;
			     
			     counter <= 5'b0;
            end
        else
        begin 

			Ball_Y_Motion <= Ball_Y_Motion_next; 
			Ball_X_Motion <= Ball_X_Motion_next; 

            BallY <= Ball_Y_next;  // Update ball position
            BallX <= Ball_X_next;
			
			if(counter == 5'd30)
			 counter <= 0;
		    else
			 counter <= counter + 5'b1;
		end 
    end


    
      
endmodule
