/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines the DUT for our testbench

*/

import axi_lite_pkg::*;

module axi_lite_dut(
    input logic aclk,           // clock
    input logic areset_n,       // reset active low
    input logic start_read,     // start master for reading
    input logic start_write,    // start master for writing
    input addr_t addr,          // target address for writing/reading
    input data_t data,          // data for writing
    axi_lite_if axi_if          // AXI-Lite bus
);

    // instance master
    axi_lite_master master (
        .aclk(aclk),
        .areset_n(areset_n),
        .m_axi_lite(axi_if),
        .start_read(start_read),
        .start_write(start_write),
        .addr(addr),
        .data(data)
    );

    // instance slave
    axi_lite_slave slave (
        .aclk(aclk),
        .areset_n(areset_n),
        .s_axi_lite(axi_if)
    );
    
endmodule