/*

**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file defines assertions used to double-check
the correctness of our testbench

*/

/**************** Assertions *******************/

`include"axi_lite_if.sv"

module axi_lite_Assertions(
input	logic	aclk,
input	logic	areset_n,
	
axi_lite_if axi_if

);


/**************************** Read Address Channel***********************************/


// To check araddr remain stable when arvalid is asserted and arready is low.

property AXI4_araddr_stable_p;
@(posedge aclk)
		(axi_if.arvalid && !axi_if.arready) |=> ($stable(axi_if.araddr)); 
endproperty

// To check arready becomes high after arvalid is asserted in the previous clock cycle 

property AXI4_arvalid_arready_p;
@(posedge aclk)
		(axi_if.arvalid && !axi_if.arready) |=>  (axi_if.arvalid && axi_if.arready) ##1 (!axi_if.arvalid && !axi_if.arready);
endproperty

// To chech arvalid and arready signals do not have x value when reset is asserted

property AXI4_unknown_arvalid_arready_p;
@(posedge aclk)
		(areset_n == 1)|=> (!$isunknown(axi_if.arvalid) && !$isunknown(axi_if.arready));
endproperty

// To check araddr signal does not have x when arvalid is asserted and wready is not asserted.
property AXI4_araddr_unknown_p;
@(posedge aclk)
		##1 (axi_if.arvalid) |=> (!$isunknown(axi_if.araddr)); 
endproperty


AXI4_araddr_stable_a: assert property (AXI4_araddr_stable_p);
AXI4_arvalid_arready_a: assert property (AXI4_arvalid_arready_p);
AXI4_araddr_unknown_a: assert property (AXI4_araddr_unknown_p);

/**************************** Read Data Channel***********************************/


// To check rdata remain stable when rvalid is asserted and rready is low.

property AXI4_rdata_stable_p;
@(posedge aclk)
		(axi_if.rvalid && !axi_if.rready) |=> ($stable(axi_if.rdata)); 
endproperty

// To check rready becomes high after rvalid is asserted in the previous clock cycle 

property AXI4_rvalid_rready_p;
@(posedge aclk)
		(axi_if.rvalid && !axi_if.rready) |=>  (axi_if.rvalid && axi_if.rready) ##1 (!axi_if.rvalid && !axi_if.rready);
endproperty

// To chech rvalid and rready signals do not have x value when reset is asserted

property AXI4_unknown_rvalid_rready_p;
@(posedge aclk)
		(areset_n)|=> (!$isunknown(axi_if.rvalid) && !$isunknown(axi_if.rready));
endproperty

// To check rdata signal does not have x when rvalid is asserted and wready is not asserted.
property AXI4_rdata_unknown_p;
@(posedge aclk)
		##1 (axi_if.rvalid) |=> (!$isunknown(axi_if.rdata)); 
endproperty


AXI4_rdata_stable_a: assert property (AXI4_rdata_stable_p);
AXI4_rvalid_rready_a: assert property (AXI4_rvalid_rready_p);
AXI4_unknown_rvalid_rready_a: assert property (AXI4_unknown_rvalid_rready_p);
AXI4_rdata_unknown_a: assert property (AXI4_rdata_unknown_p);

/**************************** Write Address Channel***********************************/


// To check awaddr remain stable when awvalid is asserted and awready is low.

property AXI4_awaddr_stable_p;
@(posedge aclk)	
		(axi_if.awvalid && !axi_if.awready)|=> ($stable(axi_if.awaddr)); 
		
endproperty

//AWVALID and AWVALID check

property AXI4_awready_awvalid_p;
@(posedge aclk)
	(axi_if.awvalid && !axi_if.awready) |=>  (axi_if.awvalid && axi_if.awready) ##1 (!axi_if.awvalid && !axi_if.awready);
endproperty

// To check awaddr signal does not have x when awvalid is asserted and wready is not asserted.
property AXI4_awaddr_unknown_p;
@(posedge aclk)
		##1 (axi_if.awvalid) |=> (!$isunknown(axi_if.awaddr)); 
endproperty

// To chech awvalid and awready signals do not have x value when reset is asserted

property AXI4_unknown_awready_awvalid_p;
@(posedge aclk)
		(areset_n == 1)|=> !$isunknown(axi_if.awvalid) && !$isunknown(axi_if.awready);
endproperty


AXI4_awaddr_stable_a: assert property(AXI4_awaddr_stable_p);	
AXI4_awready_awvalid_a: assert property(AXI4_awready_awvalid_p);
AXI4_awaddr_unknown_a: assert property(AXI4_awaddr_unknown_p);
AXI4_unknown_awready_awvalid_a: assert property(AXI4_unknown_awready_awvalid_p);


/**************************** Write Data Channel***********************************/


// To check wdata signal remain stable when wvalid is asserted and wready is low.
property AXI4_wdata_stable_p;
@(posedge aclk)
		(axi_if.wvalid && !axi_if.wready) |=> ($stable(axi_if.wdata)); 
endproperty

// To check wdata signal does not have x when wvalid is asserted and wready is not asserted.
property AXI4_wdata_unknown_p;
@(posedge aclk)
		##1 (axi_if.wvalid) |=> (!$isunknown(axi_if.wdata)); 
endproperty

// To check wready becomes high after wvalid is asserted in the previous clock cycle 
property AXI4_wvalid_wready_p;
@(posedge aclk)
		(axi_if.wvalid && !axi_if.wready) |=>  (axi_if.wvalid && axi_if.wready) ##1 (!axi_if.wvalid && !axi_if.wready);
endproperty

// To chech wvalid and wready signals do not have x value when reset is asserted

property AXI4_unknown_wready_wvalid_p;
@(posedge aclk)
		(areset_n == 1)|=> !$isunknown(axi_if.wvalid) && !$isunknown(axi_if.wready);
endproperty


AXI4_wdata_stable_a: assert property (AXI4_wdata_stable_p);
AXI4_wdata_unknown_a: assert property (AXI4_wdata_unknown_p);
AXI4_wvalid_wready_a: assert property (AXI4_wvalid_wready_p);
AXI4_unknown_wready_wvalid_a: assert property (AXI4_unknown_wready_wvalid_p);


/**************************** Write Response Channel***********************************/


//To check bresp signal remain stable when bvalid is asserted.
property AXI4_bresp_stable_p;
@(posedge aclk)
 		##1 axi_if.bvalid |=> $stable(axi_if.bresp);
endproperty

// To check bready becomes high after bvalid is asserted in the previous clock cycle 
property AXI4_bvalid_bready_p;
@(posedge aclk)
		(axi_if.bvalid && !axi_if.bready) |=>  (axi_if.bvalid && axi_if.bready) ##1 (!axi_if.bvalid && !axi_if.bready);
endproperty

AXI4_bresp_stable_a: assert property (AXI4_bresp_stable_p);
AXI4_bvalid_bready_a: assert property (AXI4_bvalid_bready_p);




endmodule
		
