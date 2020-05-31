import tb_pkg::*;

// Base class for any message to exchange via mailbox
class Message;

	// type of message
	msg_t msg_type;
	
endclass

// //Class for write operation during write transaction: RANDOM
// class pkt_write;
// 	rand 	bit  		start_write;
// 	rand	bit			start_read;
// 	rand	bit  [31:0]	addr;
// 	rand	bit  [31:0]	data;				 

// 	constraint awaddr_c{		//****
// 		addr >  32'h5ff;
// 		addr <= 32'hfff;
// 	}
   
// 	function void display();
// 		$display("Write Request from Master:: addr = %b, data = %b", addr, data);
// 	endfunction
// endclass

// //Class for read operation during read transaction
// class pkt_read;
// 	rand	bit			start_write;
// 	rand	bit			start_read;
// 	rand	bit	[31:0]	addr;	     

// 	constraint araddr_c{		//****
// 		addr >  32'h5ff;			
// 		addr <= 32'hfff;
// 	}

// 	function void display();
// 		$display("Read request from Master:: addr = %b", addr);
// 	endfunction
// endclass

