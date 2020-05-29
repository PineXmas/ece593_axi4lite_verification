//Generator and Driver communication is done by agent class
class agent;
mailbox generator2agent_rd_t, generator2agent_wr_t,             //generator to agent for read and write operation
		agent2driver_rd_t, agent2driver_wr_t;             		//agent to driver for read and write operation
mailbox agent2sboard_rd_t, agent2sboard_wr_t;             		//agent to scoreboard for read and write operation
pkt_read  pkt_rd;
pkt_write pkt_wr;

//Function for creation of new objects
function new(mailbox gen_agt_mbRd, gen_agt_mbWr, agt_dri_mbRd, agt_dri_mbWr, agt_scb_mbRd, agt_scb_mbWr);
	this.generator2agent_rd_t	= gen_agt_mbRd;
	this.generator2agent_wr_t 	= gen_agt_mbWr;
	this.agent2driver_rd_t 		= agt_dri_mbRd;
	this.agent2driver_wr_t 		= agt_dri_mbWr;
	this.agent2sboard_rd_t 		= agt_scb_mbRd;
	this.agent2sboard_wr_t 		= agt_scb_mbWr;
endfunction

// Task for agent communication between generator and driver
task run();
	$display("Inside run of agent");    //**debug then remove
	fork
	begin
		forever                    //***always ??
		begin
			//Write channel
            if(generator2agent_wr_t.num() != 0)
			begin
				generator2agent_wr_t.get(pkt_wr);               		//agent gets transaction from generator
				$display( "[%0t] Got Write packet at agent", $time);    //**debug then remove
				agent2driver_wr_t.put(pkt_wr);                			//agent sends transaction to driver
				agent2sboard_wr_t.put(pkt_wr);                			//agent sends transaction to scoreboard
			end
			else
				break;    					
		end
	end
	begin
		forever                    //***always ??
		begin
			//Read channel
			if(generator2agent_rd_t.num() != 0)
			begin
				generator2agent_rd_t.get(pkt_rd);            		 //agent gets transaction from generator
				$display("[%0t] Got Read packet at agent", $time);   //debug then remove
				agent2driver_rd_t.put(pkt_rd);             			//agent sends transaction to driver
				agent2sboard_rd_t.put(pkt_rd);             			//agent sends transaction to scoreboard
			end
			else
				break; 
		end
	end
	join
	$display("End of agent run phase");   //**debug then remove
endtask
endclass
