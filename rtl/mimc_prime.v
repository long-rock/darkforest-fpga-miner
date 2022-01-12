/*
 * Copyright 2022 the Dark Forest FPGA Miner Contributors
 *
 * Module: mimc_prime
 *
 * This module has one output wire that always outputs the value of the
 * prime used in Dark Forest.
 */

`default_nettype none
`timescale 1ns / 1ps

module mimc_prime
(
    output wire [255:0] prime
);

localparam PRIME = 256'd21888242871839275222246405745257275088548364400416034343698204186575808495617;

assign prime = PRIME;

endmodule
