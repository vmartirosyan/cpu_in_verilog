`include "cpu.sv"

module Computer;
    logic [7:0] AddrBus;
    logic [7:0] DataBusToRAM;
    logic [7:0] DataBusFromRAM;
    logic       clk_signal;
    logic       clk_enable = 0;
    logic [7:0] Input;
    logic [7:0] Output;
     
    Clock clk(.enable(clk_enable), .clk(clk_signal));
    RAM ram(.clk(clk_signal), .load(1'b1), .save(1'b0), .addr(AddrBus), .data(DataBusToRAM), .value(DataBusFromRAM));
    CPU cpu(.clk(clk_signal), .instruction(DataBusFromRAM), .in(Input), .out(Output), .next_addr(AddrBus));
endmodule