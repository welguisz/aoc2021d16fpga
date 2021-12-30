// This is an external RAM that might be hooked up.  It is 4 MB set up in 512K words x 8 bits per word
// PDF: https://www.mouser.com/datasheet/2/100/CYPRS13582_1-2540405.pdf

module cy62148E(
    //inout
    data,

    //input
    ce_b,
    we_b,
    oe_b,
    addr
);

inout [7:0] data;

input ce_b;
input we_b;
input oe_b;
input [18:0] addr;

reg[7:0] mem[0:514288];
reg[7:0] tmp_data;


//Internal clock (running at 100 MHz)
reg clk;
initial
   begin
      clk <= 1'b0;
   end

always
   begin
      #5 clk = !clk;
   end

//Read Cycle Time: 45 ns
// Address to Data Valid: 45 ns
// Data hold from Address change: 10 ns


//Write Cycle
always @(posedge clk)
   begin
      if (!ce_b & !we_b)
         begin
            mem[addr] <= data;
         end
   end

always @(posedge clk)
   begin
       if (!ce_b & !oe_b)
          begin
             tmp_data <= mem[addr];
          end
   end

assign data = !ce_b & !oe_b & we_b ? tmp_data : 8'hz;

endmodule
