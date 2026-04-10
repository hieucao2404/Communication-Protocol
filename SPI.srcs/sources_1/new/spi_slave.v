`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 02:07:07 AM
// Design Name: 
// Module Name: spi_slave
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


module spi_slave
#(parameter SPI_MODE = 0)
(
    //system signal
    input rst,
    input clk,
    output reg rx_dv,
    output reg [7:0] rx_byte,
    input tx_dv,
    input [7:0] tx_byte,
    
    //SPI interface
    input spi_clk,
    input mosi,
    input cs,
    output miso
    );
    
    //SPI mode decoding
    wire cpol;
    wire cpha;
    wire w_spi_clk;
    
    assign cpol = (SPI_MODE == 2) || (SPI_MODE == 3);
    assign cpha = (SPI_MODE == 1) || (SPI_MODE == 3);
    
    //normalize spi clock?
    assign w_spi_clk = (cpha) ? ~spi_clk : spi_clk;
    
    // SPI rx logic
    reg [2:0] rx_bit_count = 0;
    reg [7:0] rx_shift = 0;
    reg [7:0] r_rx_byte = 0;
    reg rx_done = 0;
    
    always @(posedge w_spi_clk or posedge cs) begin
        if(cs) begin
            rx_bit_count <= 0;
            rx_done <= 0;
        end
        else begin 
            rx_bit_count <= rx_bit_count + 1;
            
            rx_shift <= {rx_shift[6:0], mosi};
            
            if(rx_bit_count == 3'b111) begin
                r_rx_byte <= {rx_shift[6:0], mosi};
                rx_done <= 1'b1;
            end
            else begin 
                rx_done <= 1'b0;
            end
        end
   end
   
   // Clock domain crossing (SPI -> system clock)
   reg rx_done_d1;
   reg rx_done_d2;
   
   always @(posedge clk or negedge rst) begin
    if(!rst) begin
        rx_done_d1 <= 0;
        rx_done_d2 <= 0;
        rx_dv <= 0;
        rx_byte <= 0;
    end
    else begin
        rx_done_d1 <= rx_done;
        rx_done_d2 <=  rx_done_d1;
        //detect rising edge
        if(rx_done_d1 && !rx_done_d2) begin
         rx_dv <= 1'b1;
         rx_byte <= r_rx_byte;
        end
        else begin
            rx_dv <= 1'b0;
        end
   end
   end
   
   // TX Byte register
   reg[7:0] r_tx_byte = 0;
   
   always @(posedge clk or negedge rst) begin
    if(!rst)
        r_tx_byte <= 8'h00;
    else if (tx_dv)
        r_tx_byte <= tx_byte;
    end
    
    // SPI TX Logic
    reg[2:0] r_tx_bit_count = 3'b111;
    reg miso_bit;
    reg miso_preload;
    
    always @(posedge w_spi_clk or posedge cs) begin
        if(cs)
         begin r_tx_bit_count <= 3'b111;
         miso_bit <= r_tx_byte[7];
         miso_preload <= 1'b1;
        end
        else begin
        r_tx_bit_count <= r_tx_bit_count - 1;
        miso_bit <= r_tx_byte[r_tx_bit_count];
        miso_preload <= 1'b0;
        end
    end
    
    //MISO output logic
    
    wire miso_data;
    assign miso_data = miso_preload ? tx_byte[7] : miso_bit;
    
    // tri-state when cs is inactive
    assign miso = (cs) ? 1'bz : miso_data;
        
endmodule
