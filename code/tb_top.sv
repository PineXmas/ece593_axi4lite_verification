/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines the top module for our AXI4-Lite verification testbench

*/

`include "assertions.sv"
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

        $display("");
        $display("***********************************");
        $display("***   TESTBENCH has ended !!!   ***");
        $display("***********************************");
        $stop();
    end

    // bind the assert to the DUT
    bind axi_lite_dut axi_lite_Assertions axilite_assertion(bfm.aclk, bfm.areset_n, bfm.axi_if);

endmodule