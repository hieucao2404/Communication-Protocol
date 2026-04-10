`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 06:39:47 PM
// Design Name: 
// Module Name: tb_uart
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

module tb_uart();

    // Testbench signals
    reg clk;
    reg reset;
    
    reg tx_start;
    reg [7:0] tx_data;
    
    wire tx_active;
    wire tx_done;
    wire tx_pin;
    
    wire rx_pin;
    wire [7:0] rx_data;
    wire rx_done;

    // Loopback connection: connect TX directly to RX
    assign rx_pin = tx_pin;

    // Instantiate the Top Module
    top #(
        .CLK_FREQ(100_000_000), 
        .BAUD_RATE(12_500_000)
    ) uut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_active(tx_active),
        .tx_done(tx_done),
        .tx_pin(tx_pin),
        .rx_pin(rx_pin),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // Clock generation: 100 MHz (10ns period -> 5ns high, 5ns low)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        reset = 1;
        tx_start = 0;
        tx_data = 8'h00;

        // Wait a few clocks and release reset
        #100;
        reset = 0;
        #100;

        tx_data = 8'h41;
        tx_start = 1;
     
        #10;
        tx_start = 0;

        // Wait for the RX module to finish receiving
        @(posedge rx_done);
        
       
        $finish;
    end

endmodule