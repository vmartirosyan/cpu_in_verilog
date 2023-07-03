module Decoder3 (sel0, sel1, sel2, out0, out1, out2, out3, out4, out5, out6, out7);
    input sel0;
    input sel1;
    input sel2;
    output reg out0;
    output reg out1;
    output reg out2;
    output reg out3;
    output reg out4;
    output reg out5;
    output reg out6;
    output reg out7;

    always @ (sel2 or sel1 or sel0)
    begin
        case({sel2, sel1, sel0})
        3'b000 : {out7, out6, out5, out4, out3, out2, out1, out0} = 8'b0000_0001;
        3'b001 : {out7, out6, out5, out4, out3, out2, out1, out0} = 8'b0000_0010;
        3'b010 : {out7, out6, out5, out4, out3, out2, out1, out0} = 8'b0000_0100;
        3'b011 : {out7, out6, out5, out4, out3, out2, out1, out0} = 8'b0000_1000;
        3'b100 : {out7, out6, out5, out4, out3, out2, out1, out0} = 8'b0001_0000;
        3'b101 : {out7, out6, out5, out4, out3, out2, out1, out0} = 8'b0010_0000;
        3'b110 : {out7, out6, out5, out4, out3, out2, out1, out0} = 8'b0100_0000;
        3'b111 : {out7, out6, out5, out4, out3, out2, out1, out0} = 8'b1000_0000;
        default : {out7, out6, out5, out4, out3, out2, out1, out0} = 8'b0000_0000;
        endcase
    end 
endmodule

module Splitter8 (in, out0, out1, out2, out3, out4, out5, out6, out7);
    input [7:0] in;
    output out0;
    output out1;
    output out2;
    output out3;
    output out4;
    output out5;
    output out6;
    output out7;
    
    assign {out7, out6, out5, out4, out3, out2, out1, out0} = in;
endmodule

module Switch(en, in, out);
    parameter BIT_WIDTH = 1;
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
