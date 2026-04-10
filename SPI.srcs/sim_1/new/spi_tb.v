`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 12:20:19 PM
// Design Name: 
// Module Name: spi_tb
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
`timescale 1ns / 1ps

module tb_spi;

    // -----------------------------------------------------------
    // Testbench Signals
    // -----------------------------------------------------------
    reg clk;
    reg reset;
    reg start;

    // Data registers to drive the inputs
    reg [7:0] master_tx;
    reg [7:0] slave_tx;

    // Wires to observe the received data outputs
    wire [7:0] master_rx;
    wire [7:0] slave_rx;

    // SPI Bus wires connecting Master and Slave
    wire sclk;
    wire mosi;
    wire miso;
    wire cs;

    // Status flags
    wire master_done;
    wire slave_rx_done;

    // -----------------------------------------------------------
    // Clock Generation (100 MHz system clock for the Master)
    // -----------------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // -----------------------------------------------------------
    // Instantiate the Master
    // -----------------------------------------------------------
    master spi_master_inst (
        .clk(clk),
        .start(start),
        .tx_byte(master_tx),
        .miso(miso),
        .reset(reset),
        
        .mosi(mosi),
        .sclk(sclk),
        .cs(cs),
        .rx_byte(master_rx),
        .done(master_done)
    );

    // -----------------------------------------------------------
    // Instantiate the Slave
    // -----------------------------------------------------------
    slave spi_slave_inst (
        .sclk(sclk),
        .cs(cs),
        .mosi(mosi),
        .miso(miso),
        
        .rx_byte(slave_rx),
        .rx_done(slave_rx_done),
        .tx_byte(slave_tx)
    );

    // -----------------------------------------------------------
    // Test Sequence
    // -----------------------------------------------------------
    initial begin
        // 1. Initialize all inputs
        reset = 1;
        start = 0;

        // 2. Set the data we want to exchange
        master_tx = 8'hA5; // Master sends 10100101
        slave_tx  = 8'h3C; // Slave sends 00111100

        // 3. Release the master from reset
        #20;
        reset = 0; 

        // 4. Pulse the start signal to begin transmission
        #20;
        start = 1; 
        #10;
        start = 0;

        // 5. Wait for the transaction to complete. 
        // Using a fixed delay because the master bypasses the DONE state.
        #300;
        
        // 6. Optional: Run a second transaction to ensure everything resets nicely
        master_tx = 8'h81; // Master sends 10000001
        slave_tx  = 8'hFF; // Slave sends 11111111
        
        #50;
        start = 1;
        #10;
        start = 0;
        
        #300;

        // 7. Finish simulation
        $finish;
    end

endmodule