`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 03:09:39 PM
// Design Name: 
// Module Name: rx
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


module rx
#(parameter CLKS_PER_BIT = 868)
( 
    input clk,
    input reset,
    input rx,
    
    output reg [7:0] rx_data,
    output reg rx_done
    );
    
    localparam IDLE = 3'b000;
    localparam RX_START = 3'b001;
    localparam RX_DATA = 3'b010;
    localparam RX_STOP = 3'b011;
    localparam CLEANUP =  3'b100;
    
    reg [2:0] state;
    reg [15:0] clock_count;
    reg [2:0] bit_index;
    
    // Double-register to prevent metastability
    reg rx_r1, rx_sync;
    always @(posedge clk) begin
        rx_r1 <= rx;
        rx_sync <= rx_r1;
     end
     
     always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            rx_done <= 1'b0;
            rx_data <= 8'd0;
            clock_count <= 0;
            bit_index <= 0;
         end 
         else begin 
         rx_done <= 1'b0;
         
         case (state)
            IDLE: begin
                clock_count <= 0;
                bit_index <= 0;
                if(rx_sync == 1'b0) begin
                    state <= RX_START;
                 end
             end
             
             RX_START: begin
              // Wait for the MIDDLE (metastability)
              if(clock_count  == (CLKS_PER_BIT / 2)) begin
                if(rx_sync == 1'b0) begin
                    clock_count <= 0;
                    state <= RX_DATA;
                 end 
                 else begin 
                    state <= IDLE;
                 end
                 end
                 else begin
                 clock_count <= clock_count + 1;
                 end
              end
              
              RX_DATA: begin
              // Wait fo a full bit period to sample the next bit
              if(clock_count < CLKS_PER_BIT - 1) begin
                clock_count <=  clock_count + 1;
              end
              else begin
              clock_count <= 0;
              rx_data[bit_index] <= rx_sync;
              
              if(bit_index < 7) begin
                bit_index <= bit_index + 1;
                state <= RX_DATA;
              end
              else begin
                bit_index <= 0;
                state <= RX_STOP;
                end
              end
            end
            
            RX_STOP: begin
            // wait for the middle of the stop but
            if(clock_count < CLKS_PER_BIT - 1) begin
                clock_count <= clock_count + 1;
            end 
            else begin
                rx_done <= 1'b1;
                state <= CLEANUP;
                clock_count <= 0;
                
            end
         end
         
         CLEANUP: begin
            state <= IDLE;
         end
         
         default: state <= IDLE;
         endcase
         end
         end
    
endmodule
