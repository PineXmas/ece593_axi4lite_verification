class generator;

	pkt_write	pkt_wr;
	pkt_read	pkt_rd;
	mailbox		generator2agent_wr_t, generator2agent_rd_t;
	rand generator_config g_config;
	
	function new(mailbox mbWr, mbRd);
		this.generator2agent_wr_t = mbWr;
		this.generator2agent_rd_t = mbRd;
		g_config = new();
	endfunction
	
	task generator2agent(generator_config gcfg);
		for(int(i = 0;i<gcfg.total_trx;i++)
		begin
			if((gcfg.trx_type_selected == WRITE)
			begin
				pkt_wr = new();
				assert(pkt_wr.randomize() with {start_write = 1; start_read = 0;})
				else 
					$error("Write Transaction Packet Failed To Randomize");
				pkt_wr.display();
				generator2agent_wr_t.put(pkt_wr);
			end
			else if(gcfg.trx_type_selected == READ)
			begin
				pkt_rd = new();
				assert(pkt_rd.randomize() with {start_read = 1; start_write = 0;})
				else
					$error("Read Transaction Packet Failed To Randomize");
				pkt_rd.display();
				generator2agent_rd_t.put(pkt_rd);
			end
			else
			begin
				case(gcfg.pkt_selection)
				0:	begin
						pkt_rd = new();
						assert(pkt_rd.randomize() with {start_read = 1; start_write = 0;})		//***
						else
							$error("Read Transaction Packet Failed To Randomize");
						pkt_rd.display();
						generator2agent_rd_t.put(pkt_rd);
					end
				1:	begin
						pkt_wr = new();
						assert(pkt_wr.randomize() with {start_write = 1; start_read = 0;})		//***
						else 
							$error("Write Transaction Packet Failed To Randomize");
						pkt_wr.display();
						generator2agent_wr_t.put(pkt_wr);
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
				pkt_rd = new();
				pkt_wr = new();													//***		Do I have to create another packet which for both read and write which has data and addr, but read will win wrt design??
				assert(pkt_rd.randomize())
				else
					$error("Read Transaction Packet Failed To Randomize");
				assert(pkt_wr.randomize())										//***
				else
					$error("Write Transaction Packet Failed To Randomize");
				pkt_rd.display();
				pkt_wr.display();												//***
				generator2agent_rd_t.put(pkt_rd);
//				generator2agent_wr_t.put(pkt_wr);								//***
/*	Does write happen??
				pkt_wr = new();
				assert(pkt_wr.randomize())
				else
					$error("Write Transaction Packet Failed To Randomize");
				pkt_wr.display();
				generator2agent_wr_t.put(pkt_wr);
				
			end
		end
	endtask
*/	
	
	task run();
		assert(g_config.randomize() with {trx_type_selected == WRITE;})
		else
			$error("Configuration randomization failed on Write Transaction");
		$display("Total Transaction: %d \t Read: %d \t Write: %d",g_config.total_trx,g_config.start_read,g_config.start_write);
		generator2agent(g_config);
		
		assert(g_config.randomize() with {trx_type_selected == READ;})
		else
			$error("Configuration randomization failed on Read Transaction");
		$display("Total Transaction: %d \t Read: %d \t Write: %d",g_config.total_trx,g_config.start_read,g_config.start_write);
		generator2agent(g_config);
		
		assert(g_config.randomize() with {trx_type_selected == BOTH;})
		else
			$error("Configuration randomization failed on Write Transaction");
		$display("Total Transaction: %d \t Read: %d \t Write: %d",g_config.total_trx,g_config.start_read,g_config.start_write);
		generator2agent(g_config);
		
		
	endtask
	
	