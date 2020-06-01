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
`include "tb_transactions.sv";

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
        // declarations
        pkt_write write_op;
        int i;

        $display("Generator starts running");

        // TODO: fix the number of transactions, changed later

        for (int i=0; i<3; i++) begin
            write_op = new();
            write_op.addr = i;
            write_op.data = i*10;
            generator2monitor.put(write_op);
        end

    endtask

endclass
