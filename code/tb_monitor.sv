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

`ifndef TB_MONITOR
`define TB_MONITOR

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

    // Wait for the given message type in the given mailbox
    static task automatic wait_message(mailbox mbx, msg_t msg_type, ref mailbox_message msg);

        while (1) begin
            mbx.get(msg);
            if (msg.msg_type == msg_type) begin
                break;
            end
        end

    endtask

    // Monitor system's state & send/receive reacting messages
    task run();

        // declarations
        mailbox_message msg;
        int count = 0;
        bit done_generating = 0;

        $display("[Monitor] start running");

        forever begin

            // wait for STIMULUS_READY_READ/WRITE from generator
            $display("[Monitor] wait for stimulus from generator");
            while (1) begin
                generator2monitor.get(msg);
                $display("[Monitor] Generator -> Monitor: %s", msg.msg_type);
                msg.display();

                if (msg.msg_type == MSG_STIMULUS_READY_READ
                    || msg.msg_type == MSG_STIMULUS_READY_READ_RAND
                    || msg.msg_type == MSG_STIMULUS_READY_WRITE
                    || msg.msg_type == MSG_STIMULUS_READY_WRITE_RAND
                ) begin
                    break;
                end

                // stop if received DONE_GENERATING
                if (msg.msg_type == MSG_DONE_GENERATING) begin
                    done_generating = 1;
                    msg.msg_type = MSG_DONE_ALL;
                    break;
                end
            end
            
            // send the transaction to driver, checker, scoreboard & coverage
            $display("[Monitor] send to driver");
            monitor2driver.put(msg);
            $display("[Monitor] send to checker");
            monitor2checker.put(msg);
            $display("[Monitor] send to scoreboard");
            monitor2scoreboard.put(msg);
            $display("[Monitor] send to coverage");
            monitor2coverage.put(msg);

            // stop if done_generating
            if (done_generating) begin
                $display("[Monitor] stop running");
                break;
            end

            // wait for EXPECTED_REQUEST from checker & send to scoreboard
            $display("[Monitor] wait expected-request from checker");
            wait_message(checker2monitor, MSG_EXPECTED_REQUEST, msg);
            $display("[Monitor] Checker -> Monitor: %s", msg.msg_type);
            $display("[Monitor] send expected-request to scoreboard");
            monitor2scoreboard.put(msg);

            // wait for EXPECTED_REPLY from scoreboard & send to checker
            $display("[Monitor] wait expected-reply from scoreboard");
            wait_message(scoreboard2monitor, MSG_EXPECTED_REPLY, msg);
            $display("[Monitor] Scoreboard -> Monitor: %s", msg.msg_type);
            $display("[Monitor] send expected-reply to checker");
            monitor2checker.put(msg);

            // wait for DONE_CHECKING from checker & send to generator
            $display("[Monitor] wait for checking done");
            wait_message(checker2monitor, MSG_DONE_CHECKING, msg);
            $display("[Monitor] Checker -> Monitor: %s", msg.msg_type);
            $display("[Monitor] send done checking to generator");
            monitor2generator.put(msg);
        end
    endtask

endclass

`endif
