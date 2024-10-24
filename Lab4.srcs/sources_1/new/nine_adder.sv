module nine_adder(
    input logic [7:0] A,
    input logic [7:0] sw,
    input logic sub,
    
    output logic [8:0] s,
    output logic cout
    );
    
    logic [7:0] c, b;
    
assign    b[0] = sub ^ sw[0];
assign    b[1] = sub ^ sw[1];
assign    b[2] = sub ^ sw[2];
assign    b[3] = sub ^ sw[3];
assign    b[4] = sub ^ sw[4];
assign    b[5] = sub ^ sw[5];
assign    b[6] = sub ^ sw[6];
assign    b[7] = sub ^ sw[7];

full_adder fa0(.x(A[0]), .y(b[0]), .z(sub), .s(s[0]), .c(c[0]));
full_adder fa1(.x(A[1]), .y(b[1]), .z(c[0]), .s(s[1]), .c(c[1]));
full_adder fa2(.x(A[2]), .y(b[2]), .z(c[1]), .s(s[2]), .c(c[2]));
full_adder fa3(.x(A[3]), .y(b[3]), .z(c[2]), .s(s[3]), .c(c[3]));
full_adder fa4(.x(A[4]), .y(b[4]), .z(c[3]), .s(s[4]), .c(c[4]));
full_adder fa5(.x(A[5]), .y(b[5]), .z(c[4]), .s(s[5]), .c(c[5]));
full_adder fa6(.x(A[6]), .y(b[6]), .z(c[5]), .s(s[6]), .c(c[6]));
full_adder fa7(.x(A[7]), .y(b[7]), .z(c[6]), .s(s[7]), .c(c[7]));
full_adder fa8(.x(A[7]), .y(b[7]), .z(c[7]), .s(s[8]), .c(cout));






endmodule
