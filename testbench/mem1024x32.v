module mem1024x32(
   //output
   rdata,

   //input
   clk,
   ceb,
   web,
   addr,
   wdata
);

output[31:0] rdata;

input clk;
input ceb;
input web;
input[9:0] addr;
input[31:0] wdata;

initial begin
  $readmemh("memory.mem", mem);
end

reg[31:0] mem[0:1023];
reg[31:0] rdata;

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