module bits_fsm(
   //Outputs
   //Stack Memory
   smem_ceb,
   smem_web,
   smem_addr,
   smem_wdata,

   // Items to send to Bits Regs
   done,
   bits_value,
   version_sum,

   // Send to number decoder
   encoded_number,
   decodeNumber,

   //Inputs
   //System inputs
   clk,
   resetB,

   //Instruction Memory Inputs
   instruction_word,
   instruction_byte_valid,
   done_reading_memory,

   //From number decoder
   decodedNumber,
   bitsToShift
);

output       smem_ceb;
output       smem_web;
output[15:0] smem_addr;
output[63:0] smem_wdata;

output       done;
output[63:0] bits_value;
output[15:0] version_sum;

output[79:0] encoded_number;
output       decodeNumber;

input        clk;
input        resetB;

input[127:0] instruction_word;
input[15:0]  instruction_byte_valid;
input        done_reading_memory;

input[63:0]  decodedNumber;
input[6:0]   bitsToShift;

assign smem_ceb = 1'b1;
assign smem_web = 1'b1;
assign smem_addr = 16'h0;
assign smem_wdata = 64'h0;
assign done = 1'b0;
assign bits_value = 64'h0;
assign version_sum = 16'h0;
assign encoded_number = 80'h0;
assign decodeNumber = 1'b0;

endmodule