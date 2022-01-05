module bits_core(
    //outputs
    // -- Stack Memory Access (R/W)
    smem_ceb,
    smem_web,
    smem_addr,
    smem_wdata,
    mem_req_b,

    //-- Status to be sent to bits_regs
    done,
    version_sum,
    bits_value,
    bit_counter,

    //inputs
    //System Inputs
    clk,
    resetB,

    //--Stack Memory Read Data
    smem_rdata,

    //--Instruction Word
    instruction_word,
    instruction_byte_valid,
    done_reading_memory,
    mem_ack_b,

    //--Control bits from Bits_reg
    start,
    expectedBytes
);

output       smem_ceb;
output       smem_web;
output[13:0] smem_addr;
output[95:0] smem_wdata;

output       mem_req_b;
output       done;
output[15:0] version_sum;
output[63:0] bits_value;
output[15:0] bit_counter;


input        clk;
input        resetB;

input[95:0]  smem_rdata;

input[127:0] instruction_word;
input[15:0]  instruction_byte_valid;
input        done_reading_memory;
input        mem_ack_b;

input        start;
input[15:0]  expectedBytes;

wire[63:0]   number;
wire[6:0]    bitsToShift;
wire[79:0]   encoded_number;
wire         decode_number;
wire[15:0]   validNibbles;
wire [4:0]   instruction_process;

wire mem_req_b;
wire mem_ack_b;
wire[255:0] instruction_cache_word;
wire space_available;

bits_fsm bits_fsm(
   //Outputs
   //Stack Memory
   .smem_ceb (smem_ceb),
   .smem_web (smem_web),
   .smem_addr (smem_addr),
   .smem_wdata (smem_wdata),

   .mem_req_b (mem_req_b),

   // Items to send to Bits Regs
   .done    (done),
   .bits_value (bits_value),
   .version_sum (version_sum),

   // Send to number decoder
   .encoded_number (encoded_number),
   .decodeNumber (decode_number),
   .instruction_process (instruction_process),

   //Inputs
   //System inputs
   .clk (clk),
   .resetB (resetB),

   //Instruction Memory Inputs
   .instruction_word(instruction_word),
   .instruction_byte_valid(instruction_byte_valid),
   .done_reading_memory(done_reading_memory),
   .start(start),
   .instruction_cache_word(instruction_cache_word),
   .space_available(space_available),
   .mem_ack_b (mem_ack_b),

    .smem_rdata (smem_rdata),

   //From number decoder
   .decodedNumber(number),
   .validNibbles(validNibbles)
);

bits_instruction_cache bits_instruction_cache(
   //instruction cache
   .instruction_cache (instruction_cache_word),
   .space_available (space_available),
   .bit_counter (bit_counter),

   //inputs
   .clk (clk),
   .resetB(resetB),

   //imem_controller
   .mem_req_b (mem_req_b),
   .mem_ack_b (mem_ack_b),
   .instruction_word (instruction_word),
   .valid_bytes (instruction_byte_valid),

   //bits_fsm
   .instruction_process (instruction_process)
);

number_top number_decoder(
     //output
     .number          (number),
     .validNibbles    (validNibbles),

     //input
     .clk             (clk),
     .resetB          (resetB),
     .enable          (decode_number),
     .numberFromBits  (encoded_number)
);


endmodule