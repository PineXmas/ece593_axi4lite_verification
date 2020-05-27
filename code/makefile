# Makefile
# ECE593 - HW 01
# Thong Doan

all:
	vlib work
	vlog axi_lite_pkg.sv axi_lite_if.sv axi_lite_master.sv axi_lite_slave.sv tb_pkg.sv tb_bmf.sv tb_top.sv

	# with coverage enabled
	#vsim -c -coverage vm2002_coverage_tb

	# without coverage
	vsim tb_top