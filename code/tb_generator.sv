/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines our testbench's generator, which
generates stimulus for our testbench

*/

import tb_pkg::*;

`ifndef TB_GENERATOR
`define TB_GENERATOR

class tb_generator;

    // **************************************************
    // VARIABLES
    // **************************************************

    virtual tb_bfm	bfm;                            // bfm
    mailbox monitor2generator, generator2monitor;   // communication with monitor
    string file_path;                               // path to the test file

    // **************************************************
    // METHODS
    // **************************************************

    // Constructor
    function new(virtual tb_bfm bfm, mailbox monitor2generator, mailbox generator2monitor);
        this.bfm = bfm;

        this.monitor2generator = monitor2generator;
        this.generator2monitor = generator2monitor;

        // TODO: pass file path from command argument
        this.file_path = "test_case.txt";

    endfunction

    // Generate stimulus from the given string
    function mailbox_message gen_stimulus(string line);
        pkt_read read_op;               // in case read-transaction
        pkt_write write_op;             // in case write-transaction
        string op_type;                 // transaction type
        mailbox_message stimulus;       // final stimulus
        int n_parseds;                  // number of successful parse from sscanf

        // select type
        n_parseds = $sscanf(line, "%s", op_type);
        case(op_type)
            "WRITE": begin
                write_op = new();
                write_op.build(line);
                stimulus = write_op;
            end

            "READ": begin
                read_op = new();
                read_op.build(line);
                stimulus = read_op;    
            end

            default: begin
                stimulus = new();
            end

        endcase

        // return
        gen_stimulus = stimulus;
    endfunction

    // Generate stimulus
    task run();

        // declarations
        mailbox_message msg;            // message received from monitor
        mailbox_message msg_stimulus;   // message to send stimulus
        pkt_write write_op;             // write transaction 
        pkt_read read_op;               // read transaction
        int fd;                         // test file descriptor
        int fgets_return;               // return of fgets function
        string op_type;                 // operation/transaction type
        string line;                    // a line in the test file

        $display("[Generator] start running");

        // open test file
        fd = $fopen(file_path, "r");
        if (fd == 0) begin
            $display("[Generator] file not exist: %s", file_path);
            msg = new(MSG_DONE_GENERATING);
            generator2monitor.put(msg);
            $display("[Generator] stop running");
            return;
        end

        // generate stimulus until done
        while (!$feof(fd)) begin
            $display("****************************************************************************************************");
            
            // generate next stimulus
            $display("[Generator] generate stimulus");
            fgets_return = $fgets(line, fd);
            line = str_strip(line);
            line = line.toupper();
            if (line.len() <= 0) begin
                $display("[Generator] skip empty line");
                continue;
            end
            msg_stimulus = gen_stimulus(line);

            // send STIMULUS_READY_READ/WRITE to monitor
            generator2monitor.put(msg_stimulus);

            // wait for DONE_CHECKING from monitor
            $display("[Generator] wait for checking done");
            tb_monitor::wait_message(monitor2generator, MSG_DONE_CHECKING, msg);
            $display("[Generator] Monitor -> Generator: %s", msg.msg_type.name);

        end

        // send done to monitor
        $display("[Generator] send done generating to monitor");
        msg = new(MSG_DONE_GENERATING);
        generator2monitor.put(msg);
        $display("[Generator] stop running");

        // close test file
        $fclose(fd);

    endtask

endclass

`endif
