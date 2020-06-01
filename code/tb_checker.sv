/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines our testbench's checker, which
compares the DUT's results with the results sent
from the scoreboard

*/

import tb_pkg::*;

class tb_checker;

    // **************************************************
    // VARIABLES
    // **************************************************

    virtual tb_bfm	bfm;                        // bfm
    mailbox monitor2checker, checker2monitor;   // communication with monitor

    // **************************************************
    // METHODS
    // **************************************************

    // Constructor
    function new(virtual tb_bfm bfm, mailbox monitor2checker, mailbox checker2monitor);
        this.bfm = bfm;

        this.monitor2checker = monitor2checker;
        this.checker2monitor = checker2monitor;

    endfunction

    // Check results
    task run();
        $display("Checker starts running");
    endtask

endclass
