module mux4_1(
                    input 	logic 	[1:0] select, 
			  		input	logic 	[15 : 0] d0, d1, d2, d3,
			  		output 	logic 	[15 : 0]	out
    );
    
    always_comb
	begin
		unique case (select)
			4'b00  	:	out = d0;
			4'b01    :	out = d1;
			4'b10     :  out = d2;
			4'b11    :   out = d3;
		endcase
	end
endmodule
