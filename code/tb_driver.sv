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

    virtual tb_bfm	bfm;                    // bfm
    mailbox monitor2driver, driver2monitor; // communication with monitor
    bit is_done_all;                        // flag if the test has done running
    bit is_inject_reset;                    // flag if reset signal will be injected randomly
    bit is_inject_start;                    // flag if start signal will be injected randomly

    // **************************************************
    // METHODS
    // **************************************************

    // Constructor
    function new(virtual tb_bfm bfm, mailbox monitor2driver, mailbox driver2monitor, bit is_inject_reset=0, bit is_inject_start=0);
        this.bfm = bfm;

        this.monitor2driver = monitor2driver;
        this.driver2monitor = driver2monitor;
        this.is_inject_reset = is_inject_reset;
        this.is_inject_start = is_inject_start;

    endfunction

    // Inject abitrary events occuring randomly: reset, start read/write
    task inject_events();

        fork
            // inject reset
            begin
                bit inject_enable = $urandom();
                if (is_inject_reset && inject_enable) begin
                    @(negedge bfm.aclk);
                    bfm.areset_n = 0;
                    @(negedge bfm.aclk);
                    bfm.areset_n = 1;
                end  
            end  

            // inject start read
            begin
                bit inject_enable = $urandom();
                if (is_inject_start && inject_enable) begin
                    @(negedge bfm.aclk);
                    bfm.start_read = 1;
                    @(negedge bfm.aclk);
                    bfm.start_read = 0;
                end  
            end

            // inject start write
            begin
                bit inject_enable = $urandom();
                if (is_inject_start && inject_enable) begin
                    @(negedge bfm.aclk);
                    bfm.start_write = 1;
                    @(negedge bfm.aclk);
                    bfm.start_write = 0;
                end  
            end
        join_none
            
    endtask

    // Drive stimulus
    task run();

        // declarations
        mailbox_message msg;
        pkt_write write_op;
        pkt_write_rand write_rand_op;
        pkt_read read_op;
        pkt_read_rand read_rand_op;

        $display("[Driver] start running");

        // mark test not done
        is_done_all = 0;

        forever begin
            
            // wait for stimulus from monitor
            monitor2driver.get(msg);
            $display("[Driver] Monitor -> Driver");
            msg.display();

            // drive based on the received message
            case(msg.msg_type)
            
                MSG_STIMULUS_READY_READ: begin
                    if (!$cast(read_op, msg)) begin
                        continue;
                    end
                    
                    // inject arbitrary events
                    inject_events();

                    $display("[Driver] drive read-transaction to DUT");
                    @(negedge bfm.aclk);
                    bfm.addr = read_op.addr;
                    bfm.start_read = 1;
                    @(negedge bfm.aclk);
                    bfm.start_read = 0;
                end

                MSG_STIMULUS_READY_READ_RAND: begin
                    if (!$cast(read_rand_op, msg)) begin
                        continue;
                    end
                    
                    // inject arbitrary events
                    inject_events();

                    $display("[Driver] drive random-read-transaction to DUT");
                    @(negedge bfm.aclk);
                    bfm.addr = read_rand_op.addr;
                    bfm.start_read = 1;
                    @(negedge bfm.aclk);
                    bfm.start_read = 0;
                end

                MSG_STIMULUS_READY_WRITE: begin
                    if (!$cast(write_op, msg)) begin
                        continue;
                    end
                    
                    // inject arbitrary events
                    inject_events();

                    $display("[Driver] drive write-transaction to DUT");
                    @(negedge bfm.aclk);
                    bfm.addr = write_op.addr;
                    bfm.data = write_op.data;
                    bfm.start_write = 1;
                    @(negedge bfm.aclk);
                    bfm.start_write = 0;
                end

                MSG_STIMULUS_READY_WRITE_RAND: begin
                    if (!$cast(write_rand_op, msg)) begin
                        continue;
                    end
                    
                    // inject arbitrary events
                    inject_events();

                    $display("[Driver] drive random-write-transaction to DUT");
                    @(negedge bfm.aclk);
                    bfm.addr = write_rand_op.addr;
                    bfm.data = write_rand_op.data;
                    bfm.start_write = 1;
                    @(negedge bfm.aclk);
                    bfm.start_write = 0;
                end

                MSG_DONE_ALL: begin
                    $display("[Driver] stop running");
                    break;
                end

                default: begin
                    // do nothing   
                    $display("[Driver] un-expected message received: %s", msg.msg_type);
                end
            endcase
        end

        // mark as the test has done
        is_done_all = 1;

    endtask

endclass

`endif
