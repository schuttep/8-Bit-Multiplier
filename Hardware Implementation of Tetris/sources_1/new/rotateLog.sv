module rotateLog(
    input logic vsync,
    input logic [2:0] random,  // Random number to determine initial shape
    input logic firstgen, newgen, update,      // Indicates if it's the first shape generation
    input  logic [7:0]  keycode,
    output logic [3:0] shape[4]  // Output shape
);

    logic [2:0] shape_state;
    logic  rotate;
    logic lift_key;
    logic rotate_trigger;
    logic [2:0] shape_state;
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
always_comb  begin     
     if (keycode == 8'h1A)
            begin
            rotate = 1;
            lift_key = 0;
            end
        else if(rotate == 1)
            begin
                rotate = 0;
                lift_key = 1;
            end
        else
            begin
            rotate = 0;
            lift_key = 0;
            end
        if (firstgen || newgen) begin
            // Determine initial shape based on random number
            shape_state = 3'b001;
            case (random) // Assuming 7 shapes
                3'b001: shape = block_i_0;
                3'b010: shape = block_s_0;
                3'b100: shape = block_z_0;
                3'b011: shape = block_t_0;
                3'b111: shape = block_j_0;
                3'b101: shape = block_l_0;
                3'b110: shape = block_sq;
                default: shape = block_i_0; // Default to square shape
            endcase
            
        end
            else if (lift_key == 1) 
            begin
                shape_state = shape_state + 3'b001;
                if(shape_state == 3'b110)
                    shape_state = 3'b001;
            if(shape == block_i_0 || shape == block_i_1)
                begin
                case (shape_state) // Assuming 7 shapes
                3'b001: shape = block_i_0;
                3'b011:  shape = block_i_1;
                3'b100:  shape = block_i_0;
                3'b101:  shape = block_i_1;
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
                3'b011:  shape = block_t_1;
                3'b100:  shape = block_t_2;
                3'b101:  shape = block_t_3;
                default: shape = block_t_0;
            endcase
            end
            if(shape == block_l_0 || shape == block_l_1 || shape == block_l_2 || shape == block_l_3)
                begin
                case (shape_state) // Assuming 7 shapes
                3'b001: shape = block_l_0;
                3'b011:  shape = block_l_1;
                3'b100:  shape = block_l_2;
                3'b101:  shape = block_l_3;
                default: shape = block_l_0;
            endcase
            end
            if(shape == block_j_0 || shape == block_j_1 || shape == block_j_2 || shape == block_j_3)
                begin
                case (shape_state) // Assuming 7 shapes
                3'b001: shape = block_j_0;
                3'b011:  shape = block_j_1;
                3'b100:  shape = block_j_2;
                3'b101:  shape = block_j_3;
                default: shape = block_j_0;
            endcase
            end
            if(shape == block_s_0 || shape == block_s_1 )
                begin
                case (shape_state) // Assuming 7 shapes
                3'b001: shape = block_s_0;
                3'b011:  shape = block_s_1;
                3'b100:  shape = block_s_0;
                3'b101:  shape = block_s_1;
                default: shape = block_s_0;
            endcase
            end
            if(shape == block_z_0 || shape == block_z_1 )
                begin
                case (shape_state) // Assuming 7 shapes
                3'b001: shape = block_z_0;
                3'b011:  shape = block_z_1;
                3'b100:  shape = block_z_0;
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
