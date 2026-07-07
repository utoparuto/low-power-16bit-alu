module mission_tb;

reg clk, rst_n, cin;
reg [15:0] A, B;
reg [3:0] SEL;

wire [15:0] result;
wire zero, carry, sign;

// DUT Instantiation
mission DUT(
    .clk(clk),
    .rst_n(rst_n),
    .cin(cin),
    .A(A),
    .B(B),
    .SEL(SEL),
    .result(result),
    .zero(zero),
    .carry(carry),
    .sign(sign)
);

// Clock Generation
always #5 clk = ~clk;

initial begin

    // Dump file for GTKWave
    $dumpfile("dump.vcd");
    $dumpvars(0, mission_tb);

    // Initial values
    clk = 0;
    rst_n = 0;
    cin = 0;
    A = 0;
    B = 0;
    SEL = 0;

    // Reset Release
    #10 rst_n = 1;

    // ADD
    A = 16'd20;
    B = 16'd10;
    SEL = 4'b0000;
    #20;
    $display("ADD RESULT = %d", result);

    // SUB
    A = 16'd20;
    B = 16'd5;
    SEL = 4'b0001;
    #20;
    $display("SUB RESULT = %d", result);

    // INC
    A = 16'd15;
    SEL = 4'b0011;
    #20;
    $display("INC RESULT = %d", result);

    // DEC
    A = 16'd15;
    SEL = 4'b0100;
    #20;
    $display("DEC RESULT = %d", result);

    // SLT
    A = 16'd5;
    B = 16'd10;
    SEL = 4'b0101;
    #20;
    $display("SLT RESULT = %d", result);

    // AND
    A = 16'h00FF;
    B = 16'h0F0F;
    SEL = 4'b1000;
    #20;
    $display("AND RESULT = %h", result);

    // OR
    SEL = 4'b1001;
    #20;
    $display("OR RESULT = %h", result);

    // XOR
    SEL = 4'b1010;
    #20;
    $display("XOR RESULT = %h", result);

    // NOT
    SEL = 4'b1011;
    #20;
    $display("NOT RESULT = %h", result);

    // NAND
    SEL = 4'b1100;
    #20;
    $display("NAND RESULT = %h", result);

    // NOR
    SEL = 4'b1101;
    #20;
    $display("NOR RESULT = %h", result);

    // XNOR
    SEL = 4'b1110;
    #20;
    $display("XNOR RESULT = %h", result);

    // SHIFT LEFT
    SEL = 4'b1111;
    #20;
    $display("SHIFT RESULT = %h", result);

    #40;
    $finish;

end

endmodule
