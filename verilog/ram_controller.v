module ram_controller(
     //outputs
     ram_ceb,
     ram_web,
     ram_addr,
     ram_wdata,
     ramloader_rdata,
     core_rdata,
     good_addr,
     core_pause,

     //inputs
     clk,
     resetB,
     ramloader_ceb,
     ramloader_web,
     ramloader_addr,
     ramloader_wdata,
     core_ceb,
     core_web,
     core_addr,
     core_wdata,
     ram_rdata,


);

//outputs
output ram_ceb;
output ram_web;
output[9:0] ram_addr;
output[63:0] ram_wdata;
output[63:0] ramloader_rdata;
output[63:0] core_rdata;
output[9:0] good_addr;
output      core_pause;

//inputs
input clk;
input resetB;
input ramloader_ceb;
input ramloader_web;
input[9:0] ramloader_addr;
input[63:0] ramloader_ceb;
input core_ceb;
input core_web;
input[9:0] core_addr;
input[63:0] core_wdata;
input[63:0] ram_rdata;

//Will be giving a 3:1 priority to the core over the ram loader.  So the core
//can have 3 accesses back-to-back-back before the ram loader will access the ram.
//If the core is accessing the RAM and the priority goes to the ram loader, this
//module will assert core_pause to pause the current access from the core.
//If the core

reg ram_ceb_next;
reg ram_web_next;
reg[9:0] ram_addr_next;
reg[63:0] ram_wdata_next;
reg[63:0] ramloader_rdata_next;
reg[63:0] core_rdata_next;
reg[9:0] good_addr_next;
reg      core_pause_next;

reg ram_ceb;
reg ram_web;
reg[9:0] ram_addr;
reg[63:0] ram_wdata;
reg[63:0] ramloader_rdata;
reg[63:0] core_rdata;
reg[9:0] good_addr;
reg      core_pause;

always @(posedge clk or negedge resetB)
  begin
     if(~resetB) begin
        ram_ceb <= 1'b1;
        ram_web <= 1'b1;
        ram_addr <= 10'h0;
        ram_wdata <= 64'h0;
        ramloader_rdata <= 64'h0;
        core_rdata <= 64'h0;
        good_addr <= 10'h0;
        core_pause <= 1'b0;
     end
     else begin
        ram_ceb <= ram_ceb_next;
        ram_web <= ram_web_next;
        ram_addr <= ram_addr_next;
        ram_wdata <= ram_wdata_next;
        ramloader_rdata <= ramloader_rdata_next;
        core_rdata <= core_rdata_next;
        good_addr <= good_addr_next;
        core_pause <= core_pause_next;
     end
  end

endmodule