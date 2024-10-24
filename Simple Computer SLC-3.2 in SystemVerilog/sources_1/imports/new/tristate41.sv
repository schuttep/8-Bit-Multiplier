module tristate41
            #(parameter width = 16)
				(
					input 	logic 	[3:0] select, 
			  		input	logic 	[width - 1 : 0] d0, d1, d2, d3,
			  		output 	logic 	[width - 1 : 0]	out
		  		);
	always_comb
	begin
		unique case (select)
			4'b0001 	:	out = d0;
			4'b0010	    :	out = d1;
			4'b0100     :   out = d2;
			4'b1000     :   out = d3;
			default: out = 'x;
		endcase
	end
endmodule
