module ram_testbench();

wire [7:0] data;
wire externalRamCEB;
wire externalRamWEB;
wire externalRamOEB;
wire[18:0] externalRamAddr;

reg clk;
reg resetB;

//Get some waveforms
initial begin
   $dumpfile("ram.vcd");
   $dumpvars(0,ram_testbench);
end


initial begin
   $readmemh("testbench/memory.mem", externalRam.mem);
end

//Clock generation
initial begin
   clk = 1'b0;
   resetB = 1'b1;
end

always
  begin
     #5 clk = ~clk;
  end

//Reset Generation
initial
  begin
    #6 resetB = 1'b0;
    #25 resetB = 1'b1;
  end

//TestTime
initial
   begin
   #500 $finish;
   end

cy62148E externalRam(
    //inout
    .data(data[7:0]),

    //input
    .ce_b(externalRamCEB),
    .we_b(externalRamWEB),
    .oe_b(externalRamOEB),
    .addr(externalRamAddr)
);

ram_loader ram_loader(
   //outputs
   .internalRamAddress(),
   .internalRamWdata(),
   .internalRamCEB(),
   .internalRamWEB(),
   .externalRamCEB(externalRamCEB),
   .externalRamWEB(externalRamWEB),
   .externalRamOEB(externalRamOEB),
   .externalRamAddress(externalRamAddr),

   //inputs
   .clk(clk),
   .resetB(resetB),
   .externalRamReadData(data[7:0])
);

endmodule