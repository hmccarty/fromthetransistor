/* 
Transmission state machine:
- IDLE (High output)
- START_MESSAGE (Low output, message saved)
- PRINT_MESSAGE (Output next message LSB)
- END_MESSAGE (High output, delete message)
*/

module txuart(
    input wire i_clk,
    input reg i_tx_stb, 
    input reg[7:0] i_tx_data,
    output wire o_uart_tx,
    output wire o_tx_busy);

    reg [7:0] tx_data;
    reg [2:0] tx_index;

    initial begin
        tx_data = 8'b0;
        tx_index = 3'b0;
    end

    reg [2:0] tx_state;
    parameter IDLE = 0, START = 1, PRINT = 2, END = 3;

    always @(posedge i_clk) begin
        case(tx_state)
        IDLE:
            begin
            o_uart_tx <= 1'b1;
            o_tx_busy <= 1'b0;

            if (i_tx_stb)
                tx_state <= START;
            end
        
        START:
            begin
            tx_data <= i_tx_data;
            tx_index <= 3'b0;
            o_uart_tx <= 1'b0;
            o_tx_busy <= 1'b1;
            tx_state <= PRINT;
            end

        PRINT:
            begin
            o_uart_tx <= tx_data[tx_index];
            if (tx_index == 3'd7)
                tx_state <= END;
            tx_index <= tx_index + 3'b1;
            end

        END:
            begin
            o_uart_tx <= 1'b1;
            o_tx_busy <= 1'b1;
            tx_state <= IDLE;
            end
        endcase
    end
endmodule;
