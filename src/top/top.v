module top(
    CLK_IN, enable1, CS1, SCLK1, SDO1, enable2, CS2, SCLK2, SDO2
);

input CLK_IN;
wire CLK_OUT;

input enable1;
output CS1;
output SCLK1;
output SDO1;
input enable2;
output CS2;
output SCLK2;
output SDO2;

`define USE_PLL

`ifdef USE_PLL
Gowin_rPLL your_instance_name(
        .clkout(CLK_OUT),
        .clkin(CLK_IN)
    );
`endif

counter c1( CLK_OUT, enable1, CS1, SCLK1, SDO1 );
counter c2( CLK_OUT, enable2, CS2, SCLK2, SDO2 );

`ifndef USE_PLL
`define divisor 200

reg clk_out;

if( (`divisor == 0) || (`divisor == 1) ) begin
    initial begin
        clk_out <= 0;
    end

    always @( CLK_IN ) begin
        clk_out <= CLK_IN;
    end
end else begin
    reg [7:0] counter;

    initial begin
        clk_out <= 0;
        counter <= `divisor - 8'd1;
    end
    
    always @( posedge CLK_IN ) begin
            if( counter == 0 ) begin
                clk_out <= !clk_out;
                counter <= `divisor - 8'd1;
            end else begin
                counter <= counter - 1;
            end
    end
end

assign CLK_OUT = clk_out;
`endif

endmodule
