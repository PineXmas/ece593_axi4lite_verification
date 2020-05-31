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

    // type of messages exchanged between the components (via the mailbox)
    typedef enum {
        NOT_DEFINED,                // not-defined message, used for debugging
        STIMULUS_READY_READ,        // a read transaction is ready
        STIMULUS_READY_WRITE,       // a write transaction is ready
        EXPECTED_REQUEST,           // request expected result
        EXPECTED_REPLY,             // reply with expected result
        DONE_CHECKING               // checker has done checking
    } msg_t;

endpackage
