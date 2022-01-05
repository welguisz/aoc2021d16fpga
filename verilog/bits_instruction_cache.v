module bits_instruction_cache(
   //instruction cache
   instruction_cache,
   space_available,
   bit_counter,

   //inputs
   clk,
   resetB,

   //imem_controller
   mem_req_b,
   mem_ack_b,
   instruction_word,
   valid_bytes,

   //bits_fsm
   instruction_process
);

output [255:0] instruction_cache;
output         space_available;
output [15:0]  bit_counter;

input          clk;
input          resetB;

input          mem_req_b;
input          mem_ack_b;
input[127:0]   instruction_word;
input[15:0]    valid_bytes;

// There are 18 different bit positions to move
// Literal Value, 1 nibble wide:   11 bits (00000)
// Literal Value, 2 nibble wides:  16 bits (00001)
// Literal Value, 3 nibble wides:  21 bits (00010)
// Literal Value, 4 nibble wides:  26 bits (00011)
// Literal Value, 5 nibble wides:  31 bits (00100)
// Literal Value, 6 nibble wides:  36 bits (00101)
// Literal Value, 7 nibble wides:  41 bits (00110)
// Literal Value, 8 nibble wides:  46 bits (00111)
// Literal Value, 9 nibble wides:  51 bits (01000)
// Literal Value, 10 nibble wides: 56 bits (01001)
// Literal Value, 11 nibble wides: 61 bits (01010)
// Literal Value, 12 nibble wides: 66 bits (01011)
// Literal Value, 13 nibble wides: 71 bits (01100)
// Literal Value, 14 nibble wides: 76 bits (01101)
// Literal Value, 15 nibble wides: 81 bits (01110)
// Literal Value, 16 nibble wides: 86 bits (01111)
// Operator, type 1: 22 bits (10000)
// Operator, type 2: 18 bits (10001)
input [4:0]    instruction_process;

reg[255:0]     instruction_cache;
reg[255:0]     instruction_cache_next;

reg [2:0]      state;
reg [2:0]      state_next;
reg [8:0]      instruction_size;
reg [8:0]      instruction_size_next;
reg [15:0]     bit_counter;
reg [15:0]     bit_counter_next;
wire           space_available;

parameter IDLE = 3'b000;

