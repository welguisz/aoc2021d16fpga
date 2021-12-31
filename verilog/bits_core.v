module bits_core(
    //outputs
    // -- Stack Memory Access (R/W)
    smem_ceb,
    smem_web,
    smem_addr,
    smem_wdata,

    //-- Status to be sent to bits_regs
    done,
    version_sum,
    bits_value,

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

    //--Control bits from Bits_reg
    start,
    expectedBytes
);

output       smem_ceb;
output       smem_web;
output[15:0]  smem_addr;
output[63:0] smem_wdata;

output       done;
output[15:0] version_sum;
output[63:0] bits_value;


input        clk;
input        resetB;

input[63:0]  smem_rdata;

input[127:0] instruction_word;
input[15:0]  instruction_byte_valid;
input        done_reading_memory;

input        start;
input[15:0]  expectedBytes;

wire[63:0]   number;
wire[6:0]    bitsToShift;
wire[79:0]   encoded_number;
wire         decode_number;

bits_fsm bits_fsm(
   //Outputs
   //Stack Memory
   .smem_ceb (smem_ceb),
   .smem_web (smem_web),
   .smem_addr (smem_addr),
   .smem_wdata (smem_wdata),

   // Items to send to Bits Regs
   .done    (done),
   .bits_value (bits_value),
   .version_sum (version_sum),

   // Send to number decoder
   .encoded_number (encoded_number),
   .decodeNumber (decode_number),

   //Inputs
   //System inputs
   .clk (clk),
   .resetB (resetB),

   //Instruction Memory Inputs
   .instruction_word(instruction_word),
   .instruction_byte_valid(instruction_byte_valid),
   .done_reading_memory(done_reading_valid),

   //From number decoder
   .decodedNumber(number),
   .bitsToShift(bitsToShift)
);



number_top number_decoder(
     //output
     .number          (number),
     .bitsToShift     (bitsToShift),

     //input
     .clk             (clk),
     .resetB          (resetB),
     .enable          (decode_number),
     .numberFromBits  (encoded_number)
);


endmodule