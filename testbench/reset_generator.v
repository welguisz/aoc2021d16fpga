module reset_generator(
   //output
   resetB,

   //inputs
   clk
);

output resetB;

input  clk;

reg resetB;

reg [4:0] counter;
initial begin
   counter = 5'ha;
   @(negedge clk);
   resetB = 1'b1;
   @(negedge clk);
   resetB = 1'b0;
   while(counter > 0)
     begin
        @(posedge clk)
        counter = counter - 1;
     end
   @(negedge clk);
   resetB = 1'b1;
end

endmodule