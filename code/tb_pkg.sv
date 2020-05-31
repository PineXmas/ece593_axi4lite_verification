`timescale 1ns / 1ps

package tb_pkg;

    // clock cycle
    parameter CLOCK_CYCLE = 10;
    parameter CLOCK_WIDTH = CLOCK_CYCLE / 2;

    // type of messages exchanged between the components
    typedef enum {
        STIMULUS_READY_READ,
        STIMULUS_READY_WRITE

    } msg_t;

endpackage
