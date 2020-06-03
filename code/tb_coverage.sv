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

`ifndef TB_COVERAGE
`define TB_COVERAGE

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

        // declarations
        mailbox_message msg;

        $display("[Coverage] start running");

        forever begin
            
            // wait for STIMULUS_READY_READ/WRITE from monitor
            monitor2coverage.get(msg);
            $display("[Coverage] Monitor -> Coverage");
            msg.display();

            // break if DONE_ALL is received
            if (msg.msg_type == MSG_DONE_ALL) begin
                $display("[Coverage] stop running");
                break;
            end

            // sample signals for coverage
            $display("[Coverage] sample for coverage");
            
        end

    endtask

endclass

`endif
