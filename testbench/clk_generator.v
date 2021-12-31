module clk_generator (
   clk
);

output clk;

reg clk;

//clk generator
initial begin
  clk = 0;
  forever begin
     #5 clk = ~clk;
  end
end

endmodule