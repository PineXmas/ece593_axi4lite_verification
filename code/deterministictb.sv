`timescale 1ns / 1ps

import axi_lite_pkg::*;

module tb_axi_lite;

//    localparam STEP = 10;

logic aclk, areset_n;
axi_lite_if axi_lite_if();
logic start_read;
logic start_write;

addr_t addr;
data_t data;

axi_lite_master master(
.aclk(aclk), .areset_n(areset_n),
.m_axi_lite(axi_lite_if),
.start_read(start_read), .start_write(start_write),
.addr(addr), .data(data)
);

axi_lite_slave  slave (
.aclk(aclk), .areset_n(areset_n),
.s_axi_lite(axi_lite_if)
);

initial begin
aclk = 1;
forever #10 aclk = ~aclk;
end

// Task for consecutive writes
task contiwrites();

areset_n = 0;
#1000;
start_write = 1;
addr = 32'h1111;
#80;
start_write = 0;
areset_n = 1;
#1000;
start_write = 1;
addr = 32'h0001;
data = 32'h000a;
#100;
start_write = 0;
#120;
start_write = 1;
addr = 32'h0002;
data = 32'h0011;
#100;
start_write = 0;
#120;
start_write = 1;
addr = 32'h0003;
data = 32'h0010;
#100;
start_write = 0;
#120;
start_write = 1;
addr = 32'h0004;
data = 32'h00c1;
#100;
start_write = 0;
#120;
endtask

// Task for consecutive reads
task contireads();

areset_n = 0;
#1000;
start_read = 1;
addr = 32'h1111;
#80;
start_read = 0;
areset_n = 1;
#1000;
start_read = 1;
addr = 32'h000B;
data = 32'h0001;
#80;
start_read = 0;
#120;
start_read = 1;
addr = 32'h0001;
data = 32'h0004;
#80;
start_read = 0;
#120;
start_read = 1;
addr = 32'h0009;
data = 32'h000C;
#80;
start_read = 0;
#120;
start_read = 1;
addr = 32'h0007;
data = 32'h0008;
#80;
start_read = 0;
#120;
endtask

//task for write and read to same address, multiple writes and then followed by a single read
task read_write();

areset_n = 0;
#1000;
areset_n = 1;
#1000;
start_write = 1;
addr = 32'h0002;
data = 32'h0001;
#100;
start_write = 0;
#120;
start_read = 1;
addr = 32'h0002;
data = 32'h0001;
#80;
start_read = 0;
#120;
start_write = 1;
addr = 32'h0003;
data = 32'h0010;
#100;
start_write = 0;
#120;
start_write = 1;
addr = 32'h0004;
data = 32'h0080;
#100;
start_write = 0;
#120;
start_write = 1;
addr = 32'h0001;
data = 32'h0020;
#100;
start_write = 0;
#120;
start_read = 1;
addr = 32'h0005;
data = 32'h0020;
#80;
start_read = 0;
#120;
endtask


initial begin
start_read = 0; start_write = 0;
areset_n = 1;
#100;
areset_n = 0;
#100;
areset_n = 1;
#120;
start_write = 1;

addr = 32'h0002;
data = 32'hdeadbeef;
#100;
start_write = 0;

#120;
/*start_read = 1;
//        #20;
addr = 32'h0002;
#80;
start_read = 0;
//        #40;
//        addr = '0;
#120;*/

// write after read
start_write = 1;
addr = 32'h0001;
data = 32'h000D;
#100;
start_write = 0;
#120;

start_read = 1;
addr = 32'h0002;
data = 32'h0003;
#80;
start_read = 0;
#120;


// read after write
start_read = 1;
addr = 32'h000B;
data = 32'h0005;
#80;
start_read = 0;
#120;

start_write = 1;
addr = 32'h000A;
data = 32'h0004;
#100;
start_write = 0;
#120;

//both start_write and start_read are asserted together
start_read = 1;
start_write = 1;
addr = 32'h0007;
data = 32'h000D;
#100;
start_read = 0;
start_write = 0;
#120;

//invalid address write
start_write = 1;
addr = 32'hxxxx;

#100;
start_write = 0;
#120;

//invalid address read
start_read = 1;
addr = 32'hxxxx;

#100;
start_read = 0;
#120;



contiwrites();
contireads();
read_write();

$stop;
end



endmodule

