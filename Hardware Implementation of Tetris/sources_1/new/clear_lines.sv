`timescale 1ns / 1ps

module clear_lines(
        input logic vsync,
        input logic update,
        input logic [11:0] in_row_contents [22],
        output logic [11:0] row_contents [22]
    );

 logic [11:0]  internal_row_contents [22];

always_ff @(posedge vsync)
    begin
     internal_row_contents = in_row_contents;

    if(update)
    begin
        for(int i = 0; i < 22; i ++)
            begin
            if(!(i == 0 || i == 21))
            begin
                if(in_row_contents[i] == 12'b111111111111)
                begin
                    for(int j = i; j > 1; j--)
                    begin
                        internal_row_contents[j] <= in_row_contents[j - 1];
                    end
                end
                break;
            end
            else if (i==0 || i == 21)
                internal_row_contents[i] = 12'b111111111111;
            end
        
          row_contents = internal_row_contents;
    end
    end



endmodule 