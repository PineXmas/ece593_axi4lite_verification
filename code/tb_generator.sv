/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines our testbench's generator, which
generates stimulus for our testbench

*/

import tb_pkg::*;

class tb_generator;

    // **************************************************
    // VARIABLES
    // **************************************************

    virtual tb_bfm	bfm;                            // bfm
    mailbox monitor2generator, generator2monitor;   // communication with monitor

    // **************************************************
    // METHODS
    // **************************************************

    // Constructor
    function new(virtual tb_bfm bfm, mailbox monitor2generator, mailbox generator2monitor);
        this.bfm = bfm;

        this.monitor2generator = monitor2generator;
        this.generator2monitor = generator2monitor;

    endfunction

    // Generate stimulus
    task run();
        $display("Generator starts running");
    endtask

endclass
