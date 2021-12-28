module number_brian(
   //output
   number,

   //input
   clk,
   resetB,
   enable,
   validNibbles,
   inputNumber
);

output [63:0] number;

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
       if (validNibbles[15])
          dataNext = sixteenNibblesEnabled;
       else if (validNibbles[14])
          dataNext = fifteenNibblesEnabled;
       else if (validNibbles[13])
          dataNext = fourteenNibblesEnabled;
       else if (validNibbles[12])
          dataNext = thirteenNibblesEnabled;
       else if (validNibbles[11])
          dataNext = twelveNibblesEnabled;
       else if (validNibbles[10])
          dataNext = elevenNibblesEnabled;
       else if (validNibbles[9])
          dataNext = tenNibblesEnabled;
       else if (validNibbles[8])
          dataNext = nineNibblesEnabled;
       else if (validNibbles[7])
          dataNext = eightNibblesEnabled;
       else if (validNibbles[6])
          dataNext = sevenNibblesEnabled;
       else if (validNibbles[5])
          dataNext = sixNibblesEnabled;
       else if (validNibbles[4])
          dataNext = fiveNibblesEnabled;
       else if (validNibbles[3])
          dataNext = fourNibblesEnabled;
       else if (validNibbles[2])
          dataNext = threeNibblesEnabled;
       else if (validNibbles[1])
          dataNext = twoNibblesEnabled;
       else if (validNibbles[0])
          dataNext = oneNibbleEnabled;
   end


always @(posedge clk or negedge resetB)
  begin
     if (~resetB) begin
         number <= 64'h0;
     end
     else begin
        if (enable) begin
           number <= dataNext;
        end
     end
  end

endmodule