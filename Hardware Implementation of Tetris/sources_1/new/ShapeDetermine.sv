module ShapeDetermine(
    input logic vsync,
//    input logic [2:0] random,  // Random number to determine initial shape
    input logic firstgen, newgen, update,      // Indicates if it's the first shape generation
    input  logic [7:0]  keycode,
    input logic [4:0]row_in,
    input logic [3:0] col_in,
    input logic [11:0] prev_row_contents [22],
    input logic [3:0] base_shape [4],
    
    output logic [3:0] shape[4]  // Output shape
);

    logic [2:0] shape_state;
    logic  rotate;
    logic lift_key;
    logic [3:0] grid [4];    
    logic [2:0] random;
    int newgen_counter;

    
    logic [3:0] block_i_0[4];
    logic [3:0] block_i_1 [4];
    logic [3:0] block_z_0[4];
    logic [3:0] block_z_1 [4];
    logic [3:0] block_s_0[4];
    logic [3:0] block_s_1 [4];
    logic [3:0] block_t_0[4];
    logic [3:0] block_t_1 [4];
    logic [3:0] block_t_2[4];
    logic [3:0] block_t_3 [4];
    logic [3:0] block_l_0[4];
    logic [3:0] block_l_1 [4];
    logic [3:0] block_l_2[4];
    logic [3:0] block_l_3 [4];
    logic [3:0] block_j_0[4];
    logic [3:0] block_j_1 [4];
    logic [3:0] block_j_2[4];
    logic [3:0] block_j_3 [4];
    logic [3:0] block_sq[4];
    
    Block_Sprite sprite(
        .I_0 (block_i_0),
        .I_1 (block_i_1),
        .T_0 (block_t_0),
        .T_1 (block_t_1),
        .T_2 (block_t_2),
        .T_3 (block_t_3),
        .Z_0 (block_z_0),
        .Z_1 (block_z_1),
        .S_0 (block_s_0),
        .S_1 (block_s_1),
        .J_0 (block_j_0),
        .J_1 (block_j_1),
        .J_2 (block_j_2),
        .J_3 (block_j_3),
        .L_0 (block_l_0),
        .L_1 (block_l_1),
        .L_2 (block_l_2),
        .L_3 (block_l_3),
        .square (block_sq)
        
    );
    
        logic [2:0] lfsr_state;

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
    

    
    
always_ff @(posedge vsync)   begin
       newgen_counter = newgen_counter + 6'b1;
        
        if(newgen_counter > 32'd5)
        begin
            random = 3'b001;
        end
        if(newgen_counter > 32'd15)
        begin
            random = 3'b010;
        end
        if(newgen_counter > 20)
        begin
            random = 3'b011;
        end
        if(newgen_counter > 23)
        begin
            random = 3'b100;
        end
        if(newgen_counter > 30)
        begin
            random = 3'b101;
        end
        if(newgen_counter > 39)
        begin
            random = 3'b110;
        end
        if(newgen_counter > 45)
        begin
            random = 3'b111;
            newgen_counter = 6'b0;
        end
        else
        begin
        random = 3'b001;
        end
        
        
        
        
    if (firstgen || newgen) begin
            
                
            shape_state = 3'b001;
//            case (random) // Assuming 7 shapes
//                3'b001: shape = block_i_0;
//                3'b010: shape = block_s_0;
//                3'b011: shape = block_z_0;
//                3'b100: shape = block_t_0;
//                3'b101: shape = block_j_0;
//                3'b110: shape = block_l_0;
//                3'b111: shape = block_sq;
//                default: shape = block_i_0; // Default to square shape
//            endcase
            if(newgen_counter < 32'd5)
            begin
            shape = block_i_0;
            end
            else if(newgen_counter < 32'd15)
            begin
            shape = block_s_0;
            end
            else if(newgen_counter < 32'd20)
            begin
            shape = block_z_0;
            end
            else if(newgen_counter < 32'd27)
            begin
            shape = block_t_0;
            end
            else if(newgen_counter < 32'd33)
            begin
            shape = block_j_0;
            end
            else if(newgen_counter < 32'd38)
            begin
            shape = block_l_0;
            end
            else if(newgen_counter < 32'd45)
            begin
            shape = block_sq;
            end
            else
            begin
            shape = block_j_0;
            end
            
        end



        if (keycode == 8'h1A && update)
         begin
         for(int i = 0; i < 4; i++)
            begin
                for(int j = 0; j < 4; j++)
                begin
                 grid[i][j+1] = prev_row_contents[row_in + i][col_in + j];
                end
            end
         if(!(check_collision()))
         begin
         lift_key = 1;
         end
         else
         begin
         lift_key = 0;
         end
         end
         else
            lift_key = 0;

        if (lift_key == 1) 
            begin
                shape_state = shape_state + 3'b001;
                if(shape_state == 3'b101)
                    shape_state = 3'b001;
            if(shape == block_i_0 || shape == block_i_1)
                begin
                case (shape_state) // Assuming 7 shapes
                3'b001: shape = block_i_0;
                3'b010:  shape = block_i_1;
                3'b011:  shape = block_i_0;
                3'b100:  shape = block_i_1;
                default: shape = block_i_0;
            endcase
            end
            if(shape == block_sq)
                begin
                shape = block_sq;
            end
            if(shape == block_t_0 || shape == block_t_1 || shape == block_t_2 || shape == block_t_3)
                begin
                case (shape_state) // Assuming 7 shapes
                3'b001: shape = block_t_0;
                3'b010:  shape = block_t_1;
                3'b011:  shape = block_t_2;
                3'b100:  shape = block_t_3;
                default: shape = block_t_0;
            endcase
            end
            if(shape == block_l_0 || shape == block_l_1 || shape == block_l_2 || shape == block_l_3)
                begin
                case (shape_state) // Assuming 7 shapes
                3'b001: shape = block_l_0;
                3'b010:  shape = block_l_1;
                3'b011:  shape = block_l_2;
                3'b100:  shape = block_l_3;
                default: shape = block_l_0;
            endcase
            end
            if(shape == block_j_0 || shape == block_j_1 || shape == block_j_2 || shape == block_j_3)
                begin
                case (shape_state) // Assuming 7 shapes
                3'b001: shape = block_j_0;
                3'b010:  shape = block_j_1;
                3'b011:  shape = block_j_2;
                3'b100:  shape = block_j_3;
                default: shape = block_j_0;
            endcase
            end
            if(shape == block_s_0 || shape == block_s_1 )
                begin
                case (shape_state) // Assuming 7 shapes
                3'b001: shape = block_s_0;
                3'b010:  shape = block_s_1;
                3'b011:  shape = block_s_0;
                3'b100:  shape = block_s_1;
                default: shape = block_s_0;
            endcase
            end
            if(shape == block_z_0 || shape == block_z_1 )
                begin
                case (shape_state) // Assuming 7 shapes
                3'b001: shape = block_z_0;
                3'b010:  shape = block_z_1;
                3'b011:  shape = block_z_0;
                3'b101:  shape = block_z_1;
                default: shape = block_z_0;
            endcase
            end
           end
           else
           begin
            shape_state = shape_state;
            shape = shape;
            end
        end
 
endmodule
