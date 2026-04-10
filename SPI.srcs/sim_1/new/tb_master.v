`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 11:26:32 AM
// Design Name: 
// Module Name: tb_master
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

module tb_master;

    // Inputs
    reg clk;
    reg reset;
    reg start;
    reg [7:0] tx_byte;
    reg miso;

    // Outputs
    wire mosi;
    wire sclk;
    wire cs;
    wire [7:0] rx_byte;
    wire done;

    // Instantiate the Master
    master dut (
        .clk(clk),
        .start(start),
        .tx_byte(tx_byte),
        .miso(miso),
        .reset(reset),
        
        .mosi(mosi),
        .sclk(sclk),
        .cs(cs),
        .rx_byte(rx_byte),
        .done(done)
    );

    // Clock Generation (100 MHz system clock)
    always #5 clk = ~clk;

    // Fake SPI Mode 0 Slave (Shifts on falling edge)
    reg [7:0] slave_data;
    
    always @(negedge sclk or posedge cs) begin
        if (cs) begin
            slave_data <= 8'h3C; // Slave will respond with 00111100
        end else begin
            slave_data <= {slave_data[6:0], 1'b0}; // Shift data
        end
    end

    // Drive MISO continuously based on CS and the shift register
    always @(*) begin
        miso = (!cs) ? slave_data[7] : 1'b0;
    end

    // Test Sequence
    initial begin
        // 1. Initialize Inputs
        clk = 0;
        reset = 1;
        start = 0;
        tx_byte = 8'hA5; // Master sends 10100101

        // 2. Release reset
        #20;
        reset = 0;

        // 3. Start the SPI transaction
        #20;
        start = 1;
        #10;
        start = 0;


        #250;

        $finish;
    end

endmodule