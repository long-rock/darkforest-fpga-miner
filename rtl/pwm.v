/*
 * Copyright 2022 the Dark Forest FPGA Miner Contributors
 */

`default_nettype none
`timescale 1ns / 1ps

module pwm
(
    input wire clk,
    input wire [13:0] width,
    output reg pulse
);
    reg [13:0] counter = 0;

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter < width) pulse <= 1'b1;
        else pulse <= 1'b0;
    end
endmodule
