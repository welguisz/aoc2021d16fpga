module number_top(
     //output
     number,

     //input
     clk,
     resetB,
     enable,
     numberFromBits,
);

output [63:0] number;
input clk;
input resetB;
input enable;
input [79:0] numberFromBits;

wire[15:0] nibbleChain;
wire[63:0] data;

number_brian number_brian(
   //output
   .number (number),

   //input
   .clk (clk),
   .resetB (resetB),
   .enable (enable),
   .validNibbles ({nibbleChain,1'b1}),
   .inputNumber (data)
);

number_decoder number_decoder_nibble15(
    .next_nibble_valid (nibbleChain[15]),
    .nibble(data[63:60]),

    .code(numberFromBits[79:75]),
    .this_nibble_valid(1'b1)
);

number_decoder number_decoder_nibble14(
    .next_nibble_valid (nibbleChain[14]),
    .nibble(data[59:56]),

    .code(numberFromBits[74:70]),
    .this_nibble_valid(nibbleChain[15])
);

number_decoder number_decoder_nibble13(
    .next_nibble_valid (nibbleChain[13]),
    .nibble(data[55:52]),

    .code(numberFromBits[69:65]),
    .this_nibble_valid(nibbleChain[14])
);

number_decoder number_decoder_nibble12(
    .next_nibble_valid (nibbleChain[12]),
    .nibble(data[51:48]),

    .code(numberFromBits[64:60]),
    .this_nibble_valid(nibbleChain[13])
);

number_decoder number_decoder_nibble11(
    .next_nibble_valid (nibbleChain[11]),
    .nibble(data[47:44]),

    .code(numberFromBits[59:55]),
    .this_nibble_valid(nibbleChain[12])
);

number_decoder number_decoder_nibble10(
    .next_nibble_valid (nibbleChain[10]),
    .nibble(data[43:40]),

    .code(numberFromBits[54:50]),
    .this_nibble_valid(nibbleChain[11])
);

number_decoder number_decoder_nibble09(
    .next_nibble_valid (nibbleChain[9]),
    .nibble(data[39:36]),

    .code(numberFromBits[49:45]),
    .this_nibble_valid(nibbleChain[10])
);

number_decoder number_decoder_nibble08(
    .next_nibble_valid (nibbleChain[8]),
    .nibble(data[35:32]),

    .code(numberFromBits[44:40]),
    .this_nibble_valid(nibbleChain[9])
);

number_decoder number_decoder_nibble07(
    .next_nibble_valid (nibbleChain[7]),
    .nibble(data[31:28]),

    .code(numberFromBits[39:35]),
    .this_nibble_valid(nibbleChain[8])
);

number_decoder number_decoder_nibble06(
    .next_nibble_valid (nibbleChain[6]),
    .nibble(data[27:24]),

    .code(numberFromBits[34:30]),
    .this_nibble_valid(nibbleChain[7])
);

number_decoder number_decoder_nibble05(
    .next_nibble_valid (nibbleChain[5]),
    .nibble(data[23:20]),

    .code(numberFromBits[29:25]),
    .this_nibble_valid(nibbleChain[6])
);

number_decoder number_decoder_nibble04(
    .next_nibble_valid (nibbleChain[4]),
    .nibble(data[19:16]),

    .code(numberFromBits[24:20]),
    .this_nibble_valid(nibbleChain[5])
);

number_decoder number_decoder_nibble3(
    .next_nibble_valid (nibbleChain[3]),
    .nibble(data[15:12]),

    .code(numberFromBits[19:15]),
    .this_nibble_valid(nibbleChain[4])
);

number_decoder number_decoder_nibble02(
    .next_nibble_valid (nibbleChain[2]),
    .nibble(data[11:8]),

    .code(numberFromBits[14:10]),
    .this_nibble_valid(nibbleChain[3])
);

number_decoder number_decoder_nibble01(
    .next_nibble_valid (nibbleChain[1]),
    .nibble(data[7:4]),

    .code(numberFromBits[9:5]),
    .this_nibble_valid(nibbleChain[2])
);

number_decoder number_decoder_nibble00(
    .next_nibble_valid (nibbleChain[0]),
    .nibble(data[3:0]),

    .code(numberFromBits[4:0]),
    .this_nibble_valid(nibbleChain[1])
);


endmodule