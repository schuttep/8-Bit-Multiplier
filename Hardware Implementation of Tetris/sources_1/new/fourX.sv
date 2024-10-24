module fourX(
        input logic[9:0] row,
        output logic[9:0][239:0][3:0] mega_pix
        
    );
   
   logic [4:0][11:0] mini_pix;
   logic [239:0] full_scale;
   logic [5:0] row_finder;
   
   always_comb
    begin
        if (row < 20)
            row_finder = 0;
        else if ( row >= 20 && row < 40)
            row_finder = 1;
        else if ( row >= 40 && row < 60)
            row_finder = 2;
        else if ( row >= 60 && row < 80)
            row_finder = 3;
        else if ( row >= 80 && row < 100)
            row_finder = 4;
        else if ( row >= 100 && row < 120)
            row_finder = 5;
       else if ( row >= 120 && row < 140)
            row_finder = 6;
       else if ( row >= 140 && row < 160)
            row_finder = 7;
       else if ( row >= 160 && row < 180)
            row_finder = 8;
       else if ( row >= 180 && row < 200)
            row_finder = 9;
       else if ( row >= 200 && row < 220)
            row_finder = 10;
       else if ( row >= 220 && row < 240)
            row_finder = 11;
       else if ( row >= 240 && row < 260)
            row_finder = 12;
       else if ( row >= 260 && row < 280)
            row_finder = 13;
       else if ( row >= 280 && row < 300)
            row_finder = 14;
       else if ( row >= 300 && row < 320)
            row_finder = 15;
       else if ( row >= 320 && row < 340)
            row_finder = 16;
       else if ( row >= 340 && row < 360)
            row_finder = 17;
       else if ( row >= 360 && row < 380)
            row_finder = 18;
       else if ( row >= 380 && row < 400)
            row_finder = 19;
       else if ( row >= 400 && row < 420)
            row_finder = 20;
       else if ( row >= 420 && row < 440)
            row_finder = 21;
           
    end
    
    initial begin
        pixelmapper called(.row (row_finder), .pixels (mini_pix));
        for(int i = 0; i < 12; i++) begin
            for(int j = 0; j < 20; j++)begin
                mega_pix[row][(i * 20) + j] <= mini_pix[i];
            end
        end
    end
    
endmodule
