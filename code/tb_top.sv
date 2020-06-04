
program tb_top(bfm bfm_if, axi_lite_if axi_if);
environment env;

covergroup axi_cover @(posedge bfm_if.clock);
cp_reset: 			coverpoint bfm_if.reset;

//Handshaking signals coverpoints
cp_rready: 			coverpoint axi_if.rready;

cp_arready: 		coverpoint axi_if.arready;

cp_arvalid: 		coverpoint axi_if.arvalid;

cp_rvalid: 			coverpoint axi_if.rvalid;

cp_rresp: 			coverpoint axi_if.rresp;  

cp_awready: 		coverpoint axi_if.awready;

cp_wready: 			coverpoint axi_if.wready;

cp_wvalid: 			coverpoint axi_if.wvalid;

cp_awvalid: 		coverpoint axi_if.awvalid;

cp_bvalid: 			coverpoint axi_if.bvalid;  

cp_bready: 			coverpoint axi_if.bready; 
	
cp_bresp:	 		coverpoint axi_if.bresp; 

cp_start_read: 		coverpoint bfm_if.start_read;

cp_start_write: 	coverpoint bfm_if.start_write;

// read coverpoints
cp_read_address: 	coverpoint axi_if.araddr{
										bins readaddr[] = {[0:31]};
											}

cp_read_data: 		coverpoint axi_if.rdata{
										bins readdata[] = {[0:31]};
											}

// write cover points
cp_write_address: 	coverpoint axi_if.awaddr{
										bins writeaddr[] = {[0:31]};
											}

cp_write_data: 		coverpoint axi_if.wdata{
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
	
initial 
begin
	a_cov = new();
	env.build();
	env.run();
	env.stat();
	$display("Coverage acquired = %0.2f %%",a_cov.get_inst_coverage());
end
endprogram
