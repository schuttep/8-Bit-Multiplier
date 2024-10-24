module full_adder(
    input logic x,
    input logic y,
    input logic z,
    
    output logic c,
    output logic s
);

assign s = x^y^z;
assign c = (x&y)|(y&z)|(x&z);

endmodule
