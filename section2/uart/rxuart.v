module rxuart #(
    parameter CLOCK_RATE = 100000000,
    parameter BAUD_RATE = 9600
)(  
    input wire i_clk,
    input wire i_uart_rx,
    output reg o_wr,
    output reg [7:0] o_data
);

    parameter RX_RATE = CLOCK_RATE / (2 * BAUD_RATE * 8);
    parameter RX_RATE_WIDTH = $clog2(RX_RATE);

    reg rx_clk;
    reg [RX_RATE_WIDTH-1:0] clk_count;
    reg [2:0] sample_count;
    reg [2:0] bit_count;

    reg [2:0] rx_state;
    parameter IDLE = 0, READ = 1, END = 2;

    initial begin
        rx_clk = 0;
        clk_count = 0;
        sample_count = 3'b0;
        bit_count = 3'b0;
    end

    always @(posedge i_clk) begin
        if (clk_count == RX_RATE[RX_RATE_WIDTH-1:0]) begin
            clk_count <= 0;
            rx_clk <= ~rx_clk;
        end else begin
            clk_count <= clk_count + 1;
        end
    end

    always @(posedge rx_clk) begin
        case(rx_state)
        IDLE:
            begin
                bit_count <= 3'b0;
                o_wr <= 1'b0;
                if (i_uart_rx == 0) begin
                    if (sample_count != 3'd7) begin
                        sample_count <= sample_count + 3'b1;
                    end else begin
                        sample_count <= 0;
                        rx_state <= READ;
                    end
                end else begin
                    sample_count <= 0;
                end
            end

        READ:
            begin
                if (bit_count != 3'd7) begin
                    if (sample_count != 3'd7) begin
                        sample_count <= sample_count + 3'b1;
                    end else begin
                        o_data[bit_count] <= i_uart_rx;
                        bit_count <= bit_count + 3'b1;
                        sample_count <= 3'b0;
                    end
                end else begin
                    if (sample_count != 3'd7) begin
                        sample_count <= sample_count + 3'b1;
                    end else begin
                        o_data[bit_count] <= i_uart_rx;
                        rx_state <= END;
                    end
                end
            end

        END:
            begin
                o_wr <= 1'b1;
                if (i_uart_rx == 1) begin
                    if (sample_count != 3'd7) begin
                        sample_count <= sample_count + 3'b1;
                    end else begin
                        sample_count <= 0;
                        rx_state <= IDLE;
                    end
                end else begin
                    sample_count <= 0;
                end
            end
        endcase
    end
endmodule;
