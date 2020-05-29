/* Config to pass to generator */
import agent_pkg::*;

class generator_config;
   rand int   total_trx;				//Number of Transactions
   rand operation  trx_type_selected;	//Type of Transaction selection
   rand bit   pkt_selction; 			//Selecting of READ or WRITE when interleaving transaction
   rand bit [31:0] addr;

   constraint addr_range_c{			//*****Check addr range*****//
      addr  > 32'h5ff;
      addr <= 32'hfff;
   }

   constraint total_trx_c{
      soft total_trx inside {[1:100]};
   }

   //0: READ, 1: WRITE, 2: BOTH
   constraint trx_type_selected_c{
      trx_type_selected inside {WRITE, READ, BOTH};
   }
endclass
