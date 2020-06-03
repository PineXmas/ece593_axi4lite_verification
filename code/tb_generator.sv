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

`ifndef TB_GENERATOR
`define TB_GENERATOR

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
        mailbox_message msg;
        mailbox_message msg_stimulus;
        pkt_write write_op;
        pkt_read read_op;
        int i;

        $display("[Generator] start running");

        // generate stimulus until done
        i = 0;
        forever begin
            $display("****************************************************************************************************");
            
            // generate next stimulus
            $display("[Generator] generate stimulus");
            // TODO: fixed transaction for debug, remove later
            if (i < 3) begin
                write_op = new();
                write_op.addr = i;
                write_op.data = i+10;
                write_op.display();
                msg_stimulus = write_op;
            end
            else begin
                read_op = new();
                read_op.addr = i-3;
                read_op.data = (i-3) + 10;
                read_op.display();
                msg_stimulus = read_op;
            end

            // send STIMULUS_READY_READ/WRITE to monitor
            generator2monitor.put(msg_stimulus);

            // wait for DONE_CHECKING from monitor
            $display("[Generator] wait for checking done");
            tb_monitor::wait_message(monitor2generator, MSG_DONE_CHECKING, msg);
            $display("[Generator] Monitor -> Generator: %s", msg.msg_type.name);

            // TODO: fix the number of transactions, changed later
            i += 1;
            if (i >= 4) begin
                break;
            end
        end

        // send done to monitor
        $display("[Generator] send done generating to monitor");
        msg = new(MSG_DONE_GENERATING);
        generator2monitor.put(msg);
        $display("[Generator] stop running");

    endtask

endclass

`endif
