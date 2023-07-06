`include "computer.sv"

// module ALU_tb;

//   logic [7:0] A;
//   logic [7:0] B;
//   logic [2:0] op;
//   wire [7:0] out;
//   wire carry_out;
//   wire panic;

//   ALU dut (.*);
  
//   initial begin
  
//     A = 5;
//     B = 3;
//     op = 3'b000;
    
//     # 10;
//     A = 10;
//     B = 10;
//     op = 3'b001;

//     # 10;
//     A = 10;
//     B = 10;
//     op = 3'b111;
   
//   end
  
//   initial begin
//      $monitor($time, " A=%b, B=%b, op=%b, out=%b, carry_out=%x panic=%x",
//               A, B, op, out, carry_out, panic);
//   end

// endmodule


// module RAM_tb;

//   logic clk;
//   logic load;
//   logic save;
//   logic [7:0] addr;
//   logic [7:0] data;
//   wire  [7:0] value;
  
//   RAM dut (.*);
  
//   initial begin
  
//     clk = 0;
//     // Write 200 to mem[10]
//     #1
//     clk = 1;
//     addr = 10;
//     data = 200;
//     load = 0;
//     save = 1;
    
//     #10
//     clk = 0;

//     // Read the contents of mem[10]
//     # 10;
//     clk = 1;
//     addr = 10;
//     load = 1;
//     save = 0;
    
//   end
  
//   initial begin
//      $monitor($time, " clk=%b, load=%b, save=%b, addr=%b, data=%x value=%x",
//               clk, load, save, addr, data, value);
//   end

// endmodule

// module Cond_tb;

//   logic [7:0] A;
//   logic [2:0] op;
//   wire  out;
  
//   Cond dut (.*);
  
//   initial begin
  
//     A = 0;
//     op = 3'b000;
    
//     # 10;
//     A = -4;
//     op = 3'b001;

//     # 10;
//     A = 10;
//     op = 3'b010;
   
//     # 10;
//     A = -10;
//     op = 3'b011;
   
//   end
  
//   initial begin
//      $monitor($time, " A=%b, op=%b, out=%b ", A, op, out);
//   end

// endmodule

// module Counter_tb;

//   logic clk;
//   logic save;
//   logic [7:0] data;
//   wire  [7:0] value;
  
//   Counter dut (.*);
  
//   initial begin
  
//     clk = 0;
//     #1 clk = 1;
//     #1 clk = 0;
//     #1 clk = 1;
//     #1 clk = 0;
    
//     // Write 200 to counter
//     #1
//     clk = 1;
//     data = 0;
//     save = 1;
    
//     #1 
//     clk = 0;
//     save = 0;
    
//     #1 clk = 1;
//     #1 clk = 0;
//     #1 clk = 1;
//     #1 clk = 0;
//     #1 clk = 1;
//   end
  
//   initial begin
//      $monitor($time, " clk=%b, save=%b, data=%x value=%x",
//               clk, save, data, value);
//   end

// endmodule

// module CPU_tb;

//   logic clk;
//   logic [31:0] instruction;
//   logic [31:0] in;
//   wire  [31:0] out;
//   wire  [31:0] next_addr;
  
//   CPU dut (.*);
  
//   initial begin
  
//     clk = 0;
//     #1 clk = 1;
//     #1 clk = 0;
//     #1 clk = 1;
//     #1 clk = 0;
    
//     #1
//     instruction = 32'b1100_0000_1111_1111_0000_0000_0000_0000; // r0 = 0xFF + 0
//     clk = 1;
//     #1 clk = 0;
//     #1 clk = 1;
//     #1 clk = 0;
    
//     #1
//     instruction = 32'b0100_1010_0000_0000_0000_0000_0000_0000; // if r0 > 0 br [r0]
//     clk = 1;
//     #1 clk = 0;
//     #1 clk = 1;
//     #1 clk = 0;
    
//     #1 clk = 0;
//     #1 clk = 1;
//     #1 clk = 0;
//     #1 clk = 1;
    
//   end
  
//   initial begin
//      $monitor($time, " clk=%b, inst=%b, in=%x out=%x next_addr=%x r0=%x r1=%x r2=%x r3=%x isALU=%b  " ,
//               clk, instruction, in, out, next_addr, dut.regs[0], dut.regs[1], dut.regs[2], dut.regs[3], dut.isALUInst );
//   end

// endmodule

// module Clock_tb;
//   logic clk_enable = 0;
//   logic clk_signal;
//   Clock dut(.enable(clk_enable), .clk(clk_signal));

//   initial begin

//     #0 clk_enable <= 1'b1;

//     #50 clk_enable <= 1'b0;
    
//   end

//   initial begin
//      $monitor($time, " clk=%b ", clk_signal);
//   end

// endmodule

module Computer_tb;

  Computer dut();
  
  initial begin
    #0
    dut.ram.mem[0] = 32'b0100_0000_0000_1111_0000_0000_0000_0001; // r1 = Input + 0 
    dut.ram.mem[1] = 32'b0100_0000_0000_1111_0000_0000_0000_0010; // r2 = Input + 0
    dut.ram.mem[2] = 32'b0000_0000_0000_0001_0000_0010_0000_0011; // r3 = r1 + r2
    dut.ram.mem[3] = 32'b1000_0000_0000_0000_0000_0011_0000_1111; // out = r3

    
    dut.Input = 8'b100;

    dut.clk_enable <= 1;
        
    #20 dut.Input = 8'b101;

    #40 dut.clk_enable <= 0;
    
  end
  
  initial begin
     $monitor($time, " clk=%b, inst=%b, in=%x out=%x next_addr=%x r1=%x r2=%x r3=%x " ,
              dut.clk.clk, dut.cpu.instruction, dut.Input, dut.Output, dut.ram.addr, dut.cpu.regs[1], dut.cpu.regs[2], dut.cpu.regs[3]);
  end

endmodule