module bits_top(
   //outputs
   // --AMBA Peripheral Bus Signals
   pready,
   prdata,
   pslverr,
   // -- Instruction Memory
   imem_ceb,
   imem_web,
   imem_addr,


   //inputs
   // --System inputs
   clk,
   resetB,

   // -- AMBA Peripheral Bus Signals
   paddr,
   psel,
   penable,
   pwrite,
   pwdata,

   //--Instruction Memory
  imem_rdata,



);

output       pready;
output[31:0] prdata;
output       pslverr;

output       imem_ceb;
output       imem_web;
output[9:0]  imem_addr;

input        clk;
input        resetB;
input[7:2]   paddr;
input        psel;
input        penable;
input        pwrite;
input[31:0]  pwdata;

input[31:0]  imem_rdata;

wire       start;
wire[15:0] expectedBytes;

bits_regs bits_regs(
    //outputs
    // -- AMBA Peripheral Bus Signals
    .pready (),
    .prdata (prdata),
    .pslverr(),

    // -- Signals to send to BITS Core
    .expected_bytes(expectedBytes),
    .start(start),

    //inputs
    // -- System Inputs
    .clk (clk),
    .resetB (resetB),

    // -- AMBA Peripheral Bus Signals
    .paddr (paddr[7:2]),
    .psel (psel),
    .penable (penable),
    .pwrite (pwrite),
    .pwdata (pwdata),

    // -- Signals from BITS Core
    .done (1'b0),
    .bits_value (64'h0),
    .bits_enable (1'b0),
    .version_sum(16'h0)
);

imem_controller imem_controller(
    //outputs
    // -- Instruction Memory Access (Read Only)
    .imem_ceb (imem_ceb),
    .imem_web (imem_web),
    .imem_addr (imem_addr),

    // -- Status to be sent to bits_regs
    .done_reading_memory (),
    .instruction_word (),
    .instruction_valid_bytes(),

    //inputs
    // -- System Inputs
    .clk (clk),
    .resetB (resetB),

    //--Instruction Memory Read Data
    .imem_rdata (imem_rdata),

    //--Control bits from Bits_reg
    .start  (start),
    .expectedBytes (expectedBytes)
);


endmodule