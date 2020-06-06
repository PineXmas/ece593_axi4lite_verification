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
    int n_errors;                               // error count
    int n_tests;                                // number of tests
    int n_writes, n_reads;                      // number of write/read transactions

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
        mailbox_message msg;            // message received from monitor
        mailbox_message msg_done;       // send DONE_CHECKING signal
        pkt_write write_expected;       // expected result for write-transaction
        pkt_read read_expected;         // expected result for read-transaction
        data_t wdata, rdata;            // write/read data from DUT
        addr_t awaddr, araddr;          // write/read address from DUT

        $display("[Checker] start running");

        // setup
        msg_done = new(MSG_DONE_CHECKING);
        n_errors = 0;
        n_tests = 0;
        n_reads = 0;
        n_writes = 0;

        forever begin
            
            // wait for STIMULUS_READY_READ/WRITE from monitor
            monitor2checker.get(msg);
            $display("[Checker] Monitor -> Checker");
            msg.display();

            case(msg.msg_type)

                // *** READ TRANSACTION ***
                MSG_STIMULUS_READY_READ,
                MSG_STIMULUS_READY_READ_RAND: begin
                    ++n_tests;
                    ++n_reads;

                    // send EXPECTED_REQUEST to monitor
                    $display("[Checker] send expected-request to monitor");
                    msg = new(MSG_EXPECTED_REQUEST);
                    checker2monitor.put(msg);

                    // wait EXPECTED_REPLY from monitor
                    $display("[Checker] wait expected-reply from monitor");
                    tb_monitor::wait_message(monitor2checker, MSG_EXPECTED_REPLY, msg);
                    $display("[Checker] Monitor -> Checker: %s", msg.msg_type);
                    msg.display();
                    if (!$cast(read_expected, msg)) begin
                        $fatal("[Checker] Cannot cast to pkt_read");
                    end

                    // wait until read result is available
                    $display("[Checker] Check done-signal of read-transaction");
                    repeat (CHECKER_WAIT_MAX) @ (negedge bfm.aclk) if (bfm.axi_if.arvalid && bfm.axi_if.arready) break;
                    araddr = bfm.axi_if.araddr;
                    repeat (CHECKER_WAIT_MAX) @ (negedge bfm.aclk) if (bfm.axi_if.rvalid && bfm.axi_if.rready) break;
                    rdata = bfm.axi_if.rdata;

                    // check with scoreboard's results
                    $display("[Checker] verify with expected results");
                    if (read_expected.addr != araddr || read_expected.data != rdata) begin
                        $error("[Checker] results mismatched");
                        msg.display();
                        n_errors += 1;
                    end

                    // wait until transaction done & send to monitor
                    repeat (CHECKER_WAIT_MAX) @ (negedge bfm.aclk) if ((~bfm.axi_if.rvalid) && (~bfm.axi_if.rready)) break;
                    repeat (2) @ (negedge bfm.aclk);
                    $display("[Checker] send done to monitor");
                    checker2monitor.put(msg_done);
                end

                // *** WRITE TRANSACTION ***
                MSG_STIMULUS_READY_WRITE,
                MSG_STIMULUS_READY_WRITE_RAND: begin
                    ++n_tests;
                    ++n_writes;

                    // send EXPECTED_REQUEST to monitor
                    $display("[Checker] send expected-request to monitor");
                    msg = new(MSG_EXPECTED_REQUEST);
                    checker2monitor.put(msg);

                    // wait EXPECTED_REPLY from monitor
                    $display("[Checker] wait expected-reply from monitor");
                    tb_monitor::wait_message(monitor2checker, MSG_EXPECTED_REPLY, msg);
                    $display("[Checker] Monitor -> Checker: %s", msg.msg_type);
                    msg.display();
                    if (!$cast(write_expected, msg)) begin
                        $fatal("[Checker] Cannot cast to pkt_write");
                    end

                    // wait until write result is available
                    $display("[Checker] Check done-signal of write-transaction");
                    repeat (CHECKER_WAIT_MAX) @ (negedge bfm.aclk) if (bfm.axi_if.awvalid && bfm.axi_if.awready) break;
                    awaddr = bfm.axi_if.awaddr;
                    repeat (CHECKER_WAIT_MAX) @ (negedge bfm.aclk) if (bfm.axi_if.wvalid && bfm.axi_if.wready) break;
                    wdata = bfm.axi_if.wdata;

                    // check with scoreboard's results
                    $display("[Checker] verify with expected results");
                    if (write_expected.addr != awaddr || write_expected.data != wdata) begin
                        $error("[Checker] results mismatched");
                        msg.display();
                        n_errors += 1;
                    end

                    // wait until transaction done & send to monitor
                    repeat (CHECKER_WAIT_MAX) @ (negedge bfm.aclk) if (bfm.axi_if.bvalid && bfm.axi_if.bready) break;
                    repeat (2) @ (negedge bfm.aclk);
                    $display("[Checker] send done to monitor");
                    checker2monitor.put(msg_done);
                end

                // *** ALL DONE ***
                MSG_DONE_ALL: begin
                    $display("[Checker] stop running");
                    break;
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
