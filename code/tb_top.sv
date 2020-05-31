/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines the top module for our AXI4-Lite verification testbench

*/

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


    // **************************************************
    // LOGIC
    // **************************************************

    initial 
    begin
        // env new

        // env build

        // env run

        $stop();
    end
endmodule