module number_test();

wire[63:0] number;
reg clk;
reg resetB;
reg enable;
reg[79:0] numberFromBits;

reg failed = 1'b0;

//Get some waveforms
initial begin
   $dumpfile("number.vcd");
   $dumpvars(0,number_test);
end

initial begin
   clk = 1'b0;
   failed = 1'b0;
end


//generate clk;
always
   begin
      #5 clk = ~clk;
   end

//reset sequence
initial begin
   #3 resetB = 1'b1;
   #12 resetB = 1'b0;
   #100 resetB = 1'b1;
end

//some numbers
initial begin
  numberFromBits = 80'h0;
  enable = 1'b0;
  #150
  numberFromBits = 80'h7800_0000_0000_0000_0000;
  enable = 1'b1;
  #10 enable = 1'b0;
  numberFromBits = 80'h87ff_ffff_ffff_ffff_ffff;
  #2 enable = 1'b0;
  if (number != 64'h0000_0000_0000_000f) begin
      failed = 1'b1;
  end
  #20
  numberFromBits = 80'h8fff_ffff_ffff_ffff_ffff;
  enable = 1'b1;
  #10 enable = 1'b0;
  #2 enable = 1'b0;
  if (number != 64'h1fff_ffff_ffff_ffff) begin
     failed = 1'b1;
  end
  $finish;
end

number_top number_top(
     //output
     .number (number),

     //input
     .clk (clk),
     .resetB (resetB),
     .enable (enable),
     .numberFromBits (numberFromBits)
);

endmodule