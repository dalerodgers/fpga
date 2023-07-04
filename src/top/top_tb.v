module test();
  reg clk_in = 0, enable = 1;
  wire cs, sclk, sdo;

  top t(clk_in, enable, cs, sclk, sdo);

  always
    #1  clk_in = ~clk_in;

  initial begin
    $display("Starting");
    #200 $finish;
  end

  initial begin
    $dumpfile("top.vcd");
    $dumpvars(0,test);
  end
endmodule
