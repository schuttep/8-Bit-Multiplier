module GridPointer(
    input logic [4:0] row_in,
    input logic [3:0] col_in,
    input logic clk,
    input logic firstgen, newgen,
    output logic [4:0] row_out,
    output logic [3:0] col_out
);

    // Parameters for grid dimensions
    parameter ROWS = 22;
    parameter COLS = 12;

    // Internal variables to store current row and column
    logic [4:0] current_row;
    logic [3:0] current_col;

    // Synchronous process to update pointer location on clock edge
    always_ff @(posedge clk or posedge firstgen) begin
        if (newgen || firstgen) begin
            // Reset to initial position (e.g., top-left corner)
            current_row <= 1;
            current_col <= 5;
        end else begin
            // Update pointer location based on input values
            current_row <= row_in;
            current_col <= col_in;
        end
    end

    // Output current pointer location
    assign row_out = current_row;
    assign col_out = current_col;

endmodule
