module color_mapper (
    input logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
    input logic [11:0] row_contents[22], 
    output logic [3:0] Red, Green, Blue

);


    always_comb
    begin
    // iterate through all rows
    for (int i = 0; i <= 21; i++)
        begin
         if ( (DrawY/20) <=  (i + 1) && (DrawY/20) >= i  )
            begin

           // iterate tgrough all 12 columns if in 20 pixel range
            for(int j = 0; j <= 11; j++)
            begin
        // Multiply by 20
                if ((DrawX/20) <= j+1 && (DrawX/20) >= j)
            begin
                if(row_contents[i][j] == 1 ) 
                begin
                // Black border
                    Red = 4'h0;
                    Green = 4'h0;
                    Blue = 4'h0; 
                end 
 

                if (row_contents[i][j] == 0) 
                begin
                // White content fff
                    Red = 4'hf;
                    Green = 4'hf;
                    Blue = 4'hf; 
                end
        end
        end
        end
        end
     
     end




   endmodule