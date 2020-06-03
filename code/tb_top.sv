/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines the top module for our AXI4-Lite verification testbench

*/

import tb_pkg::*;

module tb_top;
    
    // **************************************************
    // INSTANCES
    // **************************************************

    // BFM
    tb_bfm bfm();

    // DUT
    axi_lite_dut dut(
        .aclk(bfm.aclk),
        .areset_n(bfm.areset_n),
        .start_read(bfm.start_read),
        .start_write(bfm.start_write),
        .addr(bfm.addr),
        .data(bfm.data),
        .axi_if(bfm.axi_if)
    );

    // Testbench
    tb_environment env;

    // **************************************************
    // LOGIC
    // **************************************************

    initial 
    begin

        env = new(bfm);
        env.build();
        env.run();

        // TODO: debug now, remove later
        # 1000;
        $display("");
        $display("******************************************");
        $display("***   Auto stop after 1000 ticks !!!   ***");
        $display("******************************************");
        $stop();
    end
endmodule