/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines our testbench's monitor, which
monitors current state of the whole system & send
reacting messages to responsible components

*/

import tb_pkg::*;

class tb_monitor;

    // **************************************************
    // VARIABLES
    // **************************************************

    virtual tb_bfm	bfm;                            // bfm
    mailbox monitor2generator, generator2monitor;   // communication with generator
    mailbox	monitor2driver, driver2monitor;         // communication with driver
    mailbox monitor2checker, checker2monitor;       // communication with checker
    mailbox monitor2scoreboard, scoreboard2monitor; // communication with score-board
    mailbox monitor2coverage, coverage2monitor;     // communication with coverage

    // **************************************************
    // METHODS
    // **************************************************

    // Constructor
    function new(virtual tb_bfm bfm);
        this.bfm = bfm;

        this.monitor2generator = new();
        this.generator2monitor = new();

        this.monitor2driver = new();
        this.driver2monitor = new();

        this.monitor2checker = new();
        this.checker2monitor = new();

        this.monitor2scoreboard = new();
        this.scoreboard2monitor = new();

        this.monitor2coverage = new();
        this.coverage2monitor = new();

    endfunction

    // Monitor system's state & send/receive reacting messages
    task run();
        $display("Monitor starts running");
    endtask

endclass
