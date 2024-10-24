//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Given Code - SLC-3 core
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 06-09-2020
//	  Revised 03-02-2021
//    Xilinx vivado
//    Revised 07-25-2023 
//    Revised 12-29-2023
//------------------------------------------------------------------------------

module cpu (
    input   logic        clk,
    input   logic        reset,

    input   logic        run_i,
    input   logic        continue_i,
    output  logic [15:0] hex_display_debug,
    output  logic [15:0] led_o,
   
    input   logic [15:0] mem_rdata,
    output  logic [15:0] mem_wdata,
    output  logic [15:0] mem_addr,
    output  logic        mem_mem_ena,
    output  logic        mem_wr_ena
);


// Internal connections
logic ld_mar; 
logic ld_mdr; 
logic ld_ir; 
logic ld_ben; 
logic ld_cc; 
logic ld_reg; 
logic ld_pc; 
logic ld_led;

logic gate_pc;
logic gate_mdr;
logic gate_alu; 
logic gate_marmux;

logic [1:0] pcmux;
logic       drmux;
logic       sr1mux;
logic       sr2mux;
logic       addr1mux;
logic [1:0] addr2mux;
logic [1:0] aluk;
logic       mio_en;

logic [15:0] mdr_in;
logic [15:0] mar; 
logic [15:0] mdr;
logic [15:0] ir;
logic [15:0] pc;
logic ben;

logic [2:0]  drout;
logic [2:0]  sr1in;
logic [15:0] pcout;
logic [15:0] aluout;
logic [15:0] addr2out;
logic [15:0] addr1out;
logic [15:0] mdrout;
logic [15:0] marmux;
logic [15:0] addr;
logic [15:0] bus;
logic [15:0] sr1out;


assign mem_addr = mar;
assign mem_wdata = mdr;

// State machine, you need to fill in the code here as well
// .* auto-infers module input/output connections which have the same name
// This can help visually condense modules with large instantiations, 
// but can also lead to confusing code if used too commonly
control cpu_control (
    .*
);


assign led_o = ir;
assign hex_display_debug = ir;



//load_reg #(.DATA_WIDTH(16)) ir_reg (
//    .clk    (clk),
//    .reset  (reset),

//    .load   (ld_ir),
//    .data_i (bus),

//    .data_q (ir)
//);

load_reg #(.DATA_WIDTH(16)) pc_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_pc),
    .data_i(pcout),

    .data_q(pc)
);

load_reg #(.DATA_WIDTH(16)) mar_reg (
        .clk(clk),
        .reset(reset),
        
        .load(ld_mar),
        .data_i(bus),
        
        .data_q(mar)

);

load_reg #(.DATA_WIDTH(16)) mdr_reg (
        .clk(clk),
        .reset(reset),
        
        .load(ld_mdr),
        .data_i(mdrout),
        
        .data_q(mdr)

);

mux2_1 #(.width(16)) mdr_mux(
       .select (mem_mem_ena),
       .d0     (bus),
       .d1     (mem_rdata),
       .out    (mdrout)
);

tristate41 tri_bus(
    .select     ({gate_pc, gate_mdr, gate_alu, gate_marmux}),
    .d0         (marmux),
    .d1         (aluout),
    .d2         (mdr),
    .d3         (pc),
    .out        (bus)
);

load_reg #(.DATA_WIDTH(16)) ir_reg (
    .clk    (clk),
    .reset  (reset),

    .load   (ld_ir),
    .data_i (bus),

    .data_q (ir)
);

//logic [15:0] irs11;
//assign irs11 = {{5{ir[10]}}, ir[10:0]};

//logic [15:0] irs9;
//assign irs9 = {{7{ir[8]}}, ir[8:0]};

//logic [15:0] irs6;
//assign irs6 = {{10{ir[5]}}, ir[5:0]};

mux4_1 adder2(
    .select     (addr2mux),
    .d0         (16'b0),
    .d1         ({{10{ir[5]}}, ir[5:0]}),
    .d2         ({{7{ir[8]}}, ir[8:0]}),
    .d3         ({{5{ir[10]}}, ir[10:0]}),
    .out        (addr2out)
);

//logic [15:0] irs4;
//assign irs4 = {{11{ir[4]}}, ir[4:0]};

logic [15:0] sr2out;
logic [15:0] aluin;

mux2_1 #(.width(16)) sr2(
   .select      (sr2mux),
    .d0         (sr2out),
    .d1         ({{11{ir[4]}}, ir[4:0]}),
    .out        (aluin)
);  


ALU alu(
    .select      (aluk),
    .d0          (sr1out),
    .d1          (aluin),
    .out         (aluout)
);

mux2_1 #(.width(3)) sr1(
    .select     (sr1mux),
    .d0         (ir[11:9]),
    .d1         (ir[8:6]),
    .out        (sr1in)
);

mux2_1 #(.width(3)) dr_mux(
        .select         (drmux),
        .d0             (ir[11:9]),
        .d1             (3'b111),
        .out            (drout)
);

mux2_1 #(.width(16)) addr1(
        .select (addr1mux),
        .d0     (pc),
        .d1     (sr1out),
        .out    (addr1out)
);

assign marmux = addr1out + addr2out;

mux4_1 pc_mux(
    .select     (pcmux),
    .d0         (pc+1'b1),
    .d1         (bus),
    .d2         (marmux),
    .d3         (),
    .out        (pcout)
);

reg_file register(
        .ld_reg (ld_reg),
        .clk    (clk),
        .reset  (reset),
        .bus    (bus),
        .ir     (ir),
        .drout  (drout),
        .sr1in  (sr1in),
        .sr1out (sr1out),
        .sr2out (sr2out)        
);

logic N,Z,P;

NZP set_nzp(
.ld_cc  (ld_cc),
.clk    (clk),
.reset  (reset),
.bus    (bus),
.N      (N),
.Z      (Z),
.P      (P)
);

load_reg #(.DATA_WIDTH(3)) ben_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_ben),
    .data_i((N&ir[11]) | (Z&ir[10]) | (P&ir[9])),

    .data_q(ben)
);





endmodule