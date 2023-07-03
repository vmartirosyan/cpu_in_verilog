
test: testbench.sv cpu.sv components.sv
		iverilog testbench.sv -g2005-sv -o test

run: test
		./test