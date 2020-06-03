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
import axi_lite_pkg::*;

`ifndef TB_CHECKER
`define TB_CHECKER

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

        // declarations
        mailbox_message msg;
        mailbox_message msg_done;       // send DONE_CHECKING signal
        pkt_write write_op;
        pkt_write write_expected;
        data_t wdata;
        addr_t awaddr;

        $display("[Checker] starts running");

        // setup messages
        msg_done = new(MSG_DONE_CHECKING);

        forever begin
            
            // wait for STIMULUS_READY_READ/WRITE from monitor
            monitor2checker.get(msg);
            $display("[Checker] Monitor -> Checker");
            msg.display();

            // check for done-signal
            case(msg.msg_type)
                MSG_STIMULUS_READY_READ: begin

                    // send EXPECTED_REQUEST to monitor

                    // wait EXPECTED_REPLY from monitor

                    // wait until read result is available

                    // check with scoreboard's results

                    // wait until transaction done & send to monitor
                    $display("[Checker] send done to monitor");
                    checker2monitor.put(msg_done);
                end

                MSG_STIMULUS_READY_WRITE: begin
                    if (!$cast(write_op, msg)) begin
                        continue;
                    end

                    // send EXPECTED_REQUEST to monitor
                    $display("[Checker] send expected-request to monitor");
                    msg = new(MSG_EXPECTED_REQUEST);
                    checker2monitor.put(msg);

                    // wait EXPECTED_REPLY from monitor
                    $display("[Checker] wait expected-reply from monitor");
                    tb_monitor::wait_message(monitor2checker, MSG_EXPECTED_REPLY, msg);
                    $display("[Checker] Monitor -> Checker: %s", msg.msg_type);
                    if (!$cast(write_expected, msg)) begin
                        $fatal("[Checker] Cannot cast to pkt_write");
                    end

                    // wait until write result is available
                    $display("[Checker] Check done-signal of write-transaction");
                    @ (bfm.axi_if.awvalid && bfm.axi_if.awready);
                    awaddr = bfm.axi_if.awaddr;
                    @ (bfm.axi_if.wvalid && bfm.axi_if.wready);
                    wdata = bfm.axi_if.wdata;

                    // check with scoreboard's results
                    $display("[Checker] verify with expected results");
                    if (write_expected.addr != awaddr || write_expected.data != wdata) begin
                        $error("[Checker] results mismatched");
                        write_op.display();
                    end

                    // wait until transaction done & send to monitor
                    @ (bfm.axi_if.bvalid && bfm.axi_if.bready);
                    repeat (2) @ (negedge bfm.aclk);
                    $display("[Checker] send done to monitor");
                    checker2monitor.put(msg_done);
                end

                default: begin
                    // do nothing
                    continue;
                end
            endcase

        end
    endtask

endclass

`endif
