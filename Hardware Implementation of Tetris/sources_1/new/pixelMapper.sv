`timescale 1ns / 1ps
module pixelMapper (
    // This module will take in ref_row and ref_col and output PixelMap of shape
    input logic[4:0] ref_row,
    input logic [3:0]ref_col, 
    input logic firstgen, update, newgen, vsync,
    // shape 
    input logic [3:0] shape[4],
//    input logic line_clear,
//    input logic [4:0] line_cleared,

    // WHOLE PIXEL MAP
    output logic [11:0] row_contents[22],
    output logic [11:0] prev_row_contents[22]
);


    logic [11:0] row_contents_out [22];
    logic [3:0] prev_shape [4];
    logic [4:0] prev_row;
    logic [3:0] prev_col;
    logic [11:0] in_row_contents[22];
    logic [11:0] out_row_contents[22];
    logic [4:0] cleared_line;
    int line;

    
// function void shift_rows_down();
//        int line;
//        for (line = 0; line < cleared_line; line++) begin
//            out_row_contents[line] = in_row_contents[line];
//        end
//        // Erase the cleared line
//        out_row_contents[cleared_line] = 12'b0;
//        // Shift remaining rows down
//        for (line = cleared_line + 1; line < 22; line++) begin
//            out_row_contents[line] = in_row_contents[line - 1];
//        end
//    endfunction

//    int ref_row; 
//    int ref_col; 

    
    always_ff @(posedge vsync)
    begin
//    ref_row = reference_row;
//    ref_col = reference_col;
    //----------------------------------------------------------------------
        // Loop through each row of row_contents and 
        // 1) fill with 100000000001
        // 2) check the position of reference pixel 
        // 3) check shape 
        // 4) print shape around reference pixel
        if(firstgen == 1)
        begin
        for (int i = 0; i <= 21; i++ ) 
        begin
            for (int j = 0; j <= 11; j++) 
                if ((j == 0 || j == 11) || (i==0 || i == 21)) // Set first and last elements to 3
                    row_contents[i][j] = 1;


                else // Set remaining elements to 0
                    row_contents[i][j] = 0;
        
        end
        
          prev_row = ref_row;
          prev_col = ref_col;
          prev_shape = shape;        
            
        for (int i = 0; i <= 3; i++)
        begin
            for (int j = 0; j <= 3 ; j++)
                row_contents[i+ref_row][j+ref_col] = row_contents[i+ref_row][j+ref_col] + shape[i][j];
        end
        end
   //------------------------------------------------------------------------
    // clear previous block
    if(update == 1)
    begin
    if(!newgen)
    begin
   
     for (int i = 0; i <= 3; i++)
        begin
            for (int j = 0; j <= 3 ; j++)
                row_contents[i+prev_row][j+prev_col] = (row_contents[i+prev_row][j+prev_col] ^ prev_shape[i][j]);
                prev_row_contents = row_contents;
        end
     
    end
   
     // add block to pixel map
        for (int i = 0; i <= 3; i++)
        begin
            for (int j = 0; j <= 3 ; j++)
                row_contents[i+ref_row][j+ref_col] = row_contents[i+ref_row][j+ref_col] | shape[i][j];
        end
      end
     //--------------------------------------------------------------------------
    if(update == 1)
    begin
     prev_row = ref_row;
     prev_col = ref_col;
     prev_shape = shape;
    
    end
    
    
    
    
    
    end


endmodule
