module ram_loader(
   //outputs
   internalRamAddress,
   internalRamWdata,
   internalRamCEB,
   internalRamWEB,
   externalRamCEB,
   externalRamWEB,
   externalRamOEB,
   externalRamAddress,

   //inputs
   clk,
   resetB,
   externalRamReadData
);

output[9:0] internalRamAddress;
output[63:0] internalRamWdata;
output internalRamCEB;
output internalRamWEB;
output externalRamCEB;
output externalRamWEB;
output externalRamOEB;
output[18:0] externalRamAddress;

input clk;
input resetB;
input[7:0] externalRamReadData;

reg[9:0] internalRamAddress;
reg[63:0] internalRamWdata;
reg internalRamCEB;
reg internalRamWEB;
reg externalRamCEB;
reg externalRamWEB;
reg externalRamOEB;
reg[18:0] externalRamAddress;

reg[9:0] nextInternalRamAddress;
reg[63:0] nextInternalRamWdata;
reg nextInternalRamCEB;
reg nextInternalRamWEB;
reg nextExternalRamCEB;
reg nextExternalRamWEB;
reg nextExternalRamOEB;
reg[18:0] nextExternalRamAddress;


//State Machine Parameters
parameter FSM_SIZE = 4;
parameter IDLE     = 4'b0000;
parameter SEND_RD  = 4'b0001;
parameter RD0      = 4'b0010;
parameter RD1      = 4'b0011;
parameter RD2      = 4'b0100;
parameter RD3      = 4'b0101;
parameter RD4      = 4'b0110;
parameter RD5      = 4'b0111;
parameter RD6      = 4'b1000;
parameter RD7      = 4'b1001;
parameter WR       = 4'b1010;
parameter WR2RD    = 4'b1011;

reg[FSM_SIZE-1:0] state;
reg[FSM_SIZE-1:0] next_state;

always @(state or internalRamAddress or externalRamReadData or internalRamWdata
         or externalRamAddress)
  begin
     nextInternalRamAddress = internalRamAddress;
     nextInternalRamWdata = internalRamWdata;
     nextInternalRamCEB = 1'b1;
     nextInternalRamWEB = 1'b1;
     nextExternalRamCEB = 1'b1;
     nextExternalRamWEB = 1'b1;
     nextExternalRamOEB = 1'b1;
     nextExternalRamAddress = externalRamAddress;
     next_state = state;
     case(state)
        IDLE:
           begin
              next_state = SEND_RD;
              nextExternalRamCEB = 1'b0;
              nextExternalRamWEB = 1'b1;
              nextExternalRamOEB = 1'b0;
           end
        SEND_RD:
           begin
              next_state = RD0;
              nextExternalRamCEB = 1'b0;
              nextExternalRamWEB = 1'b1;
              nextExternalRamOEB = 1'b0;
              nextExternalRamAddress = externalRamAddress + 19'h00001;
           end
        RD0:
           begin
              next_state = RD1;
              nextExternalRamCEB = 1'b0;
              nextExternalRamWEB = 1'b1;
              nextExternalRamOEB = 1'b0;
              nextExternalRamAddress = externalRamAddress + 19'h00001;
              nextInternalRamWdata[63:56] = externalRamReadData[7:0];
           end
        RD1:
           begin
              next_state = RD2;
              nextExternalRamCEB = 1'b0;
              nextExternalRamWEB = 1'b1;
              nextExternalRamOEB = 1'b0;
              nextExternalRamAddress = externalRamAddress + 19'h00001;
              nextInternalRamWdata[55:48] = externalRamReadData[7:0];
           end
        RD2:
           begin
              next_state = RD3;
              nextExternalRamCEB = 1'b0;
              nextExternalRamWEB = 1'b1;
              nextExternalRamOEB = 1'b0;
              nextExternalRamAddress = externalRamAddress + 19'h00001;
              nextInternalRamWdata[47:40] = externalRamReadData[7:0];
           end
        RD3:
           begin
              next_state = RD4;
              nextExternalRamCEB = 1'b0;
              nextExternalRamWEB = 1'b1;
              nextExternalRamOEB = 1'b0;
              nextExternalRamAddress = externalRamAddress + 19'h00001;
              nextInternalRamWdata[39:32] = externalRamReadData[7:0];
           end
        RD4:
           begin
              next_state = RD5;
              nextExternalRamCEB = 1'b0;
              nextExternalRamWEB = 1'b1;
              nextExternalRamOEB = 1'b0;
              nextExternalRamAddress = externalRamAddress + 19'h00001;
              nextInternalRamWdata[31:24] = externalRamReadData[7:0];
           end
        RD5:
           begin
              next_state = RD6;
              nextExternalRamCEB = 1'b0;
              nextExternalRamWEB = 1'b1;
              nextExternalRamOEB = 1'b0;
              nextExternalRamAddress = externalRamAddress + 19'h00001;
              nextInternalRamWdata[23:16] = externalRamReadData[7:0];
           end
        RD6:
           begin
              next_state = RD7;
              nextExternalRamCEB = 1'b0;
              nextExternalRamWEB = 1'b1;
              nextExternalRamOEB = 1'b0;
              nextExternalRamAddress = externalRamAddress + 19'h00001;
              nextInternalRamWdata[15:8] = externalRamReadData[7:0];
           end
        RD7:
           begin
              next_state = WR;
              nextInternalRamWdata[7:0] = externalRamReadData[7:0];
           end
        WR:
           begin
              next_state = WR2RD;
              nextInternalRamCEB = 1'b0;
              nextInternalRamWEB = 1'b0;
           end
        WR2RD:
           begin
              next_state = RD0;
              nextInternalRamAddress = internalRamAddress + 10'h001;
              nextExternalRamCEB = 1'b0;
              nextExternalRamWEB = 1'b1;
              nextExternalRamOEB = 1'b0;
              nextExternalRamAddress = externalRamAddress + 19'h00001;
           end
     endcase
  end


always @(posedge clk or negedge resetB)
  begin
     if (~resetB) begin
        internalRamAddress <= 10'h0;
        internalRamWdata <= 64'h0;
        internalRamCEB <= 1'b1;
        internalRamWEB <= 1'b1;
        externalRamCEB <= 1'b1;
        externalRamWEB <= 1'b1;
        externalRamOEB <= 1'b1;
        externalRamAddress <= 19'h0;
        state <= IDLE;
     end
     else begin
        internalRamAddress <= nextInternalRamAddress;
        internalRamWdata <= nextInternalRamWdata;
        internalRamCEB <= nextInternalRamCEB;
        internalRamWEB <= nextInternalRamWEB;
        externalRamCEB <= nextExternalRamCEB;
        externalRamWEB <= nextExternalRamWEB;
        externalRamOEB <= nextExternalRamOEB;
        externalRamAddress <= nextExternalRamAddress;
        state <= next_state;
     end
  end

endmodule