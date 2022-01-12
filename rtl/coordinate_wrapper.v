/*
 * Copyright 2022 the Dark Forest FPGA Miner Contributors
 *
 * Module: coordinate_wrapper
 *
 * Dark Forest represents points in the universe with a `(x, y)` coordinate
 * system. The coordinates can be negative.
 * This module "wraps" coordinates so that to be unsigned numbers in the
 * field used by the Dark Forest hash function.
 */

`default_nettype none
`timescale 1ns / 1ps

module coordinate_wrapper
(
    input wire clk,
    input wire rst,

    /*
     * I/O enable
     */
    input wire ce_in,
    output wire ce_out,

    /*
     * Input coordinate
     */
    input wire [255:0] coord,

    /*
     * Output coordinate
     */
    output wire [255:0] wrapped_coord
);

reg ce_out_reg = 0;
reg [255:0] wrapped_coord_reg = 0;
wire [255:0] mimc_p;

mimc_prime mimc_prime_inst(
    .prime(mimc_p)
);

assign ce_out = ce_out_reg;
assign wrapped_coord = wrapped_coord_reg;

always @(posedge clk) begin
    if (rst) begin
        ce_out_reg <= 0;
        wrapped_coord_reg <= 0;
    end else begin
        ce_out_reg <= ce_in;
        if ($signed(coord) < 0) begin
            wrapped_coord_reg <= mimc_p + $signed(coord);
        end else begin
            wrapped_coord_reg <= coord;
        end
    end
end

endmodule