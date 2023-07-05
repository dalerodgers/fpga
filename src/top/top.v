module top(
    CLK_IN, enable, CS, SCLK, SDO
);

input CLK_IN;
wire CLK_OUT;

input enable;
output CS;
output SCLK;
output SDO;

counter c( CLK_OUT, enable, CS, SCLK, SDO );

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

endmodule
