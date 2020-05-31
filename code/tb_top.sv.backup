
program tb_top(bfm bfm_if, axi_lite_if axi_if);

// // define environment
// environment env;

covergroup axi_cover @(posedge bfm_if.clock);
cp_reset: coverpoint bfm_if.reset;

//Handshaking signals coverpoints
cp_read_valid: coverpoint axi_if.rvalid;  

cp_write_valid: coverpoint axi_if.wvalid;

cp_bvalid: coverpoint axi_if.bvalid;

cp_rready: coverpoint axi_if.rready;  

cp_bready: coverpoint axi_if.bready;  

cp_start_read: coverpoint bfm_if.start_read;

cp_start_write: coverpoint bfm_if.start_write;

cp_read_resp: coverpoint axi_if.rresp;

cp_write_resp: coverpoint axi_if.bresp;

// read coverpoints
cp_read_address: coverpoint axi_if.araddr{
											bins readaddr[] = {[0:31]};
										  }

cp_read_data: coverpoint axi_if.rdata{
										bins readdata[] = {[0:31]};
									 }

// write cover points
cp_write_address: coverpoint axi_if.awaddr{
											bins writeaddr[] = {[0:31]};
										  }

cp_write_data: coverpoint axi_if.wdata{
										bins writedata[] = {[0:31]};
									  }

endgroup
      
axi_cover a_cov; //Instantiating covergroup
	
initial 
begin
	a_cov = new();
	// env.build();
	// env.run();
	// env.stat();
	$display("Coverage acquired = %0.2f %%",a_cov.get_inst_coverage());
end
endprogram