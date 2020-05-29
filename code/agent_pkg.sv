/* Package for agent */
package agent_pkg;
   typedef enum {READ, WRITE, BOTH} operation;

   //Verification files
   `include "object.sv"
   `include "transactions.sv"
   `include "config.sv"
   `include "generator.sv"
   `include "driver.sv"
   `include "agent.sv"
   `include "monitor.sv"
   `include "scoreboard.sv"
   `include "environment.sv"
endpackage
