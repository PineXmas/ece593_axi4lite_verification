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
    // DEFINES
    // **************************************************

    // struct for storing stimulus info
    typedef struct {
        int n_repeats;                  // number of times to repeat the stimulus
        mailbox_message msg_stimulus;   // the stimulus to send out
        bit is_random_mixed;            // the stimulus is selected randomly between read/write
    } stimulus_t;

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
    function new(virtual tb_bfm bfm, mailbox monitor2generator, mailbox generator2monitor, string file_path = "");
        this.bfm = bfm;

        this.monitor2generator = monitor2generator;
        this.generator2monitor = generator2monitor;
        this.file_path = file_path;

    endfunction

    // Generate stimulus from the given string (the string should be UPPER-case only)
    function stimulus_t gen_stimulus(string line);
        pkt_read read_op;               // in case read-transaction
        pkt_write write_op;             // in case write-transaction
        pkt_write_rand write_rand_op;   // in case random write-transaction
        pkt_read_rand read_rand_op;     // in case random read-transaction
        string op_type;                 // transaction type
        int n_parseds;                  // number of successful parse from sscanf
        int n_val;                      // value used to parse second argument in a line
        stimulus_t stimulus_info;       // final stimulus info

        // select type
        n_parseds = $sscanf(line, "%s %d", op_type, n_val);
        stimulus_info.is_random_mixed = 0;
        case(op_type)
            "WRITE": begin
                write_op = new();
                write_op.build(line);
                stimulus_info.msg_stimulus = write_op;
                stimulus_info.n_repeats = 1;
            end

            "READ": begin
                read_op = new();
                read_op.build(line);
                stimulus_info.msg_stimulus = read_op;    
                stimulus_info.n_repeats = 1;
            end

            "WRITERAND": begin
                write_rand_op = new();
                write_rand_op.build(line);
                stimulus_info.msg_stimulus = write_rand_op;
                stimulus_info.n_repeats = write_rand_op.n_repeats;
            end

            "READRAND": begin
                read_rand_op = new();
                read_rand_op.build(line);
                stimulus_info.msg_stimulus = read_rand_op;
                stimulus_info.n_repeats = read_rand_op.n_repeats;
            end

            "RAND": begin
                stimulus_info.is_random_mixed = 1;
                stimulus_info.msg_stimulus = new(MSG_STIMULUS_RAND);
                stimulus_info.n_repeats = n_val;
            end

            default: begin
                stimulus_info.msg_stimulus = new();
                stimulus_info.n_repeats = 0;
            end

        endcase

        // return
        gen_stimulus = stimulus_info;
    endfunction

    // Generate stimulus
    task run();

        // declarations
        mailbox_message msg;            // message received from monitor
        stimulus_t stimulus_info;       // info of the stimulus
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
            stimulus_info = gen_stimulus(line);
            stimulus_info.msg_stimulus.display();

            // repeat until end of this stimulus
            for (int i=0; i<stimulus_info.n_repeats; i++) begin
                
                // determine stimulus type if mixed transaction
                if (stimulus_info.is_random_mixed) begin
                    bit selected = $urandom();
                    if (selected) begin
                        pkt_write_rand stimulus;
                        stimulus = new();
                        stimulus_info.msg_stimulus = stimulus;    
                    end
                    else begin
                        pkt_read_rand stimulus;
                        stimulus = new();
                        stimulus_info.msg_stimulus = stimulus;
                    end
                end

                // randomize stimulus if needed
                if (stimulus_info.msg_stimulus.msg_type == MSG_STIMULUS_READY_WRITE_RAND) begin
                    pkt_write_rand stimulus;
                    if ($cast(stimulus, stimulus_info.msg_stimulus)) begin
                        $display("[Generator] randomize write %0d/%0d", i+1, stimulus_info.n_repeats);
                        stimulus.randomize();
                        stimulus.display();
                    end
                end
                else if (stimulus_info.msg_stimulus.msg_type == MSG_STIMULUS_READY_READ_RAND) begin
                    pkt_read_rand stimulus;
                    if ($cast(stimulus, stimulus_info.msg_stimulus)) begin
                        $display("[Generator] randomize read %0d/%0d", i+1, stimulus_info.n_repeats);
                        stimulus.randomize();
                        stimulus.display();
                    end
                end

                // send stimulus to monitor
                generator2monitor.put(stimulus_info.msg_stimulus);

                // wait for DONE_CHECKING from monitor
                $display("[Generator] wait for checking done");
                tb_monitor::wait_message(monitor2generator, MSG_DONE_CHECKING, msg);
                $display("[Generator] Monitor -> Generator: %s", msg.msg_type.name);

            end
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
