`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2026 04:24:19 AM
// Design Name: 
// Module Name: i2c_tb
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


module i2c_tb;
    //inputs
	reg clk;
	reg rst;
	reg [6:0] addr;
	reg [7:0] data_in;
	reg rw;
	reg enable;
	
	//outputs
	wire scl;
	wire sda;
	wire [7:0] data_out;
	wire busy;
	
	//instantiate the master module
	i2c_master master(
		.clk(clk),
		.rst(rst),
		.addr(addr),
		.data_in(data_in),
		.rw(rw),
		.enable(enable),
		.scl(scl),
		.sda(sda),
		.data_out(data_out),
		.busy(busy));
		
	//instantiate the slave module
	i2c_slave slave(
		.sda(sda),
		.scl(scl));
		
    //Generate clk
    always begin 
        #5;
        clk = ~clk;
    end
    
    //Initialize inputs 
    initial begin
        clk = 0;
        rst = 1;
        
        #2500;
        rst = 0;
        addr=7'b1010111;
		data_in=8'b10101010;
		rw=0;	
		enable=1;
		#2500;
		enable=0;
		
		wait(!busy);
		#2500;
		addr=7'b1010111;
		rw=1;	
		enable=1;
		#2500;
		enable=0;
		
		end
		initial begin
		  $display("slave address:%b", 7'b1010111);
		  $display("slave data:%b", 8'b11001101);
		end
endmodule
