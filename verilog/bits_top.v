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
   // -- Stack Memory
   smem_ceb,
   smem_web,
   smem_addr,
   smem_wdata,

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

  //Stack Memory
  smem_rdata

);

output       pready;
output[31:0] prdata;
output       pslverr;

output       imem_ceb;
output       imem_web;
output[9:0]  imem_addr;

output       smem_ceb;
output       smem_web;
output[13:0] smem_addr;
output[95:0] smem_wdata;

input        clk;
input        resetB;
input[7:2]   paddr;
input        psel;
input        penable;
input        pwrite;
input[31:0]  pwdata;

input[31:0]  imem_rdata;

input[95:0]  smem_rdata;

wire       start;
wire[15:0] expectedBytes;
wire done_reading_memory;
wire[127:0] instruction_word;
wire[15:0] instruction_valid_bytes;
wire done;
wire[63:0] bits_value;
wire[15:0] version_sum;

wire       mem_req_b;
wire       mem_ack_b;

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
    .done (done),
    .bits_value (bits_value),
    .bits_enable (1'b0),
    .version_sum(version_sum)
);


imem_controller imem_controller(
    //outputs
    // -- Instruction Memory Access (Read Only)
    .imem_ceb (imem_ceb),
    .imem_web (imem_web),
    .imem_addr (imem_addr),

    // -- Status to be sent to bits_regs
    .done_reading_memory (done_reading_memory),
    .instruction_word (instruction_word),
    .instruction_valid_bytes(instruction_valid_bytes),
    .mem_ack_b (mem_ack_b),

    //inputs
    // -- System Inputs
    .clk (clk),
    .resetB (resetB),

    //--Instruction Memory Read Data
    .imem_rdata (imem_rdata),
    .mem_req_b (mem_req_b),

    //--Control bits from Bits_reg
    .expectedBytes (expectedBytes)
);

bits_core bits_core(
    //outputs
    // -- Stack Memory Access (R/W)
    .smem_ceb (smem_ceb),
    .smem_web (smem_web),
    .smem_addr (smem_addr),
    .smem_wdata (smem_wdata),
    .mem_req_b (mem_req_b),

    //-- Status to be sent to bits_regs
    .done (done),
    .version_sum (version_sum),
    .bits_value (bits_value),

    //inputs
    //System Inputs
    .clk (clk),
    .resetB (resetB),

    //--Stack Memory Read Data
    .smem_rdata (smem_rdata),

    //--Instruction Word
    .instruction_word (instruction_word),
    .instruction_byte_valid (instruction_valid_bytes),
    .done_reading_memory (done_reading_memory),
    .mem_ack_b (mem_ack_b),

    //--Control bits from Bits_reg
    .start (start),
    .expectedBytes (expectedBytes)
);


endmodule