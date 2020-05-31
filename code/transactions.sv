//Class for write operation during write transaction
import agent_pkg::*;

class pkt_write;
	rand 	bit  		start_write;
	rand	bit			start_read;
	rand	bit  [31:0]	addr;
	rand	bit  [31:0]	data;				 

	constraint awaddr_c{		//****
		addr >  32'h5ff;
		addr <= 32'hfff;
	}
   
	function void display();
		$display("Write Request from Master:: addr = %b, data = %b", addr, data);
	endfunction
endclass

//Class for read operation during read transaction
class pkt_read;
	rand	bit			start_write;
	rand	bit			start_read;
	rand	bit	[31:0]	addr;	     

	constraint araddr_c{		//****
		addr >  32'h5ff;			
		addr <= 32'hfff;
	}

	function void display();
		$display("Read request from Master:: addr = %b", addr);
	endfunction
endclass

//Class for write response monitor during write transaction
class pkt_write_resp;
	bit[1:0]   bresp;
   
	function void wr_resp_display();
		$display("Master Received Write Response from Slave:: bresp = %b", bresp);
	endfunction
endclass

//Class for axi read response monitor during read transaction
class pkt_read_resp;
	bit[31:0]  rdata;
	bit[1:0]   rresp;
   
	function void rd_resp_display();
		$display("Master Received Read Response from Slave:: rdata = %b, rresp = %b", rdata, rresp);
	endfunction
endclass
	
/*	
//Class for axi write
class pkt_write_internal;
	bit [31:0]  awaddr;
	bit [31:0]	wdata;
   
	function void wr_intrl_display();
		$display("Master sending out data to Slave:: awaddr = %h, wdata = %h", awaddr, wdata);
	endfunction	
endclass
*/
