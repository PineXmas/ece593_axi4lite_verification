import agent_pkg::*;

class generator;

	pkt_write	pkt_wr_h;
	pkt_read	pkt_rd_h;
	mailbox		generator2agent_wr_h, generator2agent_rd_h;
	rand generator_config g_config;
	
	function new(mailbox mbWr, mbRd);
		this.generator2agent_wr_h = mbWr;
		this.generator2agent_rd_h = mbRd;
		g_config = new();
	endfunction
	
	task generator2agent(generator_config gcfg);											//Task to pass packets to agent.
		for(int i = 0; i<gcfg.total_trx; i++)
		begin
			if((gcfg.trx_type_selected == WRITE))											//Continiuous Write Transaction
			begin
				pkt_wr_h = new();
				assert(pkt_wr_h.randomize() with {start_write == 1; start_read == 0;})
				else 
					$error("Write Transaction Packet Failed To Randomize");
				pkt_wr_h.display();
				generator2agent_wr_h.put(pkt_wr_h);
			end
			else if(gcfg.trx_type_selected == READ)											//Continiuous Read Transaction
			begin
				pkt_rd_h = new();
				assert(pkt_rd_h.randomize() with {start_read == 1; start_write == 0;})
				else
					$error("Read Transaction Packet Failed To Randomize");
				pkt_rd_h.display();
				generator2agent_rd_h.put(pkt_rd_h);
			end
			else																			//Both read and write transactions
			begin
				case(gcfg.pkt_selection)														//To switch between read and write
				0:	begin																			
						pkt_rd_h = new();
						assert(pkt_rd_h.randomize() with {start_read == 1; start_write == 0;})		//***
						else
							$error("Read Transaction Packet Failed To Randomize");
						pkt_rd_h.display();
						generator2agent_rd_h.put(pkt_rd_h);
					end
				1:	begin
						pkt_wr_h = new();
						assert(pkt_wr_h.randomize() with {start_write == 1; start_read == 0;})		//***
						else 
							$error("Write Transaction Packet Failed To Randomize");
						pkt_wr_h.display();
						generator2agent_wr_h.put(pkt_wr_h);
						assert(gcfg.randomize() with {total_trx == gcfg.total_trx; trx_type_selected == gcfg.trx_type_selected; pkt_selection == gcfg.pkt_selection;})
						else 
							$error("Randomization of addr failed!");
					end
				endcase
				gcfg.pkt_selection = ~gcfg.pkt_selection;
			end
		end
	endtask
	
/*
				pkt_rd_h = new();
				pkt_wr_h = new();													//***		Do I have to create another packet which for both read and write which has data and addr, but read will win wrt design??
				assert(pkt_rd_h.randomize())
				else
					$error("Read Transaction Packet Failed To Randomize");
				assert(pkt_wr_h.randomize())										//***
				else
					$error("Write Transaction Packet Failed To Randomize");
				pkt_rd_h.display();
				pkt_wr_h.display();												//***
				generator2agent_rd_h.put(pkt_rd_h);
//				generator2agent_wr_h.put(pkt_wr_h);								//***
/*	Does write happen??
				pkt_wr_h = new();
				assert(pkt_wr_h.randomize())
				else
					$error("Write Transaction Packet Failed To Randomize");
				pkt_wr_h.display();
				generator2agent_wr_h.put(pkt_wr_h);
				
			end
		end
	endtask
*/	
	
	task run();
		assert(g_config.randomize() with {trx_type_selected == WRITE;})				//Runs continious write transactions
		else
			$error("Configuration randomization failed on Write Transaction");
		$display("Total Transaction: %d \t Read: %d \t Write: %d",g_config.total_trx,g_config.start_read,g_config.start_write);
		generator2agent(g_config);
		
		assert(g_config.randomize() with {trx_type_selected == READ;})				//Runs continious read transactions
		else
			$error("Configuration randomization failed on Read Transaction");
		$display("Total Transaction: %d \t Read: %d \t Write: %d",g_config.total_trx,g_config.start_read,g_config.start_write);
		generator2agent(g_config);
		
		assert(g_config.randomize() with {trx_type_selected == BOTH;})				//Runs both read and write
		else
			$error("Configuration randomization failed on Write Transaction");
		$display("Total Transaction: %d \t Read: %d \t Write: %d",g_config.total_trx,g_config.start_read,g_config.start_write);
		generator2agent(g_config);
		
		
	endtask
	
endclass	
