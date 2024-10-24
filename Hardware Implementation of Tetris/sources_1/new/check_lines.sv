`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2024 07:39:45 PM
// Design Name: 
// Module Name: check_lines
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


module check_lines(
        input logic [11:0] row_contents[22],
        input logic vsync,
        output logic line_clear,
        output logic [4:0] cleared_line
    );
    
    logic [9:0] row;
    
    // Function to check if a line is clear (all cells in the line are occupied)
    function bit check_line_clear();
        int i;
        for (i = 1; i < 11; i++) 
        begin
            if (!row[i]) 
            begin
                return 0; // Line is not clear
            end
        end
        return 1; // Line is clear
    endfunction

    // Check all lines for line clear
    always_ff @(posedge vsync) begin
        int line;
        line_clear = 0;
        for (line = 1; line < 22; line++) begin
            row = row_contents[line];
            if (check_line_clear()) begin
                line_clear = 1;
                cleared_line = line;
                break;
            end
            else
        begin
        line_clear = 0;
        cleared_line = 2;
        end
        end
        
    end

endmodule