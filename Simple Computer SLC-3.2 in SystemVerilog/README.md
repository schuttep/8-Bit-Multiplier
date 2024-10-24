Introduction:  
	This lab focuses on the implementation of a simple SLC-3 microprocessor using System Verilog. The microprocessor is a subset of the LC-3 ISA and is a 16-bit processor with a 16-bit Program Counter, instructions, and registers. The microprocessor can perform several operations and uses a similar Datapath and state machine to the LC-3 processor. It differs in that the SLC-3 does not have logic for the TRAP instructions. In lab 5.1 we implemented the FETCH phase. In 5.2 we implemented the DECODE and EXECUTE phases to create a full microprocessor.
Written Description:  
	The SLC-3 works through using 3 different phases; the FETCH phase, the DECODE phase, and the EXECUTE phase. The FETCH phase calls the instruction from memory in four steps which follow.
MAR <= PC; MAR = memory address to read the instruction from
MDR <= M(MAR); MDR = Instruction read from memory 
IR <= MDR; IR = Instruction to decode
PC <= (PC + 1) = PC is incremented onto the next instruction
After completing the FETCH phase, the SLC-3 continues to the DECODE phase which is completed in one step as follows.
Instruction Sequencer/Decoder <= IR
In this phase the instruction that was called in the FETCH phase is moved from the instruction register to the decoder. This sets the control signals and determines which MUXES are activated, and which registers were loaded. After the DECODE phase, the microprocessor moves on to the EXECUTE phase. In this phase the instruction that was previously decoded is executed using the opcodes set in the DECODE phase. The final output is stored in either the memory or a register depending on which of the 8 instructions were called. The processor then goes back to the FETCH phase to get the next instruction and the cycle repeats itself. The 8 instructions and their opcodes are as follows.
 
The ADD instruction works by adding the value in the SR1 and SR2 and storing it in the direct register. 
The ADDi instruction adds the contents of SR to the sign-extended value imm5 and stores the result to DR.
The AND instruction ANDs the contents of SR1 with SR2 and stores the result to DR.
The ANDi instruction ANDs the contents of SR with the sign-extended value imm5 and stores the result to DR.
The NOT instruction negates SR and stores the result in DR.
The BR instruction if any of the condition codes match the condition stored in the status register, take the branch; otherwise, continues execution.
The JMP instruction copies memory address from BaseR to PC.
The JSR instruction stores current PC to R(7), adds sign-extended PCoffset11 to
PC.
The LDR instruction load using Register offset addressing. Loads DR with memory contents pointed to by (BaseR + SEXT(offset6)).
The STR instruction store using Register offset addressing. Stores the contents of SR at the memory location pointed to by (BaseR + SEXT(offset6)).
The PAUSE instruction pauses execution until Continue is asserted by the user. Execution should only un-pause if Continue is asserted during the current pause instruction; that is, when multiple pause instructions are encountered, only one should be “cleared” per press of Continue. While paused, ledVect12 is displayed on the board LEDs.

 
FETCH
GREEN: MAR <= PC;
BLUE: MDR <= M(MAR);
PINK: IR <= MDR;
YELLOW: PC increment +1
 
DECODE
PINK:  Ir goes into the control.
GREEN: The control  sets the controls for the MUXES, and loads.
 
EXECUTE:
Based on the controls set by the  decode phase the execute phase takes the output of the function and the executes and sends the final data to the CPU to IO to display whatever was executed.
 
 
cpu.sv
 
 
Processor_top.sv
Written Description of SystemVerilog Modules:  
Module: processor_top.sv 
Inputs: clk, reset, run_i, continue_i, [15:0] sw_i
Outputs: [15:0] led_o, [7:0] hex_seg_left, [3:0] hex_grid_left, [7:0] hex_seg_right, [3:0] hex_grid_right
Description: Top level of the processor which has the inputs connected to the FPGA board and instantiates the sync_debounce, the sync_flop, slc3, and the memory modules. The outputs are then stored in the hex segments and leds for display.
Purpose: Controls the inputs from the FPGA board and sends them to the proper lower-level modules. The outputs are then sent to the LEDS and HEX segments for display on the FPGA board.

Module: slc3.sv 
Inputs: clk, reset, run_i, continue_i, [15:0] sw_i, [15:0] sram_rdata
Outputs: [15:0] led_o, [7:0] hex_seg_o, [3:0] hex_grid_o, [7:0] hex_seg_debug, [3:0] hex_grid_debug, [15:0] sram_wdata, [15:0] sram_addr, sram_mem_ena, sram_wr_ena
Description: Top level for the slc3 and instantiates the cpu, cpu_to_io, and hex_debug modules. The outputs are used in the processor_top level.
Purpose: Starts the slc3 so that it can run using the inputs provided by the  top level.

Module: memory.sv
Inputs: clk, reset, ena, wren, [15:0] data, [9:0] address
Outputs: [15:0] readout,
Description: Instantiates the ram and sends the data stored in memory to the top level.
Purpose: Sends the data in memory to the top level for use in other modules such as slc3.

