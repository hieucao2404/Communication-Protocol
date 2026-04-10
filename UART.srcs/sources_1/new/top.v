`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 06:35:51 PM
// Design Name: 
// Module Name: top
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


module top
#(parameter CLK_FREQ = 100000000, 
parameter BAUD_RATE = 115200,
parameter CLKS_PER_BIT = CLK_FREQ / BAUD_RATE)(
    input clk,
    input reset,
    
    input tx_start,
    input [7:0] tx_data,
    output tx_active,
    output tx_done,
    output tx_pin,
    
    input rx_pin,
    output [7:0] rx_data,
    output rx_done
    );
    
    tx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx_pin),
        .tx_active(tx_active),
        .tx_done(tx_done)
    );

    rx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) rx_inst (
        .clk(clk),
        .reset(reset),
        .rx(rx_pin),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );
endmodule
