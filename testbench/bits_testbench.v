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
    .imem_rdata (imem_rdata)
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

initial begin
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
   #500 $finish;

end


endmodule