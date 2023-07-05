// Implements a simple 8-bit CPU
`include "components.sv"

module CPU(
    input       clk,
    input  [7:0] instruction,
    input  [7:0] in,
    output logic [7:0] out,
    output [7:0] next_addr
);

    reg [7:0] r0 = 0, r1 = 0, r2 = 0, r3 = 0, r4 = 0, r5 = 0;
    
    logic to_cnt;

    Cond cond(.A(r3), .op(instruction[2:0]), .out(CondOutput));
    Counter cnt(.clk(clk), .save(to_cnt), .data(r0), .value(next_addr));
    ALU alu(.A(r1), .B(r2), .op(instruction[2:0]), .out(ALUOutput));

    logic isImmediate;
    logic isCopyInst;
    logic isALUInst;
    logic isCondInst;

    logic [2:0] copySrcNum, copyDstNum;
    logic [7:0] copySrc, copyDst;
    logic [7:0] ALUOutput;
    logic       CondOutput;

    always @ (posedge clk) begin 

        isImmediate = ~instruction[7] & ~instruction[6];
        isCopyInst  = ~instruction[7] &  instruction[6];
        isALUInst   =  instruction[7] & ~instruction[6];
        isCondInst  =  instruction[7] &  instruction[6];
        
        if (isImmediate) begin
            r0 = instruction;
        end
        if (isCopyInst) begin
            copySrcNum = instruction[5:3];
            copyDstNum = instruction[2:0];

            case (copySrcNum)
                3'b000: copySrc = r0;
                3'b001: copySrc = r1;
                3'b010: copySrc = r2;
                3'b011: copySrc = r3;
                3'b100: copySrc = r4;
                3'b101: copySrc = r5;
                3'b110: copySrc = cnt.value;
                3'b111: copySrc = in;
            endcase

            case (copyDstNum)
                3'b000: r0       = copySrc;
                3'b001: r1       = copySrc;
                3'b010: r2       = copySrc;
                3'b011: r3       = copySrc;
                3'b100: r4       = copySrc;
                3'b101: r5       = copySrc;
                //3'b110: cnt.save = 1;
                3'b111: out      = copySrc;
            endcase
        end
        if (isALUInst) begin
            r3 = ALUOutput;
        end
        if (isCondInst) begin
            to_cnt = CondOutput;
        end

    end

endmodule