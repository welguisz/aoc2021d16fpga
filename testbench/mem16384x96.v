module mem16384x96(
   //output
   rdata,

   //input
   clk,
   ceb,
   web,
   addr,
   wdata
);

output[95:0] rdata;

input clk;
input ceb;
input web;
input[13:0] addr;
input[95:0] wdata;

reg[95:0] mem[0:16383];
reg[95:0] rdata;


//Write Cycle
always @(posedge clk)
   begin
      if (!ceb & !web)
         begin
            mem[addr] <= wdata;
         end
   end

always @(posedge clk)
   begin
       if (!ceb & web)
          begin
             rdata <= mem[addr];
          end
   end

endmodule