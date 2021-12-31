module apb_driver(
   //outputs
   paddr,
   pwrite,
   psel,
   penable,
   pwdata,

   //inputs
   clk,
   prdata
);

output [7:0]  paddr;
output        pwrite;
output        psel;
output        penable;
output [31:0] pwdata;

input         clk;
input[31:0]   prdata;

reg [7:0]   paddr;
reg         pwrite;
reg         psel;
reg         penable;
reg [31:0]  pwdata;


task write;
  input [7:0] addr;
  input [31:0] data;
  begin
    @(negedge clk);
    psel = 1'b1;
    pwrite = 1'b1;
    paddr = addr;
    pwdata = data;
    penable = 0;

    // this is the ENABLE state where the penable is asserted
    @(negedge clk);
    penable = 1;
  end
endtask


  // read ()
  //
  // Simple read method used in the unit tests.
  // Includes options for back-to-back reads.
  //
task read;
  input[7:0] addr;
  output[31:0] data;
  begin
    @(negedge clk);
    psel = 1;
    paddr = addr;
    penable = 0;
    pwrite = 0;

    // this is the ENABLE state where the penable is asserted
    @(negedge clk);
    penable = 1;

    // the prdata should be flopped after the subsequent posedge
    @(posedge clk);
    #1 data = prdata;
  end
endtask

  // idle ()
  //
  // Clear the all the inputs to the uut (i.e. move to the IDLE state)
task idle();
  begin
    @(negedge clk);
    psel = 0;
    penable = 0;
    pwrite = 0;
    paddr = 0;
    pwdata = 0;
  end
endtask

endmodule