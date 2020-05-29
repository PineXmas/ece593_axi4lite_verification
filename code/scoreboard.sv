/*Scoreboard class: Generates expected output and does the check with response packet */
import agent_pkg::*;

class scoreboard; 
mailbox  agent2sboard_rd_h, agent2sboard_wr_h, monitor2sboard_rd_h, monitor2sboard_wr_h;		//mailbox handles to scoreboard from agent and monitor
int write_count;																
int read_count;
int error_count;
int total_trx;
int  sb_mem_buffer [32];																		//Scoreboard memory to store and keep track of data for the required address
	
pkt_read   	pkt_rd_que_h[$];																	//Read Transaction packets queue
pkt_write  	pkt_wr_que_h[$];																	//Write Transaction packets queue

pkt_write	wr_temp_h;																			
pkt_read	rd_temp_h;

event wr_t;
event rd_t;
	
function new(mailbox mbRd, mbWr, mon_sbRd, mon_sbWr);
	this.agent2sboard_wr_h		= mbWr;
	this.agent2sboard_rd_h		= mbRd;
	this.monitor2sboard_wr_h	= mon_sbWr;
	this.monitor2sboard_rd_h   	= mon_sbRd;
	foreach(sb_mem_buffer[i])
		sb_mem_buffer = '0;
endfunction

task run();
	fork 
		agent2sboard_wr_pkt();
		agent2sboard_rd_pkt();
		monitor2sboard_wr_pkt();
		monitor2sboard_rd_pkt();
	join
endtask

task agent2sboard_wr_pkt();										//Task to collect the write packets from the agent
	forever 
	begin
		pkt_write pkt_wr_h;
		void'(agent2sboard_wr_h.try_get(pkt_wr_h));
		if(pkt_wr_h != null)
		begin
			pkt_wr_que_h.push_back(pkt_wr_h);
			->wr_t;				
			write_count += 1;
		end
		if(monitor::done_sig == 1) 
			break;
		#1;
	end
endtask
	
task agent2sboard_rd_pkt();										//Task to collect the read packets from the agent
	forever
	begin
		pkt_read  pkt_rd_h;
		void'(agent2sboard_rd_h.try_get(pkt_rd_h));
		if(pkt_rd_h != null)
		begin 
			pkt_rd_que_h.push_back(pkt_rd_h);
			->rd_t;
			read_count += 1;
		end
		if(monitor::done_sig == 1)
			break;
		#1;
	end
endtask

task monitor2sboard_wr_pkt();									//Task to collect write response packets and store the data of the address.
	forever
	begin
		pkt_write_resp 	wr_resp_h;
		void'(monitor2sboard_wr_h.try_get(wr_resp_h));
		if(wr_resp_h != null)
		begin
			if(wr_resp_h.bresp == 0)
			begin
				wait(wr_t.triggered);
				wr_temp_h = pkt_wr_que_h[$];
				if((wr_temp_h.start_write == 1) && (wr_temp_h.start_read == 0))			// Condition to store data in scoreboard buffer memory
				begin
					sb_mem_buffer[wr_temp_h.addr] = wr_temp_h.data;						//store data in scoreboard buffer memory
				end
				else
				begin
					$display("Error in write transaction, addr: %h \t data: %h \n",wr_temp_h.addr,wr_temp_h.data);	//Error pops up if invalid address
					error_count += 1;
				end
			end
			else
			begin
				$display("Error in write transaction, addr: %h \t data: %h \n",wr_temp_h.addr,wr_temp_h.data);		//Error pops up if invalid write transaction
				error_count += 1;
			end
		end
		if(monitor::done_sig == 1)
			break;
		#1;
	end
endtask
	
task monitor2sboard_rd_pkt();													//Task to collect read response packets and store the data of the address.
	forever
	begin
		pkt_read_resp 	rd_resp_h;
		void'(monitor2sboard_rd_h.try_get(rd_resp_h));
		if(rd_resp_h != null)
		begin
			if(rd_resp_h.rresp == 0)
			begin
				wait(rd_t.triggered);
				rd_temp_h = pkt_rd_que_h[$];
				if(rd_temp_h.start_read)												// Condition to read data form scoreboard buffer memory
				begin
					if(rd_resp_h.rdata != sb_mem_buffer[rd_temp_h.addr])				//Check to make sure data written to the address by the master is the same as the data provided to the master by the slave on read 
					begin
						$display("Error in read transaction, addr: %h \t data: %h",rd_temp_h.addr,rd_temp_h.data);		//If mismatch in data error
						error_count += 1;
					end
					else
					begin
						$display("Right data read, addr: %h \t data: %h",rd_temp_h.addr,rd_temp_h.data);
					end
				end
				else
				begin
					$display("Error in read transaction, addr: %h \t data: %h \n",rd_temp_h.addr,rd_temp_h.data);		//Error pops up if invalid address
					error_count += 1;
				end
			end
			else
			begin
				$display("Error in read transaction, addr: %h \t data: %h \n",rd_temp_h.addr,rd_temp_h.data);			//Error pops up if invalid read transaction
				error_count += 1;
			end
		end
		if(monitor::done_sig == 1)
			break;
		#1;
	end
endtask
	
task stats();
	if(error_count)
	begin
		$display("\n******Errors found!!! Test unsuccessful with %0d errors******", error_count);
	end
    else 
	begin
		$display("******No errors, Test Successful!!******");
	end
    $display("******Scoreboard Result******");
	$display("Total transactions: %0d", (read_count+write_count));
	$display("Number of Reads : %0d", read_count);
    $display("Number of Writes : %0d", write_count);
endtask
endclass 
