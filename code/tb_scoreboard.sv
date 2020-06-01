/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines our testbench's scoreboard,
which hold/retrieve expected results for comparing
with DUT's results

*/

import tb_pkg::*;

class tb_scoreboard;

    // **************************************************
    // VARIABLES
    // **************************************************

    virtual tb_bfm	bfm;                                // bfm
    mailbox monitor2scoreboard, scoreboard2monitor;     // communication with monitor

    // **************************************************
    // METHODS
    // **************************************************

    // Constructor
    function new(virtual tb_bfm bfm, mailbox monitor2scoreboard, mailbox scoreboard2monitor);
        this.bfm = bfm;

        this.monitor2scoreboard = monitor2scoreboard;
        this.scoreboard2monitor = scoreboard2monitor;

    endfunction

    // Store/Retrieve expected results
    task run();
        $display("Scoreboard starts running");
    endtask

endclass
