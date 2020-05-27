`timescale 1ns / 1ps

/*
This interface define the BFM used in our testbench
*/

import tb_pkg::*;

interface tb_bfm;

    // **************************************************
    // VARIABLES
    // **************************************************
    
    // clocks & reset
    logic clk;
    logic rst;
    
    // AXI4-Lite
    logic master_start_read;
    logic master_start_write;

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
        clk = 0;
        forever begin
            #CLOCK_WIDTH;
            clk = ~clk;
        end
    end

endinterface
