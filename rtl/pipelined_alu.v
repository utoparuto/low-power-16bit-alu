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

module mission(
input clk,
input rst_n,
input cin,
input [15:0] A, B,
input [3:0] SEL,
output reg [15:0] result,
output reg zero, carry, sign
);

wire gated_clk;
wire enable;

assign enable = 1'b1;

icg_cell ICG (
    .CLK(clk),
    .EN(enable),
    .CLK_GATED(gated_clk)
);

// Stage 1 Registers
reg [15:0] A_s1, B_s1;
reg [3:0] SEL_s1;
reg cin_s1;

// Stage 2 Registers
reg [15:0] arith_r;
reg a_carry, a_ovf;
reg [15:0] logic_r;

always @(posedge gated_clk or negedge rst_n)
begin
    if(!rst_n) begin
        A_s1 <= 0;
        B_s1 <= 0;
        SEL_s1 <= 0;
        cin_s1 <= 0;
    end
    else begin
        A_s1 <= A;
        B_s1 <= B;
        SEL_s1 <= SEL;
        cin_s1 <= cin;
    end
end

always @(posedge gated_clk or negedge rst_n)
begin
    if(!rst_n) begin
        result <= 0;
        carry <= 0;
        zero <= 0;
        sign <= 0;
    end
    else begin

        case(SEL_s1)

            4'b0000: begin
                {a_carry, arith_r} = A_s1 + B_s1 + cin_s1;
                result <= arith_r;
                carry <= a_carry;
            end

            4'b0001: begin
                {a_carry, arith_r} = A_s1 - B_s1;
                result <= arith_r;
                carry <= a_carry;
            end

            4'b0011: result <= A_s1 + 1;
            4'b0100: result <= A_s1 - 1;
            4'b0101: result <= (A_s1 < B_s1) ? 16'd1 : 16'd0;

            4'b1000: result <= A_s1 & B_s1;
            4'b1001: result <= A_s1 | B_s1;
            4'b1010: result <= A_s1 ^ B_s1;
            4'b1011: result <= ~A_s1;
            4'b1100: result <= ~(A_s1 & B_s1);
            4'b1101: result <= ~(A_s1 | B_s1);
            4'b1110: result <= ~(A_s1 ^ B_s1);
            4'b1111: result <= A_s1 << 1;

            default: result <= 0;
        endcase

        zero <= (result == 0);
        sign <= result[15];
    end
end

endmodule
