Introduction:  
This lab focused on the creation of an 8-bit multiplier for two 8-bit 2’s. compliment numbers using logical operations.  The 8-bit inputs are put into either Register A or B depending on whether the input is a multiplier or a multiplicand. To do this we do a series of additions and subtractions of the multiplicand and the multiplier that create the final solution. We then store the final result is then stored in two 8bit registers. 

Pre-Lab:  
Function	X	A	B	M
Clear A
Load B	0	00000000	00000111	1
Add 1	1	11000101	00000111	1
Shift 1	1	11100010	1 0000011	1
Add 2	1	10100111	1 0000011	1
Shift 2	1	11010011	11 000001	1
Add 3	1	10011000	11 000001	1
Shift 3	1	11001100	011 00000	0
Shift 4	1	11100110	0011 0000	0
Shift 5	1	11110011	00011 000	0
Shift 6	1	11111001	100011 00	0
Shift 7	1	11111100	1100011 0	0
Shift 8	1	11111110	01100011	0

Summary of Operation:  
Our design computes the multiplication between two 8-bit values that are stored in Register A and Register B. We use the add shift multiplication algorithm that was explained in the lab manual to handle the multiplication computations. The multiplicand is stored in register A and the multiplier is stored in Register B. Register A is cleared and then controlled using the switches on the FPGA board. Register B is loaded using the switches on the FPGA board and when loaded using the reset button it also clears the contents of register A. The least significant bit of Register B is designated as the multiplier M and the most significant bit of the 9-bit sign extended result of the multiplicand is X and designates whether the bits need to be added, subtracted, or shifted to the right. X is also stored with the result in a 17-bit register and is referred to as XAB. This register starts with X as XAB[16] then register A from XAB[15:8] and finally register B from XAB[7:0]. For a full run of the operation first the switches must be used to get the multiplier into register B. Once the correct switches have been pressed the clear A load B button will be pressed which does exactly what it says. Then the switches are moved again to select the correct value of the multiplicand. Finally, the execute switch is pressed. From the there the computation begins by storing the M and X bit and using those bits to begin the computation. We use M bit to determine if we need to do a right shift or an add. If the M bit is a 1 then the value of the switches are added to register A. If the M is a 0 then register AB is shifted over by 1 to the right. After an add operation the register AB will always shift regardless of the M specified. There will be 8 shifts total and on the 7th shift the X and M values are called upon to determine the final operation of the circuit. If M and X are both one than the value of the switches is subtracted from register A before the final shift. In any other case then we move to the 8th and final shift. Finally we go into an IDLE state to observe the solution before and allow us a chance to change the switches before clearing A and loading B to run the next multiplication.
 
Written Description of SystemVerilog Modules:  
Module: reg_m.sv 
Inputs: clk, reset, A_In, Ld_B, Shift_En, D
Outputs: shift_out, d_out
Description: This module is a register for M variable and stores the value of M in a single bit register.
Purpose: Allows for easy loading and unloading of the M value into the register so that the M may be called upon quickly and easily.

Module: register_unit.sv 
Inputs: clk, reset, A_In, Ld_B, Shift_En, D[7:0]
Outputs: shift_out, d_out[7:0]
Description: This module is an 8-bit register that can be called upon to store the multiplier and the multiplicand. It also allows for easy adjustments to the registers through the use of the shift_en which allows.
Purpose: Allows for easy loading and unloading of registers so that the multiplicand and multiplier can be called upon easily.

Module: hex_driver.sv
Inputs: clk, reset, [3:0] in[4]
Outputs: [7:0] hex_seg, [7:0] hex_grid
Description: Takes a 4 bit binary input and converts it into the 7-bit hex equivalent to allow for display on the LEDS.
Purpose: Allows the LEDs to display the contents of the registers in a non-binary format.


Module: Processor.sv
Inputs: clk, Reset, Execute, [7:0]  Din
Outputs: Xval, [7:0] Aval, [7:0] Bval, [7:0] hex_seg, [3:0] hex_grid
Description: Calls the different sv files in the hierarchy and uses the switches on the FPGA board or testbench as different inputs. This file is the top of the hierarchy and controls the inputs to the different .sv files called.
Purpose: This allows for each part to operate in the order required and with the inputs we decide using the sw switches on the fpga board. This allows for greater control and flexibility over our circuit.

Module: Processor.sv
Inputs: clk, Reset, Execute, cleara_loadb, mult
Outputs: Shift_En, add, loadb, cleara, sub
Description: Has states for each move we want from our addition multiplier. It then uses our logic to create a state machine that operates using the logic designated in the Lab manual. For each state we control whether or not we shift our register data, if we subtract, if we load or clear, or if we add. 
Purpose: This allows us to determine the order and ensure that we add, subtract, and shift when we need to. This means that our multiplier will work as intended and give us our final solution following the state diagram we have created.

