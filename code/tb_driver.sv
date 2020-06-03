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

`ifndef TB_DRIVER
`define TB_DRIVER

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

        // declarations
        mailbox_message msg;
        pkt_write write_op;

        $display("[Driver] starts running");

        forever begin
            
            // wait for STIMULUS_READY_READ/WRITE from monitor
            monitor2driver.get(msg);
            $display("[Driver] Monitor -> Driver");
            msg.display();

            // drive based on the received message
            case(msg.msg_type)
                MSG_STIMULUS_READY_READ: begin
                end

                MSG_STIMULUS_READY_WRITE: begin
                    if (!$cast(write_op, msg)) begin
                        continue;
                    end
                    
                    $display("[Driver] Drive write-transaction to DUT");
                    @(negedge bfm.aclk);
                    bfm.addr = write_op.addr;
                    bfm.data = write_op.data;
                    bfm.start_write = 1;
                    @(negedge bfm.aclk);
                    bfm.start_write = 0;
                end

                default: begin
                    // do nothing    
                end
            endcase
        end
    endtask

endclass

`endif