assign         space_available = (instruction_size <= 8'h80);

reg[4:0] instruction_size_read;

always @(valid_bytes)
  begin
     instruction_size_read = valid_bytes[15] + valid_bytes[14] + valid_bytes[13] + valid_bytes[12] +
        valid_bytes[11] + valid_bytes[10] + valid_bytes[9] + valid_bytes[8] + valid_bytes[7] +
        valid_bytes[6] + valid_bytes[5] + valid_bytes[4] + valid_bytes[3] + valid_bytes[2] +
        valid_bytes[1] + valid_bytes[0];
  end

always @(instruction_cache or instruction_process or mem_req_b or mem_ack_b or instruction_word
         or instruction_size_read or bit_counter)
  begin
     instruction_cache_next = instruction_cache;
     instruction_size_next = instruction_size;
     bit_counter_next = bit_counter;
     if (instruction_process < 5'h12) begin
        case (instruction_process)
           5'h00 :
             begin
               instruction_cache_next = {instruction_cache[244:0],11'h0};
               instruction_size_next = instruction_size - 8'h0b;
               bit_counter_next = bit_counter + 16'h000b;
             end
           5'h01 :
             begin
               instruction_cache_next = {instruction_cache[239:0],16'h0};
               instruction_size_next = instruction_size - 8'h10;
               bit_counter_next = bit_counter + 16'h0010;
             end
           5'h02 :
             begin
               instruction_cache_next = {instruction_cache[234:0],21'h0};
               instruction_size_next = instruction_size - 8'h15;
               bit_counter_next = bit_counter + 16'h0015;
             end
           5'h03 :
             begin
               instruction_cache_next = {instruction_cache[229:0],26'h0};
               instruction_size_next = instruction_size - 8'h1a;
               bit_counter_next = bit_counter + 16'h001a;
             end
           5'h04 :
             begin
               instruction_cache_next = {instruction_cache[224:0],31'h0};
               instruction_size_next = instruction_size - 8'h1f;
               bit_counter_next = bit_counter + 16'h001f;
             end
           5'h05 :
             begin
               instruction_cache_next = {instruction_cache[219:0],36'h0};
               instruction_size_next = instruction_size - 8'h24;
               bit_counter_next = bit_counter + 16'h0024;
             end
           5'h06 :
             begin
               instruction_cache_next = {instruction_cache[214:0],41'h0};
               instruction_size_next = instruction_size - 8'h29;
               bit_counter_next = bit_counter + 16'h0029;
             end
           5'h07 :
             begin
               instruction_cache_next = {instruction_cache[209:0],46'h0};
               instruction_size_next = instruction_size - 8'h2e;
               bit_counter_next = bit_counter + 16'h002e;
             end
           5'h08 :
             begin
               instruction_cache_next = {instruction_cache[204:0],51'h0};
               instruction_size_next = instruction_size - 8'h33;
               bit_counter_next = bit_counter + 16'h0033;
             end
           5'h09 :
             begin
               instruction_cache_next = {instruction_cache[199:0],56'h0};
               instruction_size_next = instruction_size - 8'h38;
               bit_counter_next = bit_counter + 16'h0038;
             end
           5'h0a :
             begin
               instruction_cache_next = {instruction_cache[194:0],61'h0};
               instruction_size_next = instruction_size - 8'h3d;
               bit_counter_next = bit_counter + 16'h003d;
             end
           5'h0b :
             begin
               instruction_cache_next = {instruction_cache[189:0],66'h0};
               instruction_size_next = instruction_size - 8'h42;
               bit_counter_next = bit_counter + 16'h0042;
             end
           5'h0c :
             begin
               instruction_cache_next = {instruction_cache[184:0],71'h0};
               instruction_size_next = instruction_size - 8'h47;
               bit_counter_next = bit_counter + 16'h0047;
             end
           5'h0d :
             begin
               instruction_cache_next = {instruction_cache[179:0],76'h0};
               instruction_size_next = instruction_size - 8'h4c;
               bit_counter_next = bit_counter + 16'h004c;
             end
           5'h0e :
             begin
               instruction_cache_next = {instruction_cache[174:0],81'h0};
               instruction_size_next = instruction_size - 8'h51;
               bit_counter_next = bit_counter + 16'h0051;
             end
           5'h0f :
             begin
               instruction_cache_next = {instruction_cache[169:0],86'h0};
               instruction_size_next = instruction_size - 8'h56;
               bit_counter_next = bit_counter + 16'h0056;
             end
           5'h10 :
             begin
               instruction_cache_next = {instruction_cache[233:0],22'h0};
               instruction_size_next = instruction_size - 8'h16;
               bit_counter_next = bit_counter + 16'h0016;
             end
           5'h11 :
             begin
               instruction_cache_next = {instruction_cache[237:0],18'h0};
               instruction_size_next = instruction_size - 8'h12;
               bit_counter_next = bit_counter + 16'h0012;
             end
        endcase
     end
     else if (!mem_req_b & !mem_ack_b) begin
        case(instruction_size)
           9'h00 :
             begin
               instruction_cache_next = {instruction_word,128'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h01 :
             begin
               instruction_cache_next = {instruction_cache[255], instruction_word,127'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h02 :
             begin
               instruction_cache_next = {instruction_cache[255:254], instruction_word,126'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h03 :
             begin
               instruction_cache_next = {instruction_cache[255:253], instruction_word,125'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h04 :
             begin
               instruction_cache_next = {instruction_cache[255:252], instruction_word,124'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h05 :
             begin
               instruction_cache_next = {instruction_cache[255:251], instruction_word,123'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h06 :
             begin
               instruction_cache_next = {instruction_cache[255:250], instruction_word,122'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h07 :
             begin
               instruction_cache_next = {instruction_cache[255:249], instruction_word,121'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h08 :
             begin
               instruction_cache_next = {instruction_cache[255:248], instruction_word,120'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h09 :
             begin
               instruction_cache_next = {instruction_cache[255:247], instruction_word,119'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h0A :
             begin
               instruction_cache_next = {instruction_cache[255:246], instruction_word,118'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h0B :
             begin
               instruction_cache_next = {instruction_cache[255:245], instruction_word,117'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h0C :
             begin
               instruction_cache_next = {instruction_cache[255:244], instruction_word,116'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h0D :
             begin
               instruction_cache_next = {instruction_cache[255:243], instruction_word,115'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h0E :
             begin
               instruction_cache_next = {instruction_cache[255:242], instruction_word,114'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h0F :
             begin
               instruction_cache_next = {instruction_cache[255:241], instruction_word,113'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h10 :
             begin
               instruction_cache_next = {instruction_cache[255:240], instruction_word,112'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h11 :
             begin
               instruction_cache_next = {instruction_cache[255:239], instruction_word,111'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h12 :
             begin
               instruction_cache_next = {instruction_cache[255:238], instruction_word,110'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h13 :
             begin
               instruction_cache_next = {instruction_cache[255:237], instruction_word,109'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h14 :
             begin
               instruction_cache_next = {instruction_cache[255:236], instruction_word,108'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h15 :
             begin
               instruction_cache_next = {instruction_cache[255:235], instruction_word,107'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h16 :
             begin
               instruction_cache_next = {instruction_cache[255:234], instruction_word,106'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h17 :
             begin
               instruction_cache_next = {instruction_cache[255:233], instruction_word,105'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h18 :
             begin
               instruction_cache_next = {instruction_cache[255:232], instruction_word,104'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h19 :
             begin
               instruction_cache_next = {instruction_cache[255:231], instruction_word,103'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h1A :
             begin
               instruction_cache_next = {instruction_cache[255:230], instruction_word,102'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h1B :
             begin
               instruction_cache_next = {instruction_cache[255:229], instruction_word,101'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h1C :
             begin
               instruction_cache_next = {instruction_cache[255:228], instruction_word,100'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h1D :
             begin
               instruction_cache_next = {instruction_cache[255:227], instruction_word,99'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h1E :
             begin
               instruction_cache_next = {instruction_cache[255:226], instruction_word,98'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h1F :
             begin
               instruction_cache_next = {instruction_cache[255:225], instruction_word,97'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h20 :
             begin
               instruction_cache_next = {instruction_cache[255:224], instruction_word,96'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h21 :
             begin
               instruction_cache_next = {instruction_cache[255:223], instruction_word,95'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h22 :
             begin
               instruction_cache_next = {instruction_cache[255:222], instruction_word,94'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h23 :
             begin
               instruction_cache_next = {instruction_cache[255:221], instruction_word,93'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h24 :
             begin
               instruction_cache_next = {instruction_cache[255:220], instruction_word,92'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h25 :
             begin
               instruction_cache_next = {instruction_cache[255:219], instruction_word,91'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h26 :
             begin
               instruction_cache_next = {instruction_cache[255:218], instruction_word,90'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h27 :
             begin
               instruction_cache_next = {instruction_cache[255:217], instruction_word,89'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h28 :
             begin
               instruction_cache_next = {instruction_cache[255:216], instruction_word,88'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h29 :
             begin
               instruction_cache_next = {instruction_cache[255:215], instruction_word,87'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h2A :
             begin
               instruction_cache_next = {instruction_cache[255:214], instruction_word,86'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h2B :
             begin
               instruction_cache_next = {instruction_cache[255:213], instruction_word,85'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h2C :
             begin
               instruction_cache_next = {instruction_cache[255:212], instruction_word,84'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h2D :
             begin
               instruction_cache_next = {instruction_cache[255:211], instruction_word,83'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h2E :
             begin
               instruction_cache_next = {instruction_cache[255:210], instruction_word,82'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h2F :
             begin
               instruction_cache_next = {instruction_cache[255:209], instruction_word,81'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h30 :
             begin
               instruction_cache_next = {instruction_cache[255:208], instruction_word,80'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h31 :
             begin
               instruction_cache_next = {instruction_cache[255:207], instruction_word,79'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h32 :
             begin
               instruction_cache_next = {instruction_cache[255:206], instruction_word,78'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h33 :
             begin
               instruction_cache_next = {instruction_cache[255:205], instruction_word,77'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h34 :
             begin
               instruction_cache_next = {instruction_cache[255:204], instruction_word,76'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h35 :
             begin
               instruction_cache_next = {instruction_cache[255:203], instruction_word,75'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h36 :
             begin
               instruction_cache_next = {instruction_cache[255:202], instruction_word,74'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h37 :
             begin
               instruction_cache_next = {instruction_cache[255:201], instruction_word,73'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h38 :
             begin
               instruction_cache_next = {instruction_cache[255:200], instruction_word,72'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h39 :
             begin
               instruction_cache_next = {instruction_cache[255:199], instruction_word,71'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h3A :
             begin
               instruction_cache_next = {instruction_cache[255:198], instruction_word,70'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h3B :
             begin
               instruction_cache_next = {instruction_cache[255:197], instruction_word,69'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h3C :
             begin
               instruction_cache_next = {instruction_cache[255:196], instruction_word,68'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h3D :
             begin
               instruction_cache_next = {instruction_cache[255:195], instruction_word,67'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h3E :
             begin
               instruction_cache_next = {instruction_cache[255:194], instruction_word,66'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h3F :
             begin
               instruction_cache_next = {instruction_cache[255:193], instruction_word,65'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h40 :
             begin
               instruction_cache_next = {instruction_cache[255:192], instruction_word,64'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h41 :
             begin
               instruction_cache_next = {instruction_cache[255:191], instruction_word,63'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h42 :
             begin
               instruction_cache_next = {instruction_cache[255:190], instruction_word,62'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h43 :
             begin
               instruction_cache_next = {instruction_cache[255:189], instruction_word,61'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h44 :
             begin
               instruction_cache_next = {instruction_cache[255:188], instruction_word,60'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h45 :
             begin
               instruction_cache_next = {instruction_cache[255:187], instruction_word,59'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h46 :
             begin
               instruction_cache_next = {instruction_cache[255:186], instruction_word,58'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h47 :
             begin
               instruction_cache_next = {instruction_cache[255:185], instruction_word,57'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h48 :
             begin
               instruction_cache_next = {instruction_cache[255:184], instruction_word,56'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h49 :
             begin
               instruction_cache_next = {instruction_cache[255:183], instruction_word,55'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h4A :
             begin
               instruction_cache_next = {instruction_cache[255:182], instruction_word,54'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h4B :
             begin
               instruction_cache_next = {instruction_cache[255:181], instruction_word,53'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h4C :
             begin
               instruction_cache_next = {instruction_cache[255:180], instruction_word,52'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h4D :
             begin
               instruction_cache_next = {instruction_cache[255:179], instruction_word,51'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h4E :
             begin
               instruction_cache_next = {instruction_cache[255:178], instruction_word,50'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h4F :
             begin
               instruction_cache_next = {instruction_cache[255:177], instruction_word,49'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h50 :
             begin
               instruction_cache_next = {instruction_cache[255:176], instruction_word,48'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h51 :
             begin
               instruction_cache_next = {instruction_cache[255:175], instruction_word,47'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h52 :
             begin
               instruction_cache_next = {instruction_cache[255:174], instruction_word,46'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h53 :
             begin
               instruction_cache_next = {instruction_cache[255:173], instruction_word,45'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h54 :
             begin
               instruction_cache_next = {instruction_cache[255:172], instruction_word,44'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h55 :
             begin
               instruction_cache_next = {instruction_cache[255:171], instruction_word,43'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h56 :
             begin
               instruction_cache_next = {instruction_cache[255:170], instruction_word,42'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h57 :
             begin
               instruction_cache_next = {instruction_cache[255:169], instruction_word,41'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h58 :
             begin
               instruction_cache_next = {instruction_cache[255:168], instruction_word,40'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h59 :
             begin
               instruction_cache_next = {instruction_cache[255:167], instruction_word,39'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h5A :
             begin
               instruction_cache_next = {instruction_cache[255:166], instruction_word,38'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h5B :
             begin
               instruction_cache_next = {instruction_cache[255:165], instruction_word,37'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h5C :
             begin
               instruction_cache_next = {instruction_cache[255:164], instruction_word,36'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h5D :
             begin
               instruction_cache_next = {instruction_cache[255:163], instruction_word,35'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h5E :
             begin
               instruction_cache_next = {instruction_cache[255:162], instruction_word,34'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h5F :
             begin
               instruction_cache_next = {instruction_cache[255:161], instruction_word,33'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h60 :
             begin
               instruction_cache_next = {instruction_cache[255:160], instruction_word,32'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h61 :
             begin
               instruction_cache_next = {instruction_cache[255:159], instruction_word,31'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h62 :
             begin
               instruction_cache_next = {instruction_cache[255:158], instruction_word,30'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h63 :
             begin
               instruction_cache_next = {instruction_cache[255:157], instruction_word,29'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h64 :
             begin
               instruction_cache_next = {instruction_cache[255:156], instruction_word,28'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h65 :
             begin
               instruction_cache_next = {instruction_cache[255:155], instruction_word,27'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h66 :
             begin
               instruction_cache_next = {instruction_cache[255:154], instruction_word,26'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h67 :
             begin
               instruction_cache_next = {instruction_cache[255:153], instruction_word,25'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h68 :
             begin
               instruction_cache_next = {instruction_cache[255:152], instruction_word,24'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h69 :
             begin
               instruction_cache_next = {instruction_cache[255:151], instruction_word,23'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h6A :
             begin
               instruction_cache_next = {instruction_cache[255:150], instruction_word,22'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h6B :
             begin
               instruction_cache_next = {instruction_cache[255:149], instruction_word,21'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h6C :
             begin
               instruction_cache_next = {instruction_cache[255:148], instruction_word,20'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h6D :
             begin
               instruction_cache_next = {instruction_cache[255:147], instruction_word,19'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h6E :
             begin
               instruction_cache_next = {instruction_cache[255:146], instruction_word,18'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h6F :
             begin
               instruction_cache_next = {instruction_cache[255:145], instruction_word,17'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h70 :
             begin
               instruction_cache_next = {instruction_cache[255:144], instruction_word,16'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h71 :
             begin
               instruction_cache_next = {instruction_cache[255:143], instruction_word,15'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h72 :
             begin
               instruction_cache_next = {instruction_cache[255:142], instruction_word,14'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h73 :
             begin
               instruction_cache_next = {instruction_cache[255:141], instruction_word,13'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h74 :
             begin
               instruction_cache_next = {instruction_cache[255:140], instruction_word,12'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h75 :
             begin
               instruction_cache_next = {instruction_cache[255:139], instruction_word,11'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h76 :
             begin
               instruction_cache_next = {instruction_cache[255:138], instruction_word,10'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h77 :
             begin
               instruction_cache_next = {instruction_cache[255:137], instruction_word,9'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h78 :
             begin
               instruction_cache_next = {instruction_cache[255:136], instruction_word,8'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h79 :
             begin
               instruction_cache_next = {instruction_cache[255:135], instruction_word,7'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h7A :
             begin
               instruction_cache_next = {instruction_cache[255:134], instruction_word,6'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h7B :
             begin
               instruction_cache_next = {instruction_cache[255:133], instruction_word,5'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h7C :
             begin
               instruction_cache_next = {instruction_cache[255:132], instruction_word,4'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h7D :
             begin
               instruction_cache_next = {instruction_cache[255:131], instruction_word,3'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h7E :
             begin
               instruction_cache_next = {instruction_cache[255:130], instruction_word,2'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           9'h7F :
             begin
               instruction_cache_next = {instruction_cache[255:129], instruction_word,1'h0};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
           default :
             begin
               instruction_cache_next = {instruction_cache[255:128], instruction_word};
               instruction_size_next = instruction_size + {instruction_size_read[4:0],3'b000};
             end
        endcase
     end
  end

always @(posedge clk or negedge resetB)
  begin
    if (~resetB) begin
       instruction_cache <= 256'h0;
       state <= IDLE;
       instruction_size <= 9'h000;
       bit_counter <= 16'h0;
    end
    else begin
       instruction_cache <= instruction_cache_next;
       state <= state_next;
       instruction_size <= instruction_size_next;
       bit_counter <= bit_counter_next;
    end
  end

endmodule