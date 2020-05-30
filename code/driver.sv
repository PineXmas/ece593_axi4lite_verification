//Driver class responsible to drive stimulus to DUV
import agent_pkg::*;
class driver;
	virtual axi_lite_if		ali;
	virtual bfm 			vbfm;
	pkt_write				pkt_wr_h;
	pkt_read				pkt_rd_h;
	mailbox 				agent2driver_wr_h, agent2driver_rd_h;  
	semaphore      			smph_wr_h;
	semaphore      			smph_rd_h;


function new(mailbox mbRd, mbWr, virtual bfm busfm, virtual axi_lite_if axi_if);
	this.vbfm				= busfm;
	this.ali				= axi_if;      
	this.agent2driver_wr_h	= mbWr; 
	this.agent2driver_rd_h	= mbRd;   
	smph_wr_h					= new(1);
	smph_rd_h					= new(1); 
endfunction 
  
function void init_if();		//Initialize all channels when reset asserted
	vbfm.addr  			= '0;
	vbfm.data   		= '0;
	vbfm.start_read 	= '0;
	vbfm.start_write  	= '0;
endfunction

function void init_if_wr();		//Initialize Write channel after Write Transaction
	vbfm.addr			= '0;
	vbfm.data   		= '0;
	vbfm.start_write	= '0;
endfunction

function void init_if_rd();		//Initialize Read channel after Read Transaction
	vbfm.addr  		= '0;
	vbfm.data		= '0;
	vbfm.start_read	= '0;
endfunction

task wr_trx_drive_if(pkt_write pwr);			//Driving write transaction to DUV
	vbfm.addr  			= pwr.addr;
	vbfm.data   		= pwr.data;
	vbfm.start_write	= pwr.start_write;
endtask
	
task rd_trx_drive_if(pkt_read prd);				//Driving read transaction to DUV
	vbfm.addr  		= prd.addr;
	vbfm.start_read	= prd.start_read;
endtask

task run();
	$display("Inside run function of driver");
	forever 
	begin
		@(posedge vbfm.aclk);
		if(~vbfm.areset_n) 
		begin 
			init_if(); 													//Interface intialized on reset
			repeat (1000) @(posedge vbfm.aclk);							//delay for slave memory to clear out completely.
		end
		else 															//Reset deasserted
		begin
			fork
			begin
				smph_wr_h.get(1); 										//One key needed to continue, else blocked from moving ahead
//				$display("[%0t] Key received for Write Transaction", $time); 
				agent2driver_wr_h.get(pkt_wr_h);							//Agent to Driver transaction with write packet
//				$display("[%0t] Sending Write from driver", $time);
				pkt_wr_h.display(); 
				wr_trx_drive_if(pkt_wr_h);								//Task to drive Write Transaction stimulus to DUV
			end
			begin
				if((~ali.bvalid) && (~ali.awvalid) && (~ali.wvalid))	//Write transaction completed and permits for next transaction
				begin
					$display("Next Write transaction is allowed");
					init_if_wr();
					smph_wr_h.put(1);
				end
			end
			begin
				smph_rd_h.get(1);											 //One key needed to continue, else blocked from moving ahead
//				$display("[%0t] Key received for Read Transaction", $time); 
				agent2driver_rd_h.get(pkt_rd_h);							//Agent to Driver transaction with read packet
//				$display("[%0t] Sending Read from driver", $time); 
				pkt_rd_h.display();
				rd_trx_drive_if(pkt_rd_h);								//Task to drive Read Transaction stimulus to DUV
			end
			begin
				if((~ali.rready) && (~ali.arready))						//Read transaction completed and permits for next transaction
				begin
					$display("Next Read transaction is allowed");
					init_if_rd();
					smph_rd_h.put(1);
				end
			end
			join_none
			if((agent2driver_wr_h.num() == 0) && (agent2driver_rd_h.num() == 0))
			begin
				init_if();
				disable fork;  
				break;
			end
		end
	end
	$display("End of driver run phase!");
endtask
endclass
