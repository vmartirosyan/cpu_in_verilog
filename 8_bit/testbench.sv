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
//   logic [7:0] instruction;
//   logic [7:0] in;
//   wire  [7:0] out;
//   wire  [7:0] next_addr;
  
//   CPU dut (.*);
  
//   initial begin
  
//     clk = 0;
//     #1 clk = 1;
//     #1 clk = 0;
//     #1 clk = 1;
//     #1 clk = 0;

//     #1
//     instruction = 8'b00_001101; // r0 = 0d
//     clk = 1;

//     #1 
//     clk = 0;
//     #1
//     clk = 1;
//     instruction = 8'b01_000_001; // r1 = r0
//     #1 clk = 0;
//     #1
//     instruction = 8'b00_000001; // r0 = 7
//     clk = 1;
//     #1 clk = 0;
//     #1
//     clk = 1;
//     instruction = 8'b01_000_010; // r2 = r0
//     #1 clk = 0;
//     #1 
//     clk = 1;
//     instruction = 8'b10_000_000; // Add
//     #1 clk = 0;
//     #1 clk = 1;
//     #1 clk = 0;
//     #1 
//     clk = 1;
//     instruction = 8'b01_011_111; // out = r3
//     #1 clk = 1;
//     #1 clk = 0;

//     #1
//     clk = 1;
//     instruction = 8'b11_000_001; // r3 != 0
//     #1 clk = 0;
//     #1 clk = 1;
//     #1 clk = 0;
//     #1 clk = 1;
    
//   end
  
//   initial begin
//      $monitor($time, " clk=%b, inst=%b, in=%x out=%x next_addr=%x r0=%x r1=%x r2=%x r3=%x r4=%x r5=%x Cond=%b Cond.op=%b Cond.out=%b Cnt.save=%b Cnt.data=%x Cnt.Value=%x " ,
//               clk, instruction, in, out, next_addr, dut.r0, dut.r1, dut.r2, dut.r3, dut.r4, dut.r5,  dut.isCondInst, dut.cond.op, dut.cond.out, dut.cnt.save, dut.cnt.data, dut.cnt.value );
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
    dut.ram.mem[0] = 8'b01_111_001; // r1 = in
    dut.ram.mem[1] = 8'b01_001_010; // r2 = r1
    dut.ram.mem[2] = 8'b01_111_001; // r1 = in
    dut.ram.mem[3] = 8'b10_000_000; // r3 = r1 + r2
    dut.ram.mem[4] = 8'b01_011_111; // out = r3

    dut.clk_enable <= 1;
    
    #10 dut.Input = 8'b100;
    
    #20 dut.Input = 8'b101;

    #100 dut.clk_enable <= 0;
    
  end
  
  initial begin
     $monitor($time, " clk=%b, inst=%b, in=%x out=%x next_addr=%x r1=%x r2=%x r3=%x " ,
              dut.clk.clk, dut.cpu.instruction, dut.Input, dut.Output, dut.ram.addr, dut.cpu.r1, dut.cpu.r2, dut.cpu.r3);
  end

endmodule