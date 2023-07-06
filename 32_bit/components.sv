module Switch(en, in, out);
    parameter BIT_WIDTH = 32;
    input en;
    input [BIT_WIDTH-1:0] in;
    output [BIT_WIDTH-1:0] out;
    reg [BIT_WIDTH-1:0] outval;
    
    always @ (en or in) begin
        case(en)
        1'b0 : outval = {BIT_WIDTH{1'b0}};
        1'b1 : outval = in;
        endcase
    end
    assign out = outval;
endmodule


module RAM(
    input clk, 
    input load, 
    input save, 
    input [31:0] addr, 
    input [31:0] data, 
    output [31:0] value
);

    reg [31:0] mem[1024*1024];
    logic [31:0] value;
    
    always @ (posedge clk) begin
        if (load) begin
            value <= mem[addr];
        end
        if (save) begin
            mem[addr] = data;
        end
    end
endmodule

module ALU (
  input [31:0] A,
  input [31:0] B,
  input [2:0] op,
  output [31:0] out,
  output carry_out,
  output panic

);
  
  logic [32:0] alu_result;
  logic panic;
  
  always @(*) begin
    panic = 0;
    case (op)
      3'b000: // Addition 
        alu_result = (A + B);
      3'b001: // Sub
        alu_result = A - B;  
      3'b010: // Logic and
        alu_result = A & B;  
      3'b011: // Logic or
        alu_result = A | B; 
      3'b100: // Logic xor
        alu_result = A ^ B;
      3'b101: // Logic not
        alu_result = ~A;
      default:
        panic = 1;
    endcase
    // $display("%d ALU: A=%x B=%x op=%b res=%x", $time, A, B, op, alu_result);
  end
  
  assign out = alu_result[31:0];
  assign carry_out =  alu_result[32];
  
  
endmodule

module Cond (
  input [31:0] A,
  input [31:0] B,
  input [2:0] op,
  output out
);
  
  logic result;
  
  always @(*) begin
    case (op)
      3'b000: // Equals to 
        result = (A == B);
      3'b001: // Not equals to 
        result = (A != B);
      3'b010: // Greater than
        result = ($signed(A) > $signed(B));
      3'b011: // Less than 0
        result = ($signed(A) < $signed(B)); 
      3'b100: // Greater than or equal to
        result = ($signed(A) >= $signed(B));
      3'b101: // Less than or equal to 
        result = ($signed(A) <= $signed(B));
      3'b110: // Always true
        result = 1;
      3'b111: // Always false
        result = 0;
    endcase
    // $display("%d Cond: A=%x B=%x op=%b res=%b", $time, A, B, op, result);
  end
  
  assign out = result;
  
endmodule

module Counter(
    input        clk, 
    input        save, 
    input  [31:0] data, 
    output [31:0] value
);
    reg   [31:0] mem = 0;
    logic [31:0] value;
    
    always @ (posedge clk) begin
        value <= mem;
        mem = mem + 1;
        if (save) begin
            mem = data;
        end
    end
endmodule

// Module Clock is taken from https://www.chipverify.com/verilog/verilog-clock-generator
module Clock (	input      enable,
  					output reg clk);
  
  parameter FREQ = 100000;  // in kHZ
  parameter PHASE = 0; 		// in degrees
  parameter DUTY = 50;  	// in percentage 
  
  real clk_pd  		= 1.0/(FREQ * 1e3) * 1e9; 	// convert to ns
  real clk_on  		= DUTY/100.0 * clk_pd;
  real clk_off 		= (100.0 - DUTY)/100.0 * clk_pd;
  real quarter 		= clk_pd/4;
  real start_dly     = quarter * PHASE/90;
  
  reg start_clk;
  
  // Initialize variables to zero
  initial begin
    clk <= 0;
    start_clk <= 0;
  end
  
  // When clock is enabled, delay driving the clock to one in order
  // to achieve the phase effect. start_dly is configured to the 
  // correct delay for the configured phase. When enable is 0,
  // allow enough time to complete the current clock period
  always @ (posedge enable or negedge enable) begin
    if (enable) begin
      #(start_dly) start_clk = 1;
    end else begin
      #(start_dly) start_clk = 0;
    end      
  end
  
  // Achieve duty cycle by a skewed clock on/off time and let this
  // run as long as the clocks are turned on.
  always @(posedge start_clk) begin
    if (start_clk) begin
      	clk = 1;
      
      	while (start_clk) begin
      		#(clk_on)  clk = 0;
    		#(clk_off) clk = 1;
        end
      
      	clk = 0;
    end
  end 
endmodule