Module: full_adder.sv
Inputs: x, y, z
Outputs: c, s
Description: Takes inputs X and Y which are your A and B inputs and uses them in combination with Z which acts as our C-in to determine the sum using the formula s = x^y^z. It also determines the c-out using the formula     c=(x&y)|(y&z)|(x&z).
Purpose: This module is referenced in nine_adder to create a 9 bit adder easily. The downside being that the adder is a ripple adder so is not the fastest but simplest to implement.

Module: nine_adder.sv
Inputs: [7:0] A, [7:0] sw, sub
Outputs: cout, [8:0] s
Description: Uses inputs A and sw and sub to add 9 bits together. It does this by rippling 9 full_adders together as well as using the sub.
Purpose: This module is used to add two 8 bit values together to create a 9 bit solution. This is useful in as it allows us to have a carry value which can be used to create a multiplier by using the carry value to compute further additions.
 

 
This is our (+*+)
Red Dashes: Din is set to 3 and is then input into Bval as the multiplier when load B clear A switch is pressed.
Blue Dash: Din is then set to 4 and is prepared to be used as the multiplicand once the execute button is pushed.
Purple Dash:	 The execute switch is pressed and the calculation is performed. Note that Din should be loaded into register A but seeing as we did this lab during our covid quarantine we have yet to fix all the bugs that presented themselves due to being inundated with make up work. You can see at the rightmost purple dash however that the solution of 0c is stored in the Bval before being shifted out. We run 8 shifts as we should, but the shifts do not stop after 8 indicating a problem with our idle state. 

 
This is our (+*-)
Red Dashes: Din is set to 82 which corresponds to -4. And is then loaded into Bval when the clear A Load B switch is pushed. 
Blue Dashes: Din is switched to 4 and is prepared to load into Aval which is our A register and multiplicand. 
Purple Dashes: We then hit the execute button as shown by the purple switch which begins the calculation. Unfortunately, we get the incorrect value as our output and get a value of 4. We think this is an issue of the Xval not working as intended and will be fixed in the future.
 
This is our (-*-)
Red Dashes: Din is set to -4 and is loaded into Register B at the reset and load B. We then leave D in as -4 as we are multiplying it to itself.
Blue Dashes: We then hit the execute button which starts the computation. We can see that our solution is incorrect and has the same issue as the last computation. Our Xval does not behave correctly as well as our Aval. This will be fixed before we demo as we have not had a chance to complete the code as we have had a lot of makeup work.

Post Lab:

LUT	34
DSP	0
Memory	0
Flip-Flop	7
Latches	0
Frequency	74.4 MHz
Static Power	.486 W
Dynamic Power	37.336 W
Total Power	37.822 W

(1): What is the purpose of the X register? When does the X register get set/cleared?
X register is using to store the sign of the result. X=0 means the result is positive, X=1 means the result is negative. X will be set to 1 while the 9th bit result of 9-bit adder is 1. (since A[8:7] must be 0, it will be 1 only when S is negative or doing sub operation). And the X will not be set back to 0. Then X will be cleared when resetting, pressing Reset_ClearA_LoadB.

(2): What would happen if you used the carry out of an 8-bit adder instead of output of a 9-bit adder for X?
If the carry out of an 8-bit adder were used instead of the output of a 9-bit adder for X, it would lead to incorrect results. This is because the carry out of an 8-bit adder only accounts for the addition of the least significant 8 bits, neglecting any overflow or carry beyond the 8th bit. However, in this algorithm, we need to consider the entire 9-bit result to ensure accuracy in multiplication

(3): What are the limitations of continuous multiplications? Under what circumstances will the implemented algorithm fail? 
Continuous multiplications may require a significant number of clock cycles to compute the result, especially for large multiplicands and multipliers. The implemented algorithm may fail or produce incorrect results under conditions where overflow occurs during addition or shifting operations.

(4): What are the advantages (and disadvantages?) of the implemented multiplication algorithm over the pencil-and-paper method discussed in the introduction?
Advantages: Bit-based operations is optimized for logical hardware implementation, making it suitable for digital circuits and processors.

Disadvantages: The algorithm may require a significant number of clock cycles to compute the result, making it slower compared to pencil-and-paper methods for large operands.

Conclusion:
Functionality of Design:
In this lab, we use continuous multiplication algorithm to implement a multiplier with double 8 bits input to 17 bits result. The whole multiplier is mainly composed of control unit, register and computing unit. register B and S are used to store the initial multipliers and multipliers. The control unit sends commands like sub, add, shift to the computing unit based on input and continuous multiplication algorithm. The computing unit(mainly A 9-bit adder) then stores the calculated results in a 17 btis register formed by connecting X(1 bti), A(8 bits), and B(8 bits) in sequence.

Suggestion:
“Figure 1: Incomplete Block Diagram” really help understanding the structure of the whole multiplier, it is highly recommend to be kept. 






