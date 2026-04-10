`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 03:12:12 AM
// Design Name: 
// Module Name: slave
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module slave(
    input sclk,
    input cs,
    input mosi,
    output miso,
    
    output reg [7:0]rx_byte,
    output reg rx_done,
    
    input wire [7:0] tx_byte
    );
    
    reg [7:0] rx_shift = 0;
    reg [7:0] tx_shift = 0;
    reg [2:0] bit_count = 0;
    
    // RECEIVE DATA (MOSI)
    
   always @(posedge sclk or posedge cs) begin
    if (cs) begin
        bit_count <= 0;
        rx_done <= 0;   
        rx_shift <= 0;
    end
    else begin
        rx_shift <= {rx_shift[6:0], mosi};
        bit_count <= bit_count + 1;

        if (bit_count == 3'd7) begin
            rx_byte <= {rx_shift[6:0], mosi};
            rx_done <= 1;
        end
        else begin
            rx_done <= 0;
        end
    end
end
    /// TRANSMIT DATA (MISO)
    always @(negedge sclk or posedge cs) begin
        if (cs) begin
            tx_shift <= tx_byte;
        end
        else begin
            tx_shift <= {tx_shift[6:0], 1'b0};
         end
         end
    assign miso = tx_shift[7];
endmodule
