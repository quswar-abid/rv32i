clean:
	rm a.out dump.vcd

compile:
	iverilog -f flist

run: compile
	vvp a.out

sim:
	gtkwave dump.vcd

rerun: clean run

resim: clean run sim