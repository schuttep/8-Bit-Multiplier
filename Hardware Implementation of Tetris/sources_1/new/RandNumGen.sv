module RandNumrGen (
    input logic clk,  // Clock input
    output logic [2:0] random  // Output random number from 1 to 7
);

// Internal state of the LFSR
    logic [2:0] lfsr_state;

    // LFSR taps for maximal-length sequence
    // Use taps at positions 3 and 2
    always_ff @(posedge clk) begin
            // LFSR feedback logic
            lfsr_state <= {lfsr_state[1:0], lfsr_state[2] ^ lfsr_state[1]};
            case(lfsr_state)
             3'b000: random = 3'b001;
             3'b001: random = 3'b010;
             3'b010: random = 3'b011;
             3'b011: random = 3'b100;
             3'b100: random = 3'b101;
             3'b101: random = 3'b110;
             3'b110: random = 3'b111;
             3'b111: random = 3'b001;
               default: random = 3'b001; // Default case, should not occur
             endcase
        
    end
endmodule