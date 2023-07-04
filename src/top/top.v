module top(
    CLK_IN, enable, CS, SCLK, SDO
);

input CLK_IN;
wire CLK_OUT;

input enable;
output CS;
output SCLK;
output SDO;

counter c( CLK_IN, enable, CS, SCLK, SDO );

localparam power = 4'd0;
localparam divisor = ( 8'd1 << power ) - 8'd1;

reg [7:0] counter;
reg clk_out;

initial begin
    clk_out <= 0;
    counter <= divisor;
end

always @( CLK_IN ) begin
    if( power == 0 ) begin
        clk_out <= CLK_IN;
    end else begin
        if( CLK_IN == 1 ) begin
            if( counter == 0 ) begin
                clk_out <= !clk_out;
                counter <= divisor;
            end else begin
                counter <= counter - 1;
            end
        end
    end
end

assign CLK_OUT = clk_out;

endmodule
