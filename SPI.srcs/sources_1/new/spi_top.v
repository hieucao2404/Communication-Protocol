`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2026 09:55:08 AM
// Design Name: 
// Module Name: spi_top
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

module spi_top(
    input clk,
    input reset,
    input start,
    input [7:0] master_tx_data,
    input [7:0] slave_tx_data,
    
    output [7:0] master_rx_data,
    output [7:0] slave_rx_data,
    output master_done,
    output slave_done
);

    // Internal wires connecting the SPI bus between Master and Slave
    wire mosi_wire;
    wire miso_wire;
    wire sclk_wire;
    wire cs_wire;

    // Instantiate the Master module [cite: 1, 2]
    master u_master (
        .clk(clk),
        .start(start),
        .tx_byte(master_tx_data),
        .miso(miso_wire),
        .reset(reset),
        .mosi(mosi_wire),
        .sclk(sclk_wire),
        .cs(cs_wire),
        .rx_byte(master_rx_data),
        .done(master_done)
    );

    // Instantiate the Slave module [cite: 14]
    slave u_slave (
        .sclk(sclk_wire),
        .cs(cs_wire),
        .mosi(mosi_wire),
        .miso(miso_wire),
        .rx_byte(slave_rx_data),
        .rx_done(slave_done),
        .tx_byte(slave_tx_data)
    );

endmodule
