`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 03:09:25 PM
// Design Name: 
// Module Name: tx
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


module tx
#(parameter CLKS_PER_BIT = 868 // 100Mhz / 115200 = 868
)(
    input clk,
    input reset,
    input tx_start,
    input [7:0] tx_data,
    
    output reg tx,
    output reg tx_active,
    output reg tx_done
    );
    
    localparam IDLE = 3'b000;
    localparam TX_START = 3'b001;
    localparam TX_DATA = 3'b010;
    localparam TX_STOP = 3'b011;
    localparam CLEANUP = 3'b100;
    
    reg [2:0] state;
    reg [15:0] clock_count;
    reg [2:0] bit_index;
    reg [7:0] tx_data_reg;
    
    always @(posedge clk) begin 
        if (reset) begin
            state <= IDLE;
            tx <= 1'b1; // Idle state for UART is HIGH
            tx_active <=  1'b0;
            tx_done <= 1'b0;
            clock_count <= 0;
            bit_index <= 0;
        end
        else begin
            tx_done <= 1'b0; // Default to low
            
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    tx_active <= 1'b0;
                    clock_count <= 0;
                    bit_index <= 0;
         
                        if(tx_start) begin
                            tx_active <= 1'b1;
                            tx_data_reg <= tx_data;
                            state <= TX_START;
                         end
                     end
                     
                     TX_START: begin
                        tx <= 1'b0; //Start bit is low
                        if(clock_count < CLKS_PER_BIT - 1) begin
                            clock_count <= clock_count + 1;
                        end
                        else begin
                            clock_count <= 0;
                            state <= TX_DATA;
                        end
                     end
                     
                     TX_DATA: begin
                        tx <= tx_data_reg[bit_index];
                        if(clock_count < CLKS_PER_BIT - 1) begin
                            clock_count <= clock_count + 1;
                            state <= TX_DATA;
                         end 
                        else begin 
                            clock_count <= 0;
                            if(bit_index < 7) begin
                                bit_index <= bit_index + 1;
                             end 
                            else begin
                                bit_index <= 0;
                                state <= TX_STOP;
                             end
                           end
                        end
                       TX_STOP: begin
                        tx <= 1'b1; //Stop bit high
                        if(clock_count < CLKS_PER_BIT - 1) begin
                            clock_count <= clock_count + 1;
                        end
                        else begin 
                            tx_done <= 1'b1;
                            clock_count <= 0;
                            state <= CLEANUP;
                            tx_active <= 1'b0;
                        end
                   end
                   
                   CLEANUP: begin 
                        tx <= 1'b1;
                        tx_active <= 1'b0;
                        state <= IDLE;
                        if (tx_start == 1'b0) begin 
                              state <= IDLE;
                        end
                   end
                   
                   default: state <= IDLE;
                   endcase
                end
             end
                        

endmodule
