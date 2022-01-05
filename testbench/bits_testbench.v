`timescale 1ns/1ns

module bits_testbench();

wire clk;
wire resetB;
wire [7:0]   paddr;
wire         pwrite;
wire         psel;
wire         penable;
wire [31:0]  pwdata;
wire [31:0] prdata;

wire imem_ceb;
wire imem_web;
wire[9:0] imem_addr;
wire[31:0] imem_rdata;

wire smem_ceb;
wire smem_web;
wire[13:0] smem_addr;
wire[95:0] smem_wdata;
wire[95:0] smem_rdata;

bits_top bits_top(
    //outputs
    // -- AMBA Peripheral Bus Signals
    .pready (),
    .prdata (prdata),
    .pslverr(),

    // -- Instruction Memory
    .imem_ceb (imem_ceb),
    .imem_web (imem_web),
    .imem_addr (imem_addr),

    // -- Stack Memory
    .smem_ceb (smem_ceb),
    .smem_web (smem_web),
    .smem_addr (smem_addr),
    .smem_wdata (smem_wdata),

    //inputs
    // -- System Inputs
    .clk (clk),
    .resetB (resetB),

    // -- AMBA Peripheral Bus Signals
    .paddr (paddr[7:2]),
    .psel (psel),
    .penable (penable),
    .pwrite (pwrite),
    .pwdata (pwdata),
    // -- Instruction Memory
    .imem_rdata (imem_rdata),
    //--Stack Memory
    .smem_rdata(smem_rdata)
);

mem1024x32 imem(
   //output
   .rdata (imem_rdata),

   //input
   .clk (clk),
   .ceb (imem_ceb),
   .web (imem_web),
   .addr (imem_addr),
   .wdata (32'h0)
);

mem16384x96 smem(
   .rdata(smem_rdata),

   .clk(clk),
   .ceb(smem_ceb),
   .web(smem_web),
   .addr(smem_addr),
   .wdata(smem_wdata)
);

clk_generator clk_generator(
   .clk (clk)
);

reset_generator reset_generator(
   .resetB(resetB),
   .clk(clk)
);

apb_driver apb_driver(
   //outputs
   .paddr (paddr),
   .pwrite (pwrite),
   .psel  (psel),
   .penable (penable),
   .pwdata (pwdata),

   //inputs
   .clk (clk),
   .prdata (prdata)
);

wire[31:0] expectedBytes;
assign expectedBytes = imem.mem[1023];

reg[31:0] rdata;
reg[63:0] bits_value;
reg[15:0] version_sum;
reg[9:0] count;

initial begin
   rdata = 32'h0;
   @(negedge resetB);
   @(posedge resetB);
   @(negedge clk);
   apb_driver.idle();
   @(negedge clk);
   apb_driver.write(8'h04,expectedBytes);
   apb_driver.idle();
   @(negedge clk);
   apb_driver.write(8'h00,32'h01);
   apb_driver.idle();
   count = 8'h00;
   while(~rdata[8] && (count <= 10'h3e8))
     begin
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        apb_driver.read(8'h00,rdata);
        apb_driver.idle();
        count = count + 8'h01;
     end
   apb_driver.read(8'h08,rdata);
   version_sum = rdata[15:0];
   apb_driver.idle();
   apb_driver.read(8'h10,bits_value[63:32]);
   apb_driver.idle();
   apb_driver.read(8'h14,bits_value[31:0]);
   apb_driver.idle();
   $display("Version Sum: %4h (%d)",version_sum, version_sum);
   $display("Bits Value: %16h (%d)",bits_value, bits_value);
   @(negedge clk);
   @(negedge clk);
   @(negedge clk);
   @(negedge clk);
   $finish;
end


endmodule