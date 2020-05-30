/* Monitor class: to monitor the interface from the DUT and pass to checker  */
import agent_pkg::*;

class monitor;
	virtual axi_lite_if	al_if_h;           							//Virtual axi interface handle
    virtual bfm 		v_bfm_h;     									//Virtual bfm interface handle
    mailbox 			monitor2sboard_rd_h, monitor2sboard_wr_h;   //mailbox handle
    static bit done_sig;    
	int count_idle_st = 0;

    
	function new(virtual axi_lite_if ali, virtual bfm vbfm, mailbox monitor2sboard_wr_t, monitor2sboard_rd_t);
		this.al_if_h 				= ali;
		this.v_bfm_h    			= vbfm;
		this.monitor2sboard_wr_h	= monitor2sboard_wr_t;
		this.monitor2sboard_rd_h   	= monitor2sboard_rd_t;
	endfunction

    task run();														//task to pass response packet of read and write to scoreboard
		done_sig = 0;
        forever 
		begin
			pkt_write_resp  wr_resp_h; 			
			pkt_read_resp 	rd_resp_h; 			

			@(posedge v_bfm_h.aclk);  			
			if(al_if_h.bvalid)										//Captures write response
			begin
				wr_resp_h = new();
                wr_resp_h.bresp = al_if_h.bresp;
                monitor2sboard_wr_h.put(wr_resp_h);
				count_idle_st = 0;
            end
            if(al_if_h.rvalid)										//Captures read response
			begin
				rd_resp_h = new();
				rd_resp_h.rdata = al_if_h.rdata;
                rd_resp_h.rresp = al_if_h.rresp;
                monitor2sboard_rd_h.put(rd_resp_h);
                count_idle_st = 0;
            end
            
            if(al_if_h.bvalid == 0 && al_if_h.rvalid == 0)			//If the interface is idle
               count_idle_st += 1;
            
            if(count_idle_st == 60)
				break;
        end
        done_sig = 1;	
    endtask
endclass
