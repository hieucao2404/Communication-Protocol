`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2026 09:55:48 AM
// Design Name: 
// Module Name: tb_spi_top
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



module tb_spi_top();


    reg clk;
    reg reset;
    reg start;
    reg [7:0] master_tx_data;
    reg [7:0] slave_tx_data;

 
    wire [7:0] master_rx_data;
    wire [7:0] slave_rx_data;
    wire master_done;
    wire slave_done;


    spi_top uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .master_tx_data(master_tx_data),
        .slave_tx_data(slave_tx_data),
        .master_rx_data(master_rx_data),
        .slave_rx_data(slave_rx_data),
        .master_done(master_done),
        .slave_done(slave_done)
    );


    always #5 clk = ~clk;

    initial begin
        // Initialize all inputs
        clk = 0;
        reset = 1;
        start = 0;
        master_tx_data = 8'hA5; 
        slave_tx_data  = 8'hC3;
        // Hold reset for 100 ns, then release
        #100;
        reset = 0;
        #20;



        // Trigger the start pulse for one clock cycle
        start = 1;
        #10;
        start = 0;

        // Wait dynamically until the master finishes the transaction
        wait(master_done == 1);
        #50; // Give it a little buffer time after completion

     
        // End simulation
        $finish;
    end

endmodule
