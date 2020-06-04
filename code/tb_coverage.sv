/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines our testbench's coverage, which
samples & computes statistics of the DUT's coverage

*/

import tb_pkg::*;

`ifndef TB_COVERAGE
`define TB_COVERAGE

class tb_coverage;

    // **************************************************
    // VARIABLES
    // **************************************************

    virtual tb_bfm	bfm;                            // bfm
    mailbox monitor2coverage, coverage2monitor;     // communication with monitor

    // **************************************************
    // METHODS
    // **************************************************

    // Constructor
    function new(virtual tb_bfm bfm, mailbox monitor2coverage, mailbox coverage2monitor);
        this.bfm = bfm;

        this.monitor2coverage = monitor2coverage;
        this.coverage2monitor = coverage2monitor;

    endfunction
															//************* addition from here ***************
	covergroup axi_cover @(posedge bfm.aclk);
	cp_reset: 			coverpoint bfm.areset_n;

	//Handshaking signals coverpoints
	cp_rready: 			coverpoint bfm.rready;

	cp_arready: 		coverpoint bfm.arready;

	cp_arvalid: 		coverpoint bfm.arvalid;

	cp_rvalid: 			coverpoint bfm.rvalid;

	cp_rresp: 			coverpoint bfm.rresp;  

	cp_awready: 		coverpoint bfm.awready;

	cp_wready: 			coverpoint bfm.wready;

	cp_wvalid: 			coverpoint bfm.wvalid;

	cp_awvalid: 		coverpoint bfm.awvalid;

	cp_bvalid: 			coverpoint bfm.bvalid;  

	cp_bready: 			coverpoint bfm.bready; 
	
	cp_bresp:	 		coverpoint bfm.bresp; 

	cp_start_read: 		coverpoint bfm.start_read;

	cp_start_write: 	coverpoint bfm.start_write;

	// read coverpoints
	cp_read_address: 	coverpoint bfm.araddr{
											bins readaddr[] = {[0:31]};
												}

	cp_read_data: 		coverpoint bfm.rdata	{
											bins readdata[] = {[0:31]};
												}

	// write cover points
	cp_write_address: 	coverpoint bfm.awaddr{
											bins writeaddr[] = {[0:31]};
												}

	cp_write_data: 		coverpoint bfm.wdata	{
											bins writedata[] = {[0:31]};
												}

	//cross coverage
	reset_x_start_read: 		cross cp_reset, cp_start_read;

	reset_x_start_write: 		cross cp_reset, cp_start_write;

	start_read_x_start_write:	cross cp_start_read, cp_start_write;

	arvalid_x_read_address:		cross cp_arvalid, cp_read_address	{
													ignore_bins ignore_arvalid_x_read_address with (cp_arvalid < 1);
																	}
																
	awvalid_x_write_address:	cross cp_awvalid, cp_write_address	{
													ignore_bins ignore_awvalid_x_write_address with (cp_awvalid < 1);
																	}
																
	wvalid_x_write_data:		cross cp_wvalid, cp_write_data		{
													ignore_bins ignore_wvalid_x_write_data with (cp_wvalid < 1);
																	}
																
	rvalid_x_read_data:			cross cp_rvalid, cp_read_data		{
													ignore_bins ignore_rvalid_x_read_data with (cp_rvalid < 1);
																	}
																
	awvalid_x_awready : 		cross cp_awvalid, cp_awready 		{
													function CrossQueueType IgnoreBins_addr_w();
													// Iterate over all bins
													for (int xx=0; xx<2; xx++)
													begin
														for (int yy=0; yy<2; yy++)
														begin
															if (((xx == 0) && (yy == 1)) || ((xx == 1) && (yy == 0)))
															// Ignore this bin
															IgnoreBins_addr_w.push_back('{xx,yy});
															else
															// This is a valid bin
															continue;
														end
													end
													endfunction

													ignore_bins ignore_awvalid_x_awready = IgnoreBins_addr_w();
																	}
																
	wvalid_x_wready : 			cross cp_wvalid, cp_wready 			{
													function CrossQueueType IgnoreBins_data_w();
													// Iterate over all bins
													for (int xx=0; xx<2; xx++)
													begin
														for (int yy=0; yy<2; yy++)
														begin
															if (((xx == 0) && (yy == 1)) || ((xx == 1) && (yy == 0)))
															// Ignore this bin
															IgnoreBins_data_w.push_back('{xx,yy});
															else
															// This is a valid bin
															continue;
														end
													end
													endfunction

													ignore_bins ignore_wvalid_x_wready = IgnoreBins_data_w();
																	}
																
	bvalid_x_bready : 			cross cp_bvalid, cp_bready 			{
													function CrossQueueType IgnoreBins_write_resp();
													// Iterate over all bins
													for (int xx=0; xx<2; xx++)
													begin
														for (int yy=0; yy<2; yy++)
														begin
															if (((xx == 0) && (yy == 1)) || ((xx == 1) && (yy == 0)))
															// Ignore this bin
															IgnoreBins_write_resp.push_back('{xx,yy});
															else
															// This is a valid bin
															continue;
														end
													end
													endfunction

													ignore_bins ignore_bvalid_x_bready = IgnoreBins_write_resp();
																	}

	arvalid_x_arready : 		cross cp_arvalid, cp_arready 		{
													function CrossQueueType IgnoreBins_addr_r();
													// Iterate over all bins
													for (int xx=0; xx<2; xx++)
													begin
														for (int yy=0; yy<2; yy++)
														begin
															if (((xx == 0) && (yy == 1)) || ((xx == 1) && (yy == 0)))
															// Ignore this bin
															IgnoreBins_addr_r.push_back('{xx,yy});
															else
															// This is a valid bin
															continue;
														end
													end
													endfunction

													ignore_bins ignore_arvalid_x_arready = IgnoreBins_addr_r();
																	}
																
	rvalid_x_rready : 			cross cp_rvalid, cp_rready 			{
													function CrossQueueType IgnoreBins_data_r();
													// Iterate over all bins
													for (int xx=0; xx<2; xx++)
													begin
														for (int yy=0; yy<2; yy++)
														begin
															if (((xx == 0) && (yy == 1)) || ((xx == 1) && (yy == 0)))
															// Ignore this bin
															IgnoreBins_data_r.push_back('{xx,yy});
															else
															// This is a valid bin
															continue;
														end
													end
													endfunction

													ignore_bins ignore_rvalid_x_rready = IgnoreBins_data_r();
																	}														
	endgroup
      
	axi_cover a_cov; //Instantiating covergroup	
																//************* addition ends here ***************

    // Sample & compute coverage
    task run();
		
        // declarations
        mailbox_message msg;

        $display("[Coverage] start running");

        forever begin
            
            // wait for STIMULUS_READY_READ/WRITE from monitor
            monitor2coverage.get(msg);
            $display("[Coverage] Monitor -> Coverage");
            msg.display();

            // break if DONE_ALL is received
            if (msg.msg_type == MSG_DONE_ALL) begin
                $display("[Coverage] stop running");
                break;
            end

            // sample signals for coverage
            $display("[Coverage] sample for coverage");
            
        end

    endtask

endclass

`endif
