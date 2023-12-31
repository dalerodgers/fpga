module counter
(
    clk,
    enable,
    CS,
    SCLK,
    SDO
);

input clk;
input enable;
output CS;
output SCLK;
output SDO;

localparam state_CS_HIGH =  3'd0;
localparam state_tCSSR =    3'd1;
localparam state_CLK_LOW =  3'd2;
localparam state_CLK_HIGH = 3'd3;

localparam delay_tCSH  = 4'd2 - 4'd1;
localparam delay_tCSSR = 4'd1 - 4'd1;
localparam delay_tLO   = 4'd1 - 4'd1;
localparam delay_tHIGH = 4'd1 - 4'd1;

//localparam dataStart = 16'b0001000000001111;
localparam dataIncrement = 16'd443;

reg [3:0] clockCounter;

reg cs, sclk;
reg [2:0] state;
reg [3:0] delay;
reg [15:0] dacCount;
reg [15:0] dataOut;
reg lastEnable;

initial begin
    dacCount = 0;

    cs = 1;
    sclk = 0;
    lastEnable = 0;

    delay = delay_tCSH;
    state = state_CS_HIGH;
end

always @(posedge clk) begin
    if( !lastEnable && enable ) begin
        dacCount <= 0;

        cs <= 1;
        sclk <= 0;

        delay <= delay_tCSH;
        state <= state_CS_HIGH;
    //end else if (dacCount > 16'hF000 ) begin
    //    cs <= 1;
    //    sclk <= 0;
    end else begin
        if( delay != 0 ) delay <= delay - 1;

        case( state )
            state_CS_HIGH: begin
                if( delay == 0 ) begin
                    cs <= 0;
                    clockCounter <= 0;
                    dataOut <= dacCount;

                    if( delay_tCSSR == 0 ) begin
                        delay <= delay_tLO;
                        state <= state_CLK_LOW;
                    end else begin
                        delay <= delay_tCSSR;
                        state <= state_tCSSR;
                    end
                end
            end

            state_tCSSR: begin
                if( delay == 0 ) begin
                    sclk <= 1;

                    delay <= delay_tHIGH;
                    state <= state_CLK_HIGH;
                end
            end

            state_CLK_LOW: begin
                if( delay == 0 ) begin
                    sclk <= 1;

                    delay <= delay_tHIGH;
                    state <= state_CLK_HIGH;
                end
            end

            state_CLK_HIGH: begin
                if( delay == 0 ) begin
                    if( clockCounter != 15 ) begin
                        dataOut <= dataOut << 1;
                        clockCounter <= clockCounter + 1;
                        sclk <= 0;
                        
                        delay <= delay_tLO;
                        state <= state_CLK_LOW;
                    end else begin
                        dacCount <= dacCount + dataIncrement;
                        
                        cs <= 1;
                        sclk <= 0;

                        delay <= delay_tCSH;
                        state <= state_CS_HIGH;
                    end
                end
            end

            default: begin
            end
        endcase
    end

    lastEnable = enable;
end

assign CS = cs;
assign SCLK = sclk;
assign SDO = dataOut[15];

endmodule
