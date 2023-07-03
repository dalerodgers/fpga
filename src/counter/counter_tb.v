module test();
  reg clk = 0, enable = 1;
  wire cs, sclk, sdo;

  counter c(
    clk,
    enable,
    cs,
    sclk,
    sdo
  );

  always
    #1  clk = ~clk;

  initial begin
    $display("Starting Counter");
    //$monitor("LED Value %b", led);

    enable = 0;
    #40
    enable = 1;
    #160
    enable = 0;

    #13000 $finish;
  end

  initial begin
    $dumpfile("counter.vcd");
    $dumpvars(0,test);
  end
endmodule
