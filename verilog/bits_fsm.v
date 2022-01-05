module bits_fsm(
   //Outputs
   //Stack Memory
   smem_ceb,
   smem_web,
   smem_addr,
   smem_wdata,

   //
   mem_req_b,

   // Items to send to Bits Regs
   done,
   bits_value,
   version_sum,

   // Send to number decoder
   encoded_number,
   decodeNumber,
   instruction_process,

   //Inputs
   //System inputs
   clk,
   resetB,

   //Stack memory rdata
   smem_rdata,

   //Instruction Memory Inputs
   instruction_word,
   instruction_byte_valid,
   done_reading_memory,
   mem_ack_b,
   instruction_cache_word,
   space_available,


   //From bits_regs
   start,

   //From number decoder
   decodedNumber,
   validNibbles
);

output       smem_ceb;
output       smem_web;
output[13:0] smem_addr;
output[95:0] smem_wdata;

output       mem_req_b;

output       done;
output[63:0] bits_value;
output[15:0] version_sum;
output[4:0]  instruction_process;

output[79:0] encoded_number;
output       decodeNumber;

input        clk;
input        resetB;

input        start;

input[95:0]  smem_rdata;

input[127:0] instruction_word;
input[15:0]  instruction_byte_valid;
input        done_reading_memory;
input        mem_ack_b;
input[255:0] instruction_cache_word;
input        space_available;

input[63:0]  decodedNumber;
input[15:0]  validNibbles;

reg smem_ceb;
reg smem_web;
reg[13:0] smem_addr;
reg[95:0] smem_wdata;
reg done;
reg[63:0] bits_value;
reg[15:0] version_sum;
reg[79:0] encoded_number;
reg       decodeNumber;


reg smem_ceb_next;
reg smem_web_next;
reg[13:0] smem_addr_next;
reg[95:0] smem_wdata_next;
reg done_next;
reg[63:0] bits_value_next;
reg[15:0] version_sum_next;
reg[79:0] encoded_number_next;
reg       decodeNumber_next;
reg       done_reading_memory_reg;
reg [3:0] state;
reg [3:0] state_next;

reg [4:0] instruction_process;
reg [4:0] instruction_process_next;

reg mem_req_b_next;
reg mem_req_b;

parameter IDLE = 4'h0;
parameter REQ_MEM = 4'h1;
parameter MEM_ACK = 4'h2;
parameter PROCESS_INSTR = 4'h3;
parameter PUSH_TO_STACK = 4'h4;
parameter PUSH_LITERAL_TO_STACK = 4'h8;
parameter PUSH_LTS_UPDATE_ADDR = 4'h9;
parameter PUSH_OP0_TO_STACK = 4'ha;
parameter PUSH_OP1_TO_STACK = 4'hb;
parameter POP_FROM_STACK = 4'h5;
parameter PROCESS_STACK = 4'h6;
parameter DONE = 4'h7;

wire [2:0] version_sum_current;
wire [2:0] packet_type;
wire       literal_packet;
wire       operator_packet_type;
wire       stack_is_empty;
wire[3:0]  validNibbleCount;
reg        operator_packet_type_reg;
reg        operator_packet_type_next;
wire       instruction_cache_empty;

reg [14:0] parent_packet_id;
reg [14:0] this_packet_id;
reg [14:0] parent_packet_id_next;
reg [14:0] this_packet_id_next;
reg        literal_packet_reg;
reg        literal_packet_reg_next;


assign     instruction_cache_empty = instruction_cache_word == 256'h0;

