module number_decoder(
   //output
   next_nibble_valid,
   nibble,

   //input
   code,
   this_nibble_valid
);

output next_nibble_valid;
output[3:0] nibble;

input[4:0] code;
input this_nibble_valid;

assign next_nibble_valid = code[4] & this_nibble_valid;
assign nibble = code[3:0] & {4{this_nibble_valid}};


endmodule