Module: sync_debounce.sv 
Inputs: clk, d
Outputs: q
Description: Takes input from the buttons and uses flip flops to ensure that the input is pressed once
Purpose: ensures that there are no accidental button presses or inputs. Is called in 3 button syncs for the continue button, run button, and reset button.

Module: sync_flop.sv 
Inputs: clk, d
Outputs: q
Description: Uses a flip flop to ensure that a switch isn’t giving multiple inputs.
Purpose: prevents multiple inputs from the switches on the FPGA board. Is used 16 times for the 16 switches on the FPGA board.

Module: cpu.sv 
Inputs: clk, reset, run_i, continue_i
Outputs: [15:0] led_o, [15:0] hex_display_debug, [15:0] mem_rdata, [15:0] mem_wdata,[15:0] mem_addr, sram_mem_ena, sram_wr_ena
Description: Instantiates all MUXES as well as loads data into the registers. The datapath diagram is shown below.
Purpose: Is the backbone for the logic behind the slc3 and directs all signals to their proper place.

 


Module: control.sv 
Inputs: clk, reset, [15:0] ir, ben, [15:0] mem_rdata, continue_i, run_i
Outputs: ld_mar, ld_mdr, ld_ir, ld_ben, ld_cc, ld_reg, ld_pc, ld_led, gate_pc,
gate_mdr, gate_alu, gate_marmux, [1:0] pcmux, drmux, sr1mux, sr2mux, addr1mux, [1:0] addr2mux, [1:0] aluk, mio_en, mem_mem_ena, mem_wr_ena
Description: The control unit is a state machine. It takes the inputs clk, reset, [15:0] ir, ben, [15:0] mem_rdata, continue_i, and run_i. The state machine enables different muxes, gates, and registers. These different enable wires are chosen using the state machine. It starts on state 18 which is the beginning of the FETCH and moves through the DECODE and EXECUTE states before returning to the FETCH state to restart the process.
Purpose: This allows for the execution of the eight instructions.

 

Module: load_reg.sv 
Inputs: clk, reset, [DATA_WIDTH-1:0] data_i, load
Outputs: [DATA_WIDTH-1:0] data_q 
Description: This module is an adjustable register that stores whatever datais inputted and stores it using a flip flop and outputs it when it is called upon.
Purpose: This module allows for the storage of data so that it can be called upon at a later usage. It is used to store the PC, MAR, MDR, IR, N, Z, P, and ben.

Module: mux2_1.sv 
Inputs: select, [width-1:0] d0, [width-1:0] d
Outputs: [DATA_WIDTH-1:0] out 
Description: This is a mux that allows for a select bit to take out an input of an adjustable size and an output of an adjustable size.
Purpose: This allows us to choose specific outputs depending on which mux selection bit is selected in the control unit. This module is used for the mdr_mux, sr2_mux, sr1_mux, dr_mux, and addr1_mux.

Module: trtistate.sv 
Inputs: [3:0] select, [width-1:0] d0, [width-1:0] d1, [width-1:0] d2, [width-1:0] d3
Outputs: [width-1:0] out
Description: This is the bus module and depending on which of the select bit is chosen it will load the data onto the bus so that it may be called upon by several different modules to get the data.
Purpose: This module allows for data to be easily shared between modules and moved easily through the system. 


Module: mux4_1.sv 
Inputs: [1:0] select, [15:0] d0, [15:0] d1, [15:0] d2, [15:0] d3
Outputs: [15:0] out
Description: This is a 4-input mux with one output. The data in is 16 bits large.
Purpose: This module allows for selection between 4 different sources and is used in adder2 mux.

Module: ALU.sv 
Inputs: [1:0] select, [15:0] d0, [15:0] d1
Outputs: [15:0] out
Description: This module is a 4 to one mux that outputs depending on which one of 4 inputs is chosen.
Purpose: This module allows for the arithmetic logic unit to be utilized properly.

Module: reg_file.sv 
Inputs: clk, reset, ld_reg, [15:0] bus, [2:0] ir, [2:0] drout, [2:0] sr1in
Outputs: [15:0] sr1out, [15:0] sr2out
Description: This module is a large storage register that uses the dr input to control which register is loaded. The data is taken from the bus. It is then sent to one of the sr1 and sr2 outputs depending on the sr1 and sr2 selection bits.
Purpose: This module allows for storage and modification of 8 registers.

Module: set_nzp.sv 
Inputs: ld_cc, clk, reset, [15:0] bys
Outputs: N, Z, P
Description: This module takes the data from the bus and decides whether it is positive, negative, or zero. It then stores and outputs this information in NZP.
Purpose: The purpose of this is to check if the input is negative or zero or positive to do the math.
 
