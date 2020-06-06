**************************************************
ECE593 - Fundamentals of Pre-Silicon Verification
Project 7
Team: Shubhanka, Supraj & Thong
**************************************************

This file gives the readers a brief tutorial of how to run our testbench.

----------------------------------------------------------------------------------------------------

[Main]
- By default, just run "make" and everything will be built, QuestaSim will be opened. Then you just need to type "run -all" for the testing.
- While in QuestaSim, if you want to change the input file, simply type:
vsim work.tb_top +file=<file_path>


[Optional]
- To turn on randomly assertions of reset signal, please add "+inject_reset" to the command above.
- To turn on randomly assertions of start-read/start-write signal, please add "+inject_start" to the command above.
Note that these two features are used to measure the coverage in our testbench, therefore, introducing them into the test does not guarantee the test run with error-free, since the whole system is reset arbitrarily, leading to write/read results mismatched with the scoreboard.
