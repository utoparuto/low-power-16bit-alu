module baseline_alu(
input wire clk, rst_n, cin,
input wire [15:0] A, B,
input wire [3:0] SEL,
output reg [15:0] result,
output reg zero, carry, overflow, sign
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        result <= 0;
        zero <= 0;
        carry <= 0;
        overflow <= 0;
        sign <= 0;
    end
    else begin
        case(SEL)

            // Arithmetic Operations
            4'b0000: {carry, result} <= A + B + cin;
            4'b0001: {carry, result} <= A - B;
            4'b0011: result <= A + 1;
            4'b0100: result <= A - 1;
            4'b0101: result <= (A < B) ? 16'd1 : 16'd0;

            // Logical Operations
            4'b1000: result <= A & B;
            4'b1001: result <= A | B;
            4'b1010: result <= A ^ B;
            4'b1011: result <= ~A;
            4'b1100: result <= ~(A & B);
            4'b1101: result <= ~(A | B);
            4'b1110: result <= ~(A ^ B);

            // Shift Operation
            4'b1111: result <= A << 1;

            default: result <= 16'd0;
        endcase

        zero <= (result == 0);
        sign <= result[15];
    end
end

endmodule