IO TEST 1:
Beginning: Reset is set high and then low to ensure that all registers are emptied and that the switches do nothing until run is hit.
Red Line: At the red line the switches are set to 16’h0003 which is the instructions for the IO test 1 instructions. Run is set to 1 which starts the program and the HEX display changes to what is on the switches in our case 3. This program never halts and instead continuously switches between several states to check the value of what is on the switches. This explains why the states check never stops and is continuously changing.
Blue Line: At the blue line the value of the switches is changed and the value displayed on the HEX segment changes accordingly. This happens again later on when the switches are changed to a 16’h0048. 

 
IO Test 2:
Beginning: Same as the last instruction at the beginning of the program everything is cleared. This allows us to run the program with no worry of previous instruction. This program is set by turning the switches to 16’h0006. 
Red Line: At the red line the run is set high and then low to start the program and the state machine. The state machine also runs continuously waiting for a continued input to read the switch input and display the contents of the switches.
Purple Line:  The continue input is given allowing the state machine to continue and display the contents of the switches on the HEX grid. It is important to note that the switches change to state 16’h0048 but the contents of the hex grid do not change as the continue button is not pressed.

 
Self-Modifying Code:
Beginning: Same as the last instruction at the beginning of the program everything is cleared. This allows us to run the program with no worry of previous instruction. This program is set by turning the switches to 16’h000B.
Purple Line: At the purple line the continue switch is hit which increments the pc.
Red Line:  At the red line the continue switch is held down and as we can see the pc is incremented and no longer changes. The state machine also goes into the pause state as is waits for the continue input to no longer be held down so it can begin to check for another continue input.

 
Auto Counting Test:
Beginning: Same as the last instruction at the beginning of the program everything is cleared. This allows us to run the program with no worry of previous instruction. This program is set by turning the switches to 16’h009C. The program then increases by 1 until the reset button is hit or it overflows. The value is then displayed in the hex segments.

 
XOR Test:
Beginning: Same as the last instruction at the beginning of the program everything is cleared. This allows us to run the program with no worry of previous instruction. This program is set by turning the switches to 16’h0014. 
Red Line: The switches are changed to 0013 and continue is pressed to create the first input of the XOR.
Orange Line: The switches are set to 0031 and continue is inputted. This creates the second input for the XOR.
Purple Line: The state machine goes into a halt state after the XOR is completed with the final value being stored in the HEX segment. 

 
MULTIPLICATION Test:
Beginning: Same as the last instruction at the beginning of the program everything is cleared. This allows us to run the program with no worry of previous instruction. This program is set by turning the switches to 16’h0031. 
Red Line: The switches are changed to 0013 and continue is pressed to create the first input of the multiplication.
Orange Line: The switches are set to 0041 and continue is inputted. This creates the second input for multiplication.
Purple Line: The state machine goes into a halt state after the Multiplication is completed with the final value being stored in the HEX segment.
 

Sort Test:
Beginning: Same as the last instruction at the beginning of the program everything is cleared. This allows us to run the program with no worry of previous instruction. This program is set by turning the switches to 16’h005A. 
Red Line: At the red line the switches are changed to 3 and continue is hit to display the contents of the register. This is done until the second 7 is displayed after 17 continue inputs. The contents are stored in the hex seg.
Orange Line: At the orange line the switches are changed to a 2 and the continue button is pressed to sort the list stored in the registers.
Purple Line: At the purple line the switches are changed back to 3 to display the newly sorted contents again. The contents are displayed in the HEX seg.
 
Sort Test:
Beginning: Same as the last instruction at the beginning of the program everything is cleared. This allows us to run the program with no worry of previous instruction. This program is set by turning the switches to 16’h002A. 
Purple Line: At the purple line continue is hit which increments the counter by 1. The result of the increment is displayed in the HEX seg. This is repeated several times.


Post Lab Questions:

	1:
LUT	407
DSP	0
Memory	18432
Flip-Flop	340
Latches	0
Frequency	74.4 MHz
Static Power	.071 W
Dynamic Power	.011 W
Total Power	.082 W

2i: CPU_TO_IO is for connecting the central processing unit to the input/output devices of the FPGA board. It allows the CPU, which is responsible for the execution of the instructions to receive the user instructions from the switches on the board. It also allows for the output of the CPU to be displayed on the FPGA.

2ii: The BR instruction, or branch, is used for a conditional jump which means that it will only jump to a different memory location if a condition is met. The JMP instruction, or jump, is an unconditional jump that will jump to a different memory location no matter what. The second it is called it will jump to a different location and BR will not.

2iii: The R signal is the ready signal which indicates that the memory access has been complete, and that the data is ready for computation. We don’t have this signal in the SLC-3 microprocessor, but we do have pause states which wait for a set number of cycles.  This makes our processor less efficient as we are always waiting for a set number of cycles even if we only need to wait a fraction of the time.

Conclusion:
	Our microprocessor works by taking the inputs from the FPGA switches. They are then sent to the cpu and are processed as the instructions. The instructions are sent through the state machine and are outputted to the FPGA boards HEX leds. This allows us to run a multitude of different programs. Something that we had issue with was that despite the code being current and having no issues it did not seem to work correctly. The problem was fixed randomly when I reverted the code after I changed it. I have no idea what the issue was, but I spent HOURS trying to fix it. I liked having the state machine. I know it was accidentally given to us, but it was very convenient to have and saved a lot of time.
