// Uses AMBA 3 APB Signals to connect to.

module bits_regs(
    //outputs
    // -- AMBA Peripheral Bus Signals
    pready,
    prdata,
    pslverr,

    // -- Signals to send to BITS Core
    expected_bytes,
    start,

    //inputs
    // -- System Inputs
    clk,
    resetB,

    // -- AMBA Peripheral Bus Signals
    paddr,
    psel,
    penable,
    pwrite,
    pwdata,

    // -- Signals from BITS Core
    done,
    bits_value,
    bits_enable,
    version_sum,
    bit_counter
);

output       pready;
output[31:0] prdata;
output       pslverr;

output[15:0] expected_bytes;
output       start;

input        clk;
input        resetB;
input[7:2]   paddr;
input        psel;
input        penable;
input        pwrite;
input[31:0]  pwdata;

input        done;
input[63:0]  bits_value;
input        bits_enable;
input[15:0]  version_sum;
input[15:0]  bit_counter;

reg          start;
reg[15:0]    expected_bytes;
reg          done_latched;
reg[15:0]    version_sum_latched;
reg[63:0]    bits_value_latched;
reg[31:0]    prdata;

wire write_cycle;
wire read_cycle;
wire pready;
wire pslverr;

assign pready = 1'b1;  //Will always complete in one cycle.
assign pslverr = 1'b0;  // No errors from this peripheral.

assign write_cycle = psel & penable & pwrite;
assign read_cycle = psel & penable & ~pwrite;

always @(read_cycle or done or version_sum_latched or bits_value_latched or paddr or bit_counter)
  begin
     prdata = 31'h0;
     case(paddr)
        6'h00 :
           begin
             prdata = {23'h0,done,8'h0};
           end
        6'h01 :
           begin
             prdata = {16'h0,expected_bytes};
           end
        6'h02 :
           begin
              prdata = {16'h0,version_sum_latched};
           end
        6'h03 :
           begin
              prdata = {16'h0,bit_counter};
           end
        6'h04 :
           begin
              prdata = bits_value_latched[63:32];
           end
        6'h05 :
           begin
              prdata = bits_value_latched[31:0];
           end
     endcase
  end

always @(posedge clk or negedge resetB)
  begin
     if (~resetB)
       begin
          start <= 1'b0;
          expected_bytes <= 16'h0;
       end
     else
       begin
         if (pwrite & (paddr[7:2] == 6'h00))
           begin
              start <= pwdata[0];
           end
         else if (pwrite & (paddr[7:2] == 6'h01))
           begin
              expected_bytes <= pwdata[15:0];
           end
         else
           begin
             start <= 1'b0;
           end
       end
  end

always @(posedge clk or negedge resetB)
  begin
     if (~resetB)
       begin
          done_latched <= 1'b0;
          version_sum_latched <= 16'h0;
          bits_value_latched <= 64'h0;
       end
     else
       begin
         if (start)
           begin
             done_latched <= 1'b0;
             version_sum_latched <= 16'h0;
             bits_value_latched = 64'h0;
           end
         else if (done)
           begin
             done_latched <= 1'b1;
             version_sum_latched <= version_sum;
             bits_value_latched <= bits_value;
           end
       end
  end

endmodule