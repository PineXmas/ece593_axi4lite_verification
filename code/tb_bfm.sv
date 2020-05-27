`timescale 1ns / 1ps

/*
This interface define the BFM used in our testbench
*/

import tb_pkg::*;

interface axi_tb_bfm;

    // **************************************************
    // DECLARATIONS
    // **************************************************
    
    // clocks & reset
    logic clk;
    logic rst;
    
    // AXI4-Lite
    axi_lite_if axi_if;
    logic master_start_read;
    logic master_start_write;
    
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
