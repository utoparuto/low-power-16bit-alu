module icg_cell(
input CLK,
input EN,
output CLK_GATED
);

reg en_latch;

always @(CLK or EN)
begin
    if(!CLK)
        en_latch <= EN;
end

assign CLK_GATED = CLK & en_latch;

endmodule

module tharika(
input clk,
input rst_n,
input cin,
input [15:0] A, B,
input [3:0] SEL,
output reg [15:0] result,
output reg zero, carry, sign
);

wire arith_clk, logic_clk;
wire arith_en, logic_en;

assign arith_en = (SEL <= 4'b0101);
assign logic_en = (SEL >= 4'b1000);

icg_cell ICG1 (
    .CLK(clk),
    .EN(arith_en),
    .CLK_GATED(arith_clk)
);

icg_cell ICG2 (
    .CLK(clk),
    .EN(logic_en),
    .CLK_GATED(logic_clk)
);

always @(posedge arith_clk or negedge rst_n)
begin
    if(!rst_n) begin
        result <= 0;
        carry <= 0;
    end
    else begin
        case(SEL)
            4'b0000: {carry, result} <= A + B + cin;
            4'b0001: {carry, result} <= A - B;
            4'b0011: result <= A + 1;
            4'b0100: result <= A - 1;
            4'b0101: result <= (A < B) ? 16'd1 : 16'd0;
        endcase
    end
end

always @(posedge logic_clk or negedge rst_n)
begin
    if(!rst_n)
        result <= 0;
    else begin
        case(SEL)
            4'b1000: result <= A & B;
            4'b1001: result <= A | B;
            4'b1010: result <= A ^ B;
            4'b1011: result <= ~A;
            4'b1100: result <= ~(A & B);
            4'b1101: result <= ~(A | B);
            4'b1110: result <= ~(A ^ B);
            4'b1111: result <= A << 1;
        endcase
    end
end

always @(*)
begin
    zero = (result == 0);
    sign = result[15];
end

endmodule
