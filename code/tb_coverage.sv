/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines our testbench's coverage, which
samples & computes statistics of the DUT's coverage

*/

import tb_pkg::*;

class tb_coverage;

    // **************************************************
    // VARIABLES
    // **************************************************

    virtual tb_bfm	bfm;                            // bfm
    mailbox monitor2coverage, coverage2monitor;     // communication with monitor

    // **************************************************
    // METHODS
    // **************************************************

    // Constructor
    function new(virtual tb_bfm bfm, mailbox monitor2coverage, mailbox coverage2monitor);
        this.bfm = bfm;

        this.monitor2coverage = monitor2coverage;
        this.coverage2monitor = coverage2monitor;

    endfunction

    // Sample & compute coverage
    task run();
        $display("Coverage starts running");
    endtask

endclass
