module ALU(
                    input 	logic 	[1:0] select, 
			  		input	logic 	[15 : 0] d0, d1,
			  		output 	logic 	[15 : 0]	out
    );
    
    always_comb
	begin
		unique case (select)
			4'b00  	:	out = d0 + d1;
			4'b01    :	out = d0 & d1;
			4'b10     :  out = ~d1;
			4'b11    :   out = d1;
		endcase
	end
endmodule
