module gameLogic(
        input logic [11:0] prev_row_contents[22],
        input logic clk,
        input logic [3:0] shape[4],
        input  logic [7:0]  keycode,
        output logic [4:0]row_out,
        output logic [3:0] col_out,
        output logic update,
        output logic firstgen,
        output logic newgen
    );
    
    logic[3:0] grid[4];
    logic [4:0] row_temp;
    logic [3:0] col_temp;
    
 // Function to check if the sprite can be placed at a specific position
  function bit check_collision();
    int row, col;
    
    // Iterate over each row of the sprite
    for (row = 0; row < 4; row++) begin
      // Iterate over each column of the sprite
      for (col = 0; col < 4; col++) begin
        // Check if the corresponding cell in the grid is already occupied
        if (shape[row][col] && grid[row][col]) begin
          // Collision detected
          return 1; // Collision detected
        end
      end
    end
    
    // No collision detected
    return 0;
  endfunction
    
  // Register to store previous pixel map
    logic [11:0] pixel_map_reg[22];
    //reg [6:0] 
    int counter;
    //reg [5:0] 
    int counter2;
    always_ff @(posedge clk) begin
        // Shift pixels downwards within each column
        counter = counter + 6'b1;
        
        if(counter2 > 30 )
        begin
            firstgen = 0;
        end
        else
        begin
            firstgen = 1;
            counter2 <= counter2 + 1'b1;
            row_temp = 5'd1;
            col_temp = 4'd5;
        end
        
        if(!(counter % 60))
        begin
            update = 1'b1;
            counter = 0;
        end
        else
            update = 1'b0;
            

    if(update)
    begin      
    
         if ((keycode == 8'h07))
         begin
         for(int i = 0; i < 4; i++)
            begin
                for(int j = 1; j < 5; j++)
                begin
                 grid[i][j-1] = prev_row_contents[row_temp + i][col_temp + j];
                end
            end
         if(!(check_collision()))
         begin
         row_temp = row_temp;
         col_temp = col_temp + 4'd1;
         newgen = 0;
         end
         else
         begin
         row_temp = row_temp;
         col_temp = col_temp;
         end
         end
         
         
         if ((keycode == 8'h04))
         begin
         for(int i = 0; i < 4; i++)
            begin
                for(int j = -1; j < 3; j++)
                begin
                 grid[i][j+1] = prev_row_contents[row_temp + i][col_temp + j];
                end
            end
         if(!(check_collision()))
         begin
         row_temp = row_temp;
         col_temp = col_temp - 4'd1;
         newgen = 0;
         end
         else
         begin
         row_temp = row_temp;
         col_temp = col_temp;
         end
         end
    
    
       
         else if (!(row_temp + 1 > 20))
         begin
         for(int i = 1; i < 5; i++)
            begin
                for(int j = 0; j < 4; j++)
                begin
                 grid[i - 1][j] = prev_row_contents[row_temp + i][col_temp +j];
                end
            end
         if(!(check_collision()))
         begin
         row_temp = row_temp + 5'd1;
         col_temp = col_temp;
         newgen = 0;
         end
         else
         begin
         if(row_temp == 5'd1)
         begin 
         firstgen = 1;
         row_temp = 5'd1;
         col_temp = 4'd5;
         end
         else
         begin
         newgen = 1;
         row_temp = 5'd1;
         col_temp = 4'd5;
         end
         end
         end
         else if(row_temp + 1 > 20)
         begin
            newgen = 1;
            row_temp = 5'd1;
            col_temp = 4'd5;
         end
       
    
    
    
         else
         begin
            row_temp = row_temp;
            col_temp = col_temp;
            
         end
    end
    end
    assign row_out = row_temp;
    assign col_out = col_temp;
endmodule

