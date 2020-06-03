/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines our testbench's scoreboard,
which hold/retrieve expected results for comparing
with DUT's results

*/

import tb_pkg::*;

`ifndef TB_SCOREBOARD
`define TB_SCOREBOARD

class tb_scoreboard;

    // **************************************************
    // VARIABLES
    // **************************************************

    virtual tb_bfm	bfm;                                // bfm
    mailbox monitor2scoreboard, scoreboard2monitor;     // communication with monitor

    // **************************************************
    // METHODS
    // **************************************************

    // Constructor
    function new(virtual tb_bfm bfm, mailbox monitor2scoreboard, mailbox scoreboard2monitor);
        this.bfm = bfm;

        this.monitor2scoreboard = monitor2scoreboard;
        this.scoreboard2monitor = scoreboard2monitor;

    endfunction

    // Store/Retrieve expected results
    task run();

        // declarations
        mailbox_message msg;
        mailbox_message expected_result;
        pkt_write write_op;
        pkt_write write_result;
        pkt_read read_op;
        pkt_read read_result;

        $display("[Scoreboard] start running");

        forever begin
            
            // wait for STIMULUS_READY_READ/WRITE from monitor
            monitor2scoreboard.get(msg);
            $display("[Scoreboard] Monitor -> Scoreboard");
            msg.display();

            // record/retrieve expected result
            case(msg.msg_type)
                MSG_STIMULUS_READY_READ: begin
                    if (!$cast(read_op, msg)) begin
                        continue;
                    end
                    
                    // record expected results
                    $display("[Scoreboard] Record expected results of read-transaction");
                    read_result = new(MSG_EXPECTED_REPLY);
                    read_result.addr = read_op.addr;
                    read_result.data = read_op.data;
                    expected_result = read_result;
                end

                MSG_STIMULUS_READY_WRITE: begin
                    if (!$cast(write_op, msg)) begin
                        continue;
                    end
                    
                    // record expected results
                    $display("[Scoreboard] Record expected results of write-transaction");
                    write_result = new(MSG_EXPECTED_REPLY);
                    write_result.addr = write_op.addr;
                    write_result.data = write_op.data;
                    expected_result = write_result;
                end

                MSG_DONE_ALL: begin
                    $display("[Scoreboard] stop running");
                    break;
                end

                default: begin
                    // do nothing    
                    $display("[Scoreboard] un-expected message received: %s", msg.msg_type);
                end
            endcase

            // wait for EXPECTED_REQUEST from monitor
            $display("[Scoreboard] Wait expected-request from monitor");
            tb_monitor::wait_message(monitor2scoreboard, MSG_EXPECTED_REQUEST, msg);
            $display("[Scoreboard] Monitor -> Scoreboard: %s", msg.msg_type);

            // send EXPECTED_REPLY to monitor
            $display("[Scoreboard] Send expected-reply to monitor");
            scoreboard2monitor.put(expected_result);
        end
    endtask

endclass

`endif
