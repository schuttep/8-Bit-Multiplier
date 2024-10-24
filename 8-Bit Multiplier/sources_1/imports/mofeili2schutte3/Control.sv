//Two-always example for state machine

module control (
	input  logic Clk, 
	input  logic Reset,
	input  logic Execute,
	input  logic cleara_loadb,
	input logic mult,

	output logic Shift_En, 
	output logic add,
	output logic loadb,
	output logic cleara,
	output logic sub
);

// Declare signals curr_state, next_state of type enum
// with enum values of s_start, s_count0, ..., s_done as the state values
// Note that the length implies a max of 8 states, so you will need to bump this up for 8-bits
	enum logic [4:0] {
		reset, 
		clra, 
		add1, 
		shift1, 
		add2,
		shift2,
		add3,
		shift3,
		add4,
		shift4,
		add5,
		shift5,
		add6,
		shift6, 
		add7,
		shift7,
		sub1,
		shift8,
		halt,
		idle
	} curr_state, next_state; 

	always_ff @ (posedge Clk)
	begin
	// Assign outputs based on ‘state’
		if(Reset)
		  curr_state <= reset;
		else
		  curr_state <= next_state;
	end

// Assign outputs based on state
	always_comb
	begin

		next_state  = curr_state;	//required because I haven't enumerated all possibilities below. Synthesis would infer latch without this
		unique case (curr_state) 

			reset :begin
				if (Execute) 
				    next_state = clra;
			end

			clra :    next_state = add1;
			add1 :    next_state = shift1;
			shift1 :    next_state = add2;
			add2 :    next_state = shift2;
			shift2 :    next_state = add3;
			add3 :    next_state = shift3;
			shift3 :    next_state = add4;
			add4 :    next_state = shift4;
			shift4 :    next_state = add5;
			add5 :    next_state = shift5;
			shift5 :    next_state = add6;
			add6 :    next_state = shift6;
			shift6 :    next_state = add7;
			add7 :    next_state = shift7;
			shift7 :    next_state = sub1;
			sub1 :    next_state = shift8;
	       	shift8 :    next_state = halt;
			halt :    
			begin
				if (~Execute) 
					next_state = idle;
				end
			idle: 
			     if(Reset)
			         next_state = reset;
			     else if(Execute)
			         next_state = clra;
			default: next_state = idle;
		endcase
		
		case(curr_state)
		  reset:
		      begin
		          cleara = cleara_loadb;
		          loadb = cleara_loadb;
		          Shift_En = 1'b0;
		          sub = 1'b0;
		      end
		   clra:
		      begin
		          Shift_En = 1'b0;
		          add = 1'b0;
		          sub = 1'b0;
                  cleara = 1'b1;
                  loadb = 1'b0;
               end		
             add1:
		      begin
		          Shift_En = 1'b0;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  if (mult)
                    add = 1'b1;
                  else
                    add = 1'b0;
               end
             add2:
		      begin
		          Shift_En = 1'b0;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  if (mult)
                    add = 1'b1;
                  else
                    add = 1'b0;
               end
               add3:
		      begin
		          Shift_En = 1'b0;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  if (mult)
                    add = 1'b1;
                  else
                    add = 1'b0;
               end
               add4:
		      begin
		          Shift_En = 1'b0;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  if (mult)
                    add = 1'b1;
                  else
                    add = 1'b0;
               end
               add5:
		      begin
		          Shift_En = 1'b0;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  if (mult)
                    add = 1'b1;
                  else
                    add = 1'b0;
               end
               add6:
		      begin
		          Shift_En = 1'b0;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  if (mult)
                    add = 1'b1;
                  else
                    add = 1'b0;
               end
               add7:
		      begin
		          Shift_En = 1'b0;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  if (mult)
                    add = 1'b1;
                  else
                    add = 1'b0;
               end
               shift1:
		      begin
		          Shift_En = 1'b1;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  add = 1'b0;
               end
               shift2:
		      begin
		          Shift_En = 1'b1;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  add = 1'b0;
               end
               shift3:
		      begin
		          Shift_En = 1'b1;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  add = 1'b0;
               end
               shift4:
		      begin
		          Shift_En = 1'b1;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  add = 1'b0;
               end
               shift5:
		      begin
		          Shift_En = 1'b1;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  add = 1'b0;
               end
               shift6:
		      begin
		          Shift_En = 1'b1;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  add = 1'b0;
               end
               shift7:
		      begin
		          Shift_En = 1'b1;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  add = 1'b0;
               end
               shift8:
		      begin
		          Shift_En = 1'b1;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  add = 1'b0;
               end
               sub1:
		      begin
		          Shift_En = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  add = 1'b0;
                  if (mult)
                    sub = 1'b1;
                  else
                    sub = 1'b0;
               end
               halt:
		      begin
		          Shift_En = 1'b0;
		          sub = 1'b0;
                  cleara = 1'b0;
                  loadb = 1'b0;
                  add = 1'b0;
               end
               idle:
		      begin
		          Shift_En = 1'b0;
		          sub = 1'b0;
                  cleara = cleara_loadb;
                  loadb = cleara_loadb;
                  add = 1'b0;
               end
              default:
                begin
                    Shift_En = 1'b0;
                    add = 1'b0;
                    sub = 1'b0;
                    cleara = cleara_loadb;
                    loadb = cleara_loadb;
                end
              endcase
            end
endmodule
