module mux2_1
	#(parameter width = 16)
				(
					input 	logic 	select, 
			  		input	logic 	[width - 1 : 0] d0, d1,
			  		output 	logic 	[width - 1 : 0]	out
		  		);
	always_comb
	begin
		unique case (select)
			1'b0 	:	out = d0;
			1'b1	:	out = d1;
		endcase
	end
endmodule 