assign version_sum_current = instruction_cache_word[255:253];
assign packet_type = instruction_cache_word[252:250];
assign operator_packet_type = instruction_cache_word[249];
assign literal_packet = (packet_type == 3'b100);
assign stack_is_empty = (smem_addr == 14'h0);
assign validNibbleCount = validNibbles[0] + validNibbles[1] + validNibbles[2] + validNibbles[3] +
    validNibbles[4] + validNibbles[5] + validNibbles[6] + validNibbles[7] + validNibbles[8] + validNibbles[9] +
    validNibbles[10] + validNibbles[11] + validNibbles[12] + validNibbles[13] + validNibbles[14] +
    validNibbles[15] + 4'hf;

always @(state or start or mem_ack_b or done_reading_memory_reg or space_available or
    version_sum or version_sum_current or literal_packet or instruction_cache_word or
    smem_addr or stack_is_empty or validNibbleCount or parent_packet_id or this_packet_id or
    decodedNumber or literal_packet_reg or smem_ceb or smem_web or smem_wdata or literal_packet_reg or
    bits_value or operator_packet_type or operator_packet_type_reg or instruction_cache_empty)
  begin
     bits_value_next = bits_value;
     done_next = done;
     state_next = state;
     mem_req_b_next = 1'b1;
     version_sum_next = version_sum;
     encoded_number_next = instruction_cache_word[249:170];
     decodeNumber_next = 1'b0;
     smem_addr_next = smem_addr;
     smem_ceb_next = smem_ceb;
     smem_web_next = smem_web;
     smem_wdata_next = smem_wdata;
     instruction_process_next = 5'h1f;
     this_packet_id_next = this_packet_id;
     parent_packet_id_next = parent_packet_id;
     literal_packet_reg_next = literal_packet_reg;
     operator_packet_type_next = operator_packet_type_reg;
     case(state)
        IDLE:
          begin
            if (start) begin
               mem_req_b_next = 1'b0;
               state_next = REQ_MEM;
            end
          end
        REQ_MEM:
          begin
            if (!mem_ack_b) begin
               mem_req_b_next = 1'b1;
               state_next = MEM_ACK;
            end
            else begin
              mem_req_b_next = 1'b0;
              state_next = REQ_MEM;
            end
          end
        MEM_ACK:
          begin
             if (done_reading_memory_reg || !space_available) begin
                state_next = PROCESS_INSTR;
             end else begin
                state_next = REQ_MEM;
                mem_req_b_next = 1'b0;
             end
          end
        PROCESS_INSTR:
          begin
             version_sum_next = version_sum + version_sum_current;
             if (literal_packet) begin
                literal_packet_reg_next = 1'b1;
                decodeNumber_next = 1'b1;
                state_next = PUSH_TO_STACK;
                instruction_process_next = {1'b0,validNibbleCount};
             end else begin
                literal_packet_reg_next = 1'b0;
                operator_packet_type_next = operator_packet_type;
                instruction_process_next = {1'b1,3'b000,operator_packet_type};
                operator_packet_type_next = operator_packet_type;
                state_next = PUSH_TO_STACK;
             end
          end
        PUSH_TO_STACK:
          begin
            if (literal_packet_reg) begin
              state_next = PUSH_LITERAL_TO_STACK;
            end
            else if (instruction_cache_empty) begin
              state_next = POP_FROM_STACK;
            end else begin
              if (operator_packet_type_reg) begin
                state_next = PUSH_OP1_TO_STACK;
              end else begin
                state_next = PUSH_OP0_TO_STACK;
              end
            end
          end
        PUSH_LITERAL_TO_STACK:
          begin
             state_next = PUSH_LTS_UPDATE_ADDR;
             smem_wdata_next={2'b10,parent_packet_id,this_packet_id,decodedNumber};
             smem_ceb_next = 1'b0;
             smem_web_next = 1'b0;
          end
        PUSH_OP0_TO_STACK:
          begin
             state_next = PUSH_LTS_UPDATE_ADDR;
             smem_wdata_next={2'b00,parent_packet_id,this_packet_id,operator_packet_type_reg,61'b0};
             smem_ceb_next = 1'b0;
             smem_web_next = 1'b0;
          end
        PUSH_OP1_TO_STACK:
          begin
             state_next = PUSH_LTS_UPDATE_ADDR;
             smem_wdata_next={2'b00,parent_packet_id,this_packet_id,operator_packet_type_reg,61'b0};
             smem_ceb_next = 1'b0;
             smem_web_next = 1'b0;
          end
        PUSH_LTS_UPDATE_ADDR:
          begin
            if (instruction_cache_empty) begin
              state_next = POP_FROM_STACK;
            end else if (space_available & ~done_reading_memory_reg) begin
              state_next = REQ_MEM;
              mem_req_b_next = 1'b0;
            end else begin
              smem_addr_next = smem_addr + 15'h0001;
              state_next = PROCESS_INSTR;
            end
            smem_ceb_next = 1'b1;
            smem_web_next = 1'b1;
          end
        POP_FROM_STACK:
          begin
          state_next = PROCESS_STACK;
//             if (stack_is_empty) begin
//               state_next = PROCESS_STACK;
//               smem_ceb_next = 1'b1;
//             end
          end
        PROCESS_STACK:
          begin
            state_next = DONE;
//            if (stack_is_empty) begin
//              state_next = DONE;
//              bits_value_next = smem_rdata[63:0];
//            end
          end
        DONE:
          begin
             state_next = DONE;
             done_next = 1'b1;
          end
     endcase
  end

always @(posedge clk or negedge resetB)
  begin
    if (~resetB) begin
       smem_ceb <= 1'b1;
       smem_web <= 1'b1;
       smem_addr <= 14'h0;
       smem_wdata <= 95'h0;
       done <= 1'b0;
       bits_value <= 64'h0;
       version_sum <= 16'h0;
       encoded_number <= 80'h0;
       decodeNumber <= 1'b0;
       state <= IDLE;
       mem_req_b <= 1'b1;
       done_reading_memory_reg <= 1'b0;
       instruction_process <= 5'h1f;
       parent_packet_id = 15'h0;
       this_packet_id = 15'h0;
       literal_packet_reg <= 1'b0;
       operator_packet_type_reg <= 1'b0;
    end
    else begin
       smem_ceb <= smem_ceb_next;
       smem_web <= smem_web_next;
       smem_addr <= smem_addr_next;
       smem_wdata <= smem_wdata_next;
       done <= done_next;
       bits_value <= bits_value_next;
       version_sum <= version_sum_next;
       encoded_number <= encoded_number_next;
       decodeNumber <= decodeNumber_next;
       state <= state_next;
       mem_req_b <= mem_req_b_next;
       done_reading_memory_reg <= done_reading_memory || done_reading_memory_reg;
       instruction_process <= instruction_process_next;
       parent_packet_id <= parent_packet_id_next;
       this_packet_id <= this_packet_id_next;
       literal_packet_reg <= literal_packet_reg_next;
       operator_packet_type_reg <= operator_packet_type_next;
    end
  end

endmodule