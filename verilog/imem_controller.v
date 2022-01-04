module imem_controller(
    //outputs
    // -- Instruction Memory Access (Read Only)
    imem_ceb,
    imem_web,
    imem_addr,

    // -- Status to be sent to bits_fsm
    done_reading_memory,
    instruction_word,
    instruction_valid_bytes,
    mem_ack_b,


    //inputs
    // -- System Inputs
    clk,
    resetB,

    //--Instruction Memory Read Data
    imem_rdata,

    //--FSM Memory Request
    mem_req_b,

    //--Control bits from Bits_reg
    expectedBytes
);

output        imem_ceb;
output        imem_web;
output[9:0]   imem_addr;

output        done_reading_memory;
output[127:0] instruction_word;
output[15:0]  instruction_valid_bytes;
output        mem_ack_b;

input         clk;
input         resetB;

input[31:0]   imem_rdata;

input         mem_req_b;

input[15:0]   expectedBytes;


reg[127:0]   instruction_word;
reg[15:0]    instruction_valid_bytes;
reg[16:0]    byteCounter;
reg[3:0]     state;
reg[127:0]   instruction_word_next;
reg[3:0]     state_next;
reg[16:0]    byteCounter_next;

reg          imem_ceb;
reg          imem_web;
reg[9:0]     imem_addr;
reg          imem_ceb_next;
reg          imem_web_next;
reg[9:0]     imem_addr_next;
reg          mem_ack_b;
reg          mem_ack_b_next;
reg          done_reading_memory;
reg          done_reading_memory_next;
reg[15:0]    instruction_valid_bytes_next;

parameter IDLE       = 4'b0000;
parameter READ_WAIT  = 4'b0001;
parameter READ_INST0 = 4'b0010;
parameter READ_INST1 = 4'b0011;
parameter READ_INST2 = 4'b0100;
parameter READ_INST3 = 4'b0101;
parameter FINISH_RD  = 4'b0110;

parameter DONE     = 4'b1111;

always @(state or mem_req_b or expectedBytes or byteCounter or imem_addr or instruction_word or
         instruction_valid_bytes)
begin
  state_next = state;
  imem_ceb_next = 1'b1;
  imem_web_next = 1'b1;
  imem_addr_next = imem_addr;
  byteCounter_next = byteCounter;
  instruction_word_next = instruction_word;
  done_reading_memory_next = 1'b0;
  mem_ack_b_next = 1'b1;
  instruction_valid_bytes_next = instruction_valid_bytes;
  case (state)
     IDLE:
       begin
          if (~mem_req_b) begin
             state_next = READ_WAIT;
             imem_ceb_next = 1'b0;
             imem_web_next = 1'b1;
             imem_addr_next = imem_addr;
             byteCounter_next = byteCounter + 16'h0004;
          end
       end
     READ_WAIT:
       begin
          state_next = READ_INST0;
          if (byteCounter <= expectedBytes) begin
             state_next = READ_INST0;
             imem_ceb_next = 1'b0;
             imem_web_next = 1'b1;
             imem_addr_next = imem_addr + 10'h1;
             byteCounter_next = byteCounter + 16'h0004;
          end
       end
     READ_INST0:
       begin
          if (byteCounter <= expectedBytes) begin
             state_next = READ_INST1;
             imem_ceb_next = 1'b0;
             imem_web_next = 1'b1;
             imem_addr_next = imem_addr + 10'h1;
             byteCounter_next = byteCounter + 16'h0004;
          end
          else begin
             state_next = DONE;
             done_reading_memory_next = 1'b1;
             mem_ack_b_next = 1'b0;
          end
          instruction_word_next[127:96] = imem_rdata;
          instruction_valid_bytes_next[15:12] = 4'hf;
       end
     READ_INST1:
       begin
          if (byteCounter <= expectedBytes) begin
             state_next = READ_INST2;
             imem_ceb_next = 1'b0;
             imem_web_next = 1'b1;
             imem_addr_next = imem_addr + 10'h1;
             byteCounter_next = byteCounter + 16'h0004;
          end
          else begin
             state_next = DONE;
             done_reading_memory_next = 1'b1;
             mem_ack_b_next = 1'b0;
          end
          instruction_word_next[95:64] = imem_rdata;
          instruction_valid_bytes_next[11:8] = 4'hf;
       end
     READ_INST2:
       begin
          if (byteCounter <= expectedBytes) begin
             state_next = READ_INST3;
             imem_ceb_next = 1'b0;
             imem_web_next = 1'b1;
             imem_addr_next = imem_addr + 10'h1;
             byteCounter_next = byteCounter + 16'h0004;
          end
          else begin
             state_next = DONE;
             done_reading_memory_next = 1'b1;
             mem_ack_b_next = 1'b0;
          end
          instruction_word_next[63:32] = imem_rdata;
          instruction_valid_bytes_next[7:4] = 4'hf;
       end
     READ_INST3:
       begin
          if (byteCounter <= expectedBytes) begin
             state_next = FINISH_RD;
          end
          else begin
             state_next = DONE;
             done_reading_memory_next = 1'b1;
             mem_ack_b_next = 1'b0;
          end
          instruction_word_next[31:0] = imem_rdata;
          instruction_valid_bytes_next[3:0] = 4'hf;
       end
     FINISH_RD:
       begin
          if (byteCounter <= expectedBytes) begin
             state_next = READ_INST1;
             imem_ceb_next = 1'b0;
             imem_web_next = 1'b1;
             imem_addr_next = imem_addr + 10'h1;
             state_next = IDLE;
          end
          else begin
             state_next = DONE;
             done_reading_memory_next = 1'b1;
             mem_ack_b_next = 1'b0;
          end
       end
     endcase

end

always @(posedge clk or negedge resetB)
begin
  if (~resetB)
    begin
       state <= IDLE;
       byteCounter <= 16'h0;
       imem_ceb <= 1'b1;
       imem_web <= 1'b1;
       imem_addr <= 10'h0;
       instruction_word <= 128'h0;
       done_reading_memory <= 1'b0;
       instruction_valid_bytes <= 16'h0;
    end
    else begin
       state <= state_next;
       byteCounter <= byteCounter_next;
       imem_ceb <= imem_ceb_next;
       imem_web <= imem_web_next;
       imem_addr <= imem_addr_next;
       instruction_word <= instruction_word_next;
       done_reading_memory <= done_reading_memory_next;
       mem_ack_b <= mem_ack_b_next;
       instruction_valid_bytes <= instruction_valid_bytes_next;
    end
end

endmodule