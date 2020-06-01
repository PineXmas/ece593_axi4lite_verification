/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines our testbench's environment,
which contains all other testbench's components
and acts as the main entrance for our testbench

*/

import tb_pkg::*;
`include "tb_monitor.sv";
`include "tb_generator.sv";
`include "tb_driver.sv";
`include "tb_checker.sv";
`include "tb_scoreboard.sv";
`include "tb_coverage.sv";

class tb_environment;

    // **************************************************
    // VARIABLES
    // **************************************************

    virtual tb_bfm bfm;         // BFM
    tb_monitor monitor;         // monitor
    tb_generator generator;     // generator
    tb_driver driver;           // driver
    tb_checker checker_01;      // checker (use name "checker_01" to avoid keyword "checker")
    tb_scoreboard scoreboard;   // scoreboard
    tb_coverage coverage;       // coverage

    // **************************************************
    // METHODS
    // **************************************************

    // Constructor
    function new(virtual tb_bfm bfm);
        this.bfm = bfm;
    endfunction

    // Build all components
    task build();
        $display("Testbench starts building");

        monitor = new(bfm);
        $display("    - Monitor built");

        generator = new(bfm, monitor.monitor2generator, monitor.generator2monitor);
        $display("    - Generator built");

        driver = new(bfm, monitor.monitor2driver, monitor.driver2monitor);
        $display("    - Driver built");

        checker_01 = new(bfm, monitor.monitor2checker, monitor.checker2monitor);
        $display("    - Checker built");

        scoreboard = new(bfm, monitor.monitor2scoreboard, monitor.scoreboard2monitor);
        $display("    - Scoreboard built");

        coverage = new(bfm, monitor.monitor2coverage, monitor.coverage2monitor);
        $display("    - Coverage built");
    endtask

    // Start the whole testbench
    task run();
        $display("Testbench starts running");

        // reset DUT
        bfm.reset_dut();

        // start running each component in a separate thread
        fork
            monitor.run();
            generator.run();
            driver.run();
            checker_01.run();
            scoreboard.run();
            coverage.run();
        join

    endtask

endclass