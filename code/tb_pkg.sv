/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines all constants/parameters/types
that are commonly used in our testbench

*/

package tb_pkg;

    // clock cycle
    parameter CLOCK_CYCLE = 10;
    parameter CLOCK_WIDTH = CLOCK_CYCLE / 2;

    // write transaction (RANDOM)
    parameter AWADDR_RAND_MIN = 32'h5FF;
    parameter AWADDR_RAND_MAX = 32'hFFF;

    // type of messages exchanged between the components (via the mailbox)
    typedef enum {
        MSG_UNKNOWN,                    // not-defined message, used for debugging
        MSG_STIMULUS_READY_READ,        // a read transaction is ready
        MSG_STIMULUS_READY_WRITE,       // a write transaction is ready
        MSG_EXPECTED_REQUEST,           // request expected result
        MSG_EXPECTED_REPLY,             // reply with expected result
        MSG_DONE_CHECKING,              // checker has done checking
        MSG_DONE_ALL,                   // all the tests have done
        MSG_DONE_GENERATING             // generator has done generating
    } msg_t;

    // include class definitions
    `include "tb_transactions.sv";
    `include "tb_monitor.sv";
    `include "tb_generator.sv";
    `include "tb_driver.sv";
    `include "tb_checker.sv";
    `include "tb_scoreboard.sv";
    `include "tb_coverage.sv";
    `include "tb_environment.sv";

endpackage
