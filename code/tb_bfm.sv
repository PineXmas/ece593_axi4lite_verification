/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This interface defines the BFM used in our testbench

*/

import tb_pkg::*;
import axi_lite_pkg::*;

interface tb_bfm;

    // **************************************************
    // VARIABLES
    // **************************************************
    
    // clocks & reset
    logic aclk;
    logic areset_n;
    
    // start signal for master
    logic start_read;
    logic start_write;

    // input address & data for master
    addr_t addr;
    data_t data;

    // **************************************************
    // INSTANCES
    // **************************************************

    // AXI4-Lite interface
    axi_lite_if axi_if();
    
    // **************************************************
    // LOGIC
    // **************************************************
    
    // clock
    initial begin
        aclk = 0;
        forever begin
            #CLOCK_WIDTH;
            aclk = ~aclk;
        end
    end

    // reset
    task reset_dut();
        areset_n = 0;
        start_read = 0;
        start_write = 0;
        repeat (2) @(negedge aclk);
        areset_n = 1;
    endtask;

endinterface
