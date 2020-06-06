# **************************************************
# ECE593 - Fundamentals of Pre-Silicon Verification
# Project 7
# Team: Shubhanka, Supraj & Thong
# **************************************************
#
# Makefile
#

all:
	vlib work
	vlog axi_lite_pkg.sv axi_lite_if.sv axi_lite_master.sv axi_lite_slave.sv tb_pkg.sv tb_bfm.sv axi_lite_dut.sv tb_monitor.sv tb_generator.sv tb_driver.sv tb_checker.sv tb_scoreboard.sv tb_transactions.sv tb_environment.sv tb_top.sv

	# without coverage
	vsim tb_top +file=test_case.txt