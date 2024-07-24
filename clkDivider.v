`timescale 1ns / 1ps

module clkdivider(
        input CLK,
        output reg CLKOUT
    );
    reg [25:0] count;
    always @(negedge CLK)
    begin
        count <=count+1;
        if(count== 50000000)
        begin
            CLKOUT <= ~CLKOUT;
            count<=0;
        end
    end
endmodule