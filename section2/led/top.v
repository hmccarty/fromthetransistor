module top(clk, led);
    input clk;
    output wire led;

    reg [31:0] cnt;
    always @(posedge clk)
    begin
        cnt <= cnt + 1;
    end
    
    assign led = cnt[22];
endmodule;
