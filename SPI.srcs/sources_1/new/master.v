`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 11:16:04 AM
// Design Name: 
// Module Name: master
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


module master(
    input clk,
    input start,
    input wire [7:0] tx_byte,
    input wire miso,
    input reset,
    
    output reg mosi,
    output reg sclk,
    output reg cs,
    
    output reg [7:0] rx_byte,
    output reg done
    );
    
    reg [7:0] tx_shift;
    reg [7:0] rx_shift;
    reg [2:0] bit_count;
    
    reg [1:0] state;
    
    localparam IDLE     = 2'b00;
    localparam TRANSFER = 2'b01;
    localparam WAIT_CS  = 2'b11;
    localparam DONE     = 2'b10;
    
  
    always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        cs <= 1;
        sclk <= 0;
        done <= 0;
        end
        else begin
     case(state)
        //IDLE
         IDLE: begin
          sclk <= 0;
          cs <= 1;
          done <= 0;
          mosi <= 0;
          
          if(start) begin
            cs <= 0;
            tx_shift <= {tx_byte[6:0], 1'b0}; // Shift early
            mosi <= tx_byte[7];               // Drive first bit immediately
            bit_count <= 0;
            state <= TRANSFER;
          end
      end
      
      // TRANSFER
      
      TRANSFER: begin
       sclk <= ~sclk;
       
       //Failing edge (Drive data)
       if(sclk == 1) begin
        mosi <= tx_shift[7];
        tx_shift <= {tx_shift[6:0], 1'b0};
        
       end
       
       // Rising edge (Sample data)
       else begin
        rx_shift <= {rx_shift[6:0], miso};
        bit_count <= bit_count + 1;
        
        if(bit_count == 3'd7) begin 
            rx_byte <= {rx_shift[6:0], miso};
            state <= WAIT_CS;
        end       
       end
       end
        WAIT_CS: begin 
        sclk <= 0;
        state <= DONE;
       end
      
       //DONE
       DONE: begin
       cs <= 1;
       done <= 1;
       state <= IDLE;
      end
      endcase
      end
    end
endmodule
