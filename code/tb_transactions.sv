/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines transaction classes, which stores
info for different transactions.

*/

`ifndef TB_TRANSACTIONS
`define TB_TRANSACTIONS

import tb_pkg::*;
import axi_lite_pkg::*;

// ****************************************************************************************************

/*
 * Base class for any message to exchange via mailbox
 */
class mailbox_message;

    // type of message
    msg_t msg_type;

    // constructor
    function new(msg_t msg_type = MSG_UNKNOWN);
        this.msg_type = msg_type;
    endfunction

    // display content of this message
    virtual function void display();
        $display("%s", msg_type.name);
    endfunction
    
endclass

// ****************************************************************************************************

/*
 * Class for a write transaction: RANDOM
 */
class pkt_write_rand extends mailbox_message;
    rand    bit  [31:0]	addr;   // write address
    rand    bit  [31:0]	data;   // write data

    // contraints on the write-address
    constraint awaddr_c {
        addr >  AWADDR_RAND_MIN;
        addr <= AWADDR_RAND_MAX;
    }
   
    // constructor
    function new();
        super.new(MSG_STIMULUS_READY_WRITE);
    endfunction

    // display 
    function void display();
        $display("%s: write (random), addr = %h, data = %h", msg_type.name, addr, data);
    endfunction
endclass

// ****************************************************************************************************

/*
 * Class for a write transaction: DETERMINISTIC
 */
class pkt_write extends mailbox_message;
    addr_t addr;    // write address
    data_t data;    // write data
   
    // constructor
    function new(msg_t msg_type = MSG_STIMULUS_READY_WRITE);
        super.new(msg_type);
    endfunction

    // construct this message by parsing the given string
    function build(string s);
        // TODO: change later, fixed values for now
        addr = 32'h0004;
        data = 32'hABCD;
    endfunction

    // display 
    function void display();
        $display("%s: write, addr = %h, data = %h", msg_type.name, addr, data);
    endfunction
endclass

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

`endif