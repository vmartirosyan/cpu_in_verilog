// Implements a simple 8-bit CPU
`include "components.sv"

module CPU(
    input       clk,
    input  [31:0] instruction,
    input  [31:0] in,
    output logic [31:0] out,
    output [31:0] next_addr
);
    // 15 32-bit GPRs and program counter
    reg [31:0] regs[15];
    Counter cnt(.clk(clk), .save(to_cnt), .data(regs[instruction[3:0]]), .value(next_addr));
    wire [31:0] Src1Imm, Src2Imm;
    wire [31:0] Src1Reg, Src2Reg;
    wire [31:0] Src1Input, Src2Input;

    logic to_cnt;
    Switch swSrc1Imm(.en(instruction[31]), .in(32'b0 | instruction[23:16]), .out(Src1Imm));
    Switch swSrc2Imm(.en(instruction[30]), .in(32'b0 | instruction[15:8]),  .out(Src2Imm));

    Switch swSrc1Input(.en(!instruction[31] & (instruction[19:16] == 4'b1111)), .in(in), .out(Src1Input));
    Switch swSrc2Input(.en(!instruction[30] & (instruction[11:8]  == 4'b1111)), .in(in), .out(Src2Input));

    Switch swSrc1Reg(.en(!instruction[31] & (instruction[19:16] != 4'b1111)), .in(regs[instruction[19:16]]), .out(Src1Reg));
    Switch swSrc2Reg(.en(!instruction[30] & (instruction[11:8]  != 4'b1111)), .in(regs[instruction[15:8]]), .out(Src2Reg));
    

    wire [31:0] OpA = Src1Imm | Src1Reg | Src1Input;
    wire [31:0] OpB = Src2Imm | Src2Reg | Src2Input; 

    Cond cond(.A(OpA), .B(OpB), .op(instruction[26:24]), .out(CondOutput));
    ALU alu(.A(OpA), .B(OpB), .op(instruction[26:24]), .out(ALUOutput));

    logic isALUInst;
    logic isCondInst;

    logic [31:0] ALUOutput;
    logic        CondOutput;

    always @ (posedge clk) begin 

        isALUInst       = !instruction[27];
        isCondInst      =  instruction[27];

        // $display("%d Src1Imm=%x Src1Reg=%x Src1Input=%x", $time, Src1Imm, Src1Reg, Src1Input);
        
        if (isALUInst) begin
            if (instruction[3:0] == 4'b1111)
                out = ALUOutput;
            else
                regs[instruction[3:0]] = ALUOutput;
        end
        if (isCondInst) begin
            to_cnt = CondOutput;
        end

    end

endmodule