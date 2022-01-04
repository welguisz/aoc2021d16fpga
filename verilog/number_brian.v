module number_brian(
   //output
   number,
   bitsToShift,

   //input
   clk,
   resetB,
   enable,
   validNibbles,
   inputNumber
);

output [63:0] number;
output [6:0] bitsToShift;

input clk;
input resetB;
input enable;
input [16:0] validNibbles;
input [63:0] inputNumber;


wire [63:0] oneNibbleEnabled;
wire [63:0] twoNibblesEnabled;
wire [63:0] threeNibblesEnabled;
wire [63:0] fourNibblesEnabled;
wire [63:0] fiveNibblesEnabled;
wire [63:0] sixNibblesEnabled;
wire [63:0] sevenNibblesEnabled;
wire [63:0] eightNibblesEnabled;
wire [63:0] nineNibblesEnabled;
wire [63:0] tenNibblesEnabled;
wire [63:0] elevenNibblesEnabled;
wire [63:0] twelveNibblesEnabled;
wire [63:0] thirteenNibblesEnabled;
wire [63:0] fourteenNibblesEnabled;
wire [63:0] fifteenNibblesEnabled;
wire [63:0] sixteenNibblesEnabled;

reg [63:0] dataNext;
reg[63:0] number;
reg [6:0] bitsToShift;
reg [6:0] bitsToShiftNext;

assign oneNibbleEnabled = {60'h0,inputNumber[63:60]};
assign twoNibblesEnabled = {56'h0,inputNumber[63:56]};
assign threeNibblesEnabled = {52'h0,inputNumber[63:52]};
assign fourNibblesEnabled = {48'h0,inputNumber[63:48]};
assign fiveNibblesEnabled = {44'h0,inputNumber[63:44]};
assign sixNibblesEnabled = {40'h0,inputNumber[63:40]};
assign sevenNibblesEnabled = {36'h0,inputNumber[63:36]};
assign eightNibblesEnabled = {32'h0,inputNumber[63:32]};
assign nineNibblesEnabled = {28'h0,inputNumber[63:28]};
assign tenNibblesEnabled = {24'h0,inputNumber[63:24]};
assign elevenNibblesEnabled = {20'h0,inputNumber[63:20]};
assign twelveNibblesEnabled = {16'h0,inputNumber[63:16]};
assign thirteenNibblesEnabled = {12'h0,inputNumber[63:12]};
assign fourteenNibblesEnabled = {8'h0,inputNumber[63:8]};
assign fifteenNibblesEnabled = {4'h0,inputNumber[63:4]};
assign sixteenNibblesEnabled = inputNumber[63:0];

always @(validNibbles or oneNibbleEnabled or twoNibblesEnabled or
         threeNibblesEnabled or fourNibblesEnabled or fiveNibblesEnabled or
         sixNibblesEnabled or sevenNibblesEnabled or eightNibblesEnabled or
         nineNibblesEnabled or tenNibblesEnabled or elevenNibblesEnabled or
         twelveNibblesEnabled or thirteenNibblesEnabled or fourteenNibblesEnabled
         or fifteenNibblesEnabled or sixteenNibblesEnabled)
   begin
       dataNext = oneNibbleEnabled;
       bitsToShiftNext = 7'h5;
       if (validNibbles[15]) begin
          dataNext = sixteenNibblesEnabled;
          bitsToShiftNext = 7'h50;
       end
       else if (validNibbles[14]) begin
          dataNext = fifteenNibblesEnabled;
          bitsToShiftNext = 7'h4b;
       end
       else if (validNibbles[13]) begin
          dataNext = fourteenNibblesEnabled;
          bitsToShiftNext = 7'h46;
       end
       else if (validNibbles[12]) begin
          dataNext = thirteenNibblesEnabled;
          bitsToShiftNext = 7'h41;
       end
       else if (validNibbles[11]) begin
          dataNext = twelveNibblesEnabled;
          bitsToShiftNext = 7'h3c;
       end
       else if (validNibbles[10]) begin
          dataNext = elevenNibblesEnabled;
          bitsToShiftNext = 7'h37;
       end
       else if (validNibbles[9]) begin
          dataNext = tenNibblesEnabled;
          bitsToShiftNext = 7'h32;
       end
       else if (validNibbles[8]) begin
          dataNext = nineNibblesEnabled;
          bitsToShiftNext = 7'h2D;
       end
       else if (validNibbles[7]) begin
          dataNext = eightNibblesEnabled;
          bitsToShiftNext = 7'h28;
       end
       else if (validNibbles[6]) begin
          dataNext = sevenNibblesEnabled;
          bitsToShiftNext = 7'h23;
       end
       else if (validNibbles[5]) begin
          dataNext = sixNibblesEnabled;
          bitsToShiftNext = 7'h1E;
       end
       else if (validNibbles[4]) begin
          dataNext = fiveNibblesEnabled;
          bitsToShiftNext = 7'h19;
       end
       else if (validNibbles[3]) begin
          dataNext = fourNibblesEnabled;
          bitsToShiftNext = 7'h14;
       end
       else if (validNibbles[2]) begin
          dataNext = threeNibblesEnabled;
          bitsToShiftNext = 7'h0F;
       end
       else if (validNibbles[1]) begin
          dataNext = twoNibblesEnabled;
          bitsToShiftNext = 7'h0A;
       end
       else if (validNibbles[0]) begin
          dataNext = oneNibbleEnabled;
          bitsToShiftNext = 7'h05;
       end
   end


always @(posedge clk or negedge resetB)
  begin
     if (~resetB) begin
         number <= 64'h0;
         bitsToShift <= 7'h0;
     end
     else begin
        if (enable) begin
           number <= dataNext;
           bitsToShift <= bitsToShiftNext;
        end
     end
  end

endmodule