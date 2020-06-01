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
`include "tb_transactions.sv";

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

        // declarations
        mailbox_message msg;
        int count = 0;

        $display("Monitor starts running");

        forever begin

            $display("****************************************************************************************************");

            // wait for STIMULUS_READY_READ/WRITE from generator
            $display("[Monitor] wait for stimulus from generator");
            generator2monitor.get(msg);
            $display("Generator -> Monitor");
            msg.display();
            
            // send the transaction to driver, checker & scoreboard
            $display("[Monitor] send to driver");
            monitor2driver.put(msg);
            $display("[Monitor] send to checker");
            monitor2checker.put(msg);
            $display("[Monitor] send to scoreboard");
            monitor2scoreboard.put(msg);

            count += 1;
            if (count >= 3) begin
                break;
            end
        end
    endtask

endclass
