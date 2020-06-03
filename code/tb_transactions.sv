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
    rand addr_t	addr;   // write address
    rand data_t	data;   // write data

    // contraints on the write-address
    constraint awaddr_c {
        addr >= AWADDR_RAND_MIN;
        addr <= AWADDR_RAND_MAX;
    }
   
    // constructor
    function new(msg_t msg_type = MSG_STIMULUS_READY_WRITE);
        super.new(msg_type);
    endfunction

    // display 
    function void display();
        $display("%s: write (random), addr = %h, data = %h", msg_type.name, addr, data);
    endfunction
endclass

// ****************************************************************************************************

/*
 * Class for a write transaction: DETERMINISTIC
 * Could be used to store expected result of a write transaction
 */
class pkt_write extends mailbox_message;
    addr_t addr;    // write address
    data_t data;    // write data
   
    // constructor
    function new(msg_t msg_type = MSG_STIMULUS_READY_WRITE);
        super.new(msg_type);
    endfunction

    // construct this message by parsing the given string
    function void build(string s);
        $sscanf(s, "WRITE %h %h", addr, data);
    endfunction

    // display 
    function void display();
        $display("%s: write, addr = %h, data = %h", msg_type.name, addr, data);
    endfunction
endclass

// ****************************************************************************************************

/*
 * Class for a read transaction: DETERMINISTIC
 * Could be used to store expected result of a read transaction
 */
class pkt_read extends mailbox_message;
	addr_t addr;    // read address
    data_t data;    // expected data read

    // constructor
    function new(msg_t msg_type = MSG_STIMULUS_READY_READ);
        super.new(msg_type);
    endfunction

    // construct this message by parsing the given string
    function void build(string s);
        $sscanf(s, "READ %h %h", addr, data);
    endfunction

    // display 
    function void display();
        $display("%s: read, addr = %h, expect-data = %h", msg_type.name, addr, data);
    endfunction
endclass

// ****************************************************************************************************

/*
 * Class for a read transaction: RANDOM
 */
class pkt_read_rand extends mailbox_message;
	rand addr_t	addr;	     

    // contraints on the read-address
    constraint awaddr_c {
        addr >= AWADDR_RAND_MIN;
        addr <= AWADDR_RAND_MAX;
    }
   
    // constructor
    function new(msg_t msg_type = MSG_STIMULUS_READY_READ);
        super.new(msg_type);
    endfunction

    // display 
    function void display();
        $display("%s: read (random), addr = %h", msg_type.name, addr);
    endfunction
endclass

`endif