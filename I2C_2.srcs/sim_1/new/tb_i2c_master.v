`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 07:35:53 AM
// Design Name: 
// Module Name: tb_i2c_master
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


module tb_i2c_master;
    reg clk = 0;
    always #5 clk = ~clk; // 100MHz
    
    reg rst = 1;
    reg start = 0;
    
    wire scl;
    wire sda;
    
    i2c_master uut(
        .clk(clk),
        .rst(rst),
        .start(start),
        .slave_addr(7'h50),
        .data_in(8'hA5),
        .busy(),
        .done(),
        .ack_error(),
        .sda(sda),
        .scl(scl)    
    );
    
    initial begin
    #20 rst = 0;
    #20 start = 1;
    #10 start = 0;
    
    #5000; 
    $finish;
    end
endmodule
