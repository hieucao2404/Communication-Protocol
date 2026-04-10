`timescale 1ns / 1ps

module tb_slave;

reg sclk;
reg cs;
reg mosi;
wire miso;

wire [7:0] rx_byte;
wire rx_done;

reg [7:0] tx_byte;

//////////////////////////////////////////////////
// Instantiate SPI Slave
//////////////////////////////////////////////////

slave dut (
    .sclk(sclk),
    .cs(cs),
    .mosi(mosi),
    .miso(miso),
    .rx_byte(rx_byte),
    .rx_done(rx_done),
    .tx_byte(tx_byte)
);

//////////////////////////////////////////////////
// SPI Clock
//////////////////////////////////////////////////

always #10 sclk = ~sclk;   

//////////////////////////////////////////////////
// SPI Send Task
//////////////////////////////////////////////////

task spi_send_byte;
input [7:0] data;
integer i;
begin
    for (i = 7; i >= 0; i = i - 1) begin
        @(negedge sclk);
        mosi = data[i];
    end
end
endtask

//////////////////////////////////////////////////
// Test Sequence
//////////////////////////////////////////////////

initial begin

    // initialize signals
    sclk = 0;
    cs = 1;
    mosi = 0;
    tx_byte = 8'h3C;

    #50;

    // Start SPI transaction
    cs = 0;

    // master sends A5
    spi_send_byte(8'hA5);

    #20;
    cs = 1;

    #100;

    $finish;

end

endmodule