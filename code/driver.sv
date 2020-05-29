//Driver class responsible to drive stimulus to DUV
class driver;
	virtual axi_lite_if		ali;
	virtual bfm 			vbfm;
	pkt_write				pkt_wr;
	pkt_read				pkt_rd;
	mailbox 				agent2driver_wr_t, agent2driver_rd_t;  
	semaphore      			smph_wr;
	semaphore      			smph_rd;


function new(mailbox mbRd, mbWr, virtual bfm busfm, virtual axi_lite_if axi_if);
	this.vbfm				= busfm;
	this.ali				= axi_if;      
	this.agent2driver_wr_t	= mbWr; 
	this.agent2driver_rd_t	= mbRd;   
	smph_wr					= new(1);
	smph_rd					= new(1); 
endfunction 
  
function void init_if();		//Initialize all channels when reset asserted
	//Write channel
	vbfm.awaddr  = '0;
	vbfm.wdata   = '0;
	//Read channel
	vbfm.araddr  = '0;
endfunction

function void init_if_wr();		//Initialize Write channel after Write Transaction
	vbfm.awaddr  = '0;
	vbfm.wdata   = '0;
endfunction

function void init_if_rd();		//Initialize Read channel after Read Transaction
	vbfm.araddr  = '0;
endfunction

task wr_trx_drive_if(pkt_write pwr);
	vbfm.awaddr  = pwr.addr;
	vbfm.wdata   = pwr.data;
endtask
	
task rd_trx_drive_if(pkt_read prd);
	vbfm.araddr  = prd.addr;
endtask

task run();
	$display("Inside run function of driver");
	forever 
	begin
		@(posedge vbfm.aclk);
		if(~vbfm.areset_n) 
		begin 
			init_if(); 													//Interface intialized on reset
		end
		else 															//Reset deasserted
		begin
			fork
			begin
				smph_wr.get(1); 										//One key needed to continue, else blocked from moving ahead
//				$display("[%0t] Key received for Write Transaction", $time); 
				agent2driver_wr_t.get(pkt_wr);							//Agent to Driver transaction with write packet
//				$display("[%0t] Sending Write from driver", $time);
				pkt_wr.display(); 
				wr_trx_drive_if(pkt_wr);								//Task to drive Write Transaction stimulus to DUV
			end
			begin
				if(~ali.wready)
				begin
					$display("Next Write transaction is allowed");
					init_if_wr();
					smph_wr.put(1);
				end
			end
			begin
				smph_rd.get(1);											 //One key needed to continue, else blocked from moving ahead
//				$display("[%0t] Key received for Read Transaction", $time); 
				agent2driver_rd_t.get(pkt_rd);							//Agent to Driver transaction with read packet
//				$display("[%0t] Sending Read from driver", $time); 
				pkt_rd.display();
				rd_trx_drive_if(pkt_rd);								//Task to drive Read Transaction stimulus to DUV
			end
			begin
				if(~ali.rready)
				begin
					$display("Next Read transaction is allowed");
					init_if_rd();
					smph_rd.put(1);
				end
			end
			join_none
			if((agent2driver_wr_t.num() == 0) && (agent2driver_rd_t.num() == 0))
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