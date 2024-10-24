`timescale 1ns / 1ps

module tb(

    );

logic clk;       
logic pixel_clk;
logic reset;

initial begin
clk = 1'b0;
forever clk = #1ns ~clk;
end							              

initial begin
pixel_clk = 1'b0;
forever pixel_clk = #4ns ~pixel_clk;
end		

logic hs,vs, active_nblank, sync;   
logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size;
logic [11:0] row_contents[22];
logic [11:0] prev_row_contents[22];
logic [11:0] row_contents_final[22];


    
    

logic [3:0] shape [4];

logic [3:0] Red, Green, Blue;    

logic [2:0] random;
logic [7:0]  keycode;
logic firstgen1;
logic update1;

logic newgen;
logic [4:0] row_out;

logic [3:0] col_out;



vga_controller vga(
                    .pixel_clk(pixel_clk),
                    .reset(reset),
                    .hs(hs),              
	                .vs(vs),               
					.active_nblank (active_nblank),
				    .sync(sync),      
	                .drawX(DrawX),     
				    .drawY(DrawY));

pixelMapper pixel_map(
                    .ref_row(row_out),
                    .ref_col(col_out),
                    .shape(shape),
                    .row_contents(row_contents),
                    .prev_row_contents (prev_row_contents),
                    .update (update1),
                    .firstgen(firstgen1),
                    .vsync(clk),
                    .newgen (newgen)
                    );

RandNumrGen randm(
                    .clk(clk),
                    .random(random)
                    );

color_mapper cp(    .BallX(BallX),
                    .BallY(BallY),
                    .Ball_size(Ball_size),
                    .Red(Red), 
                    .Green(Green),
                    .Blue(Blue),
                    .row_contents(row_contents_final), 
                    .DrawX(DrawX),
                    .DrawY(DrawY)                     
);


ShapeDetermine shaped(
//        .random (random),
        .update (update1),
        .firstgen (firstgen1),
        .newgen (newgen),
        .vsync (clk),
        .keycode (keycode),
        .shape (shape),
        .prev_row_contents (prev_row_contents),
        .col_in (col_out),
        .row_in (row_out)
        
    );
    
    
gameLogic game(
        .clk(clk),
        .shape(shape),
        .keycode(keycode),
        .row_out(row_out),
        .col_out(col_out),
        .update(update1),
        .firstgen(firstgen1),
        .newgen(newgen),
        .prev_row_contents (prev_row_contents)

    );

 clear_lines  clear(
        .vsync (clk),
        .in_row_contents (row_contents),
        .row_contents (row_contents_final)
    );   
    

    initial begin
        reset = 0;
        repeat(10) @(posedge pixel_clk);
        reset = 1;
        repeat(10) @(posedge pixel_clk); 
        reset = 0;
        
        keycode = 0;
        repeat(5) @(posedge pixel_clk);        
        keycode =  8'h07;
        repeat(10) @(posedge pixel_clk);
        keycode =  0;
        
        repeat(5) @(posedge pixel_clk);
        keycode =  8'h1A;
        repeat(6) @(posedge pixel_clk);
        keycode =  0;
        
        repeat(10) @(posedge pixel_clk);
        keycode =  8'h07;
        repeat(10) @(posedge pixel_clk);
        keycode =  0;
        repeat(10) @(posedge pixel_clk);
        keycode =  8'h07;
        repeat(10) @(posedge pixel_clk);
        keycode =  0;
        $finish;
    end

endmodule
