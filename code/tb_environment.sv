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

`ifndef TB_ENVIRONMENT
`define TB_ENVIRONMENT

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
        // declarations
        string file_path;       // input file path

        $display("Testbench starts building");

        // parse input file path
        file_path = parse_test_file_path();
        if (file_path.len() <= 0) begin
            $fatal("INPUT_NOT_FOUND", "Input file not provided.");
        end

        // build all components
        monitor = new(bfm);
        $display("    - Monitor built");

        generator = new(bfm, monitor.monitor2generator, monitor.generator2monitor, file_path);
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

    // Report statistics
    function void report();
        $display("Error count = %0d/%0d", checker_01.n_errors, checker_01.n_tests);
        $display("Reads       = %0d", checker_01.n_reads);
        $display("Writes      = %0d", checker_01.n_writes);
    endfunction

    // Parse command line for test file path & return
    function string parse_test_file_path();
        string file_path;

        if ($value$plusargs ("file=%s", file_path)) begin
            // do nothing since success
        end
        else begin
            file_path = "";
        end

        parse_test_file_path = file_path;
    endfunction

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

        // report stats
        $display("\n****************************************************************************************************");
        $display("REPORTS");
        $display("****************************************************************************************************\n");
        report();

    endtask

endclass

`endif
