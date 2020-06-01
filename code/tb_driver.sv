/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines our testbench's driver, which
drive stimulus to the DUT via the BFM

*/

import tb_pkg::*;

class tb_driver;

    // **************************************************
    // VARIABLES
    // **************************************************

    virtual tb_bfm	bfm;                      // bfm
    mailbox monitor2driver, driver2monitor;   // communication with monitor

    // **************************************************
    // METHODS
    // **************************************************

    // Constructor
    function new(virtual tb_bfm bfm, mailbox monitor2driver, mailbox driver2monitor);
        this.bfm = bfm;

        this.monitor2driver = monitor2driver;
        this.driver2monitor = driver2monitor;

    endfunction

    // Drive stimulus
    task run();
        $display("Driver starts running");
    endtask

endclass
