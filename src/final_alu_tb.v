`timescale 1ns/1ps

module final_ALU_tb;

reg clk;
reg [3:0] A;
reg [3:0] B;
reg [2:0] select;

wire [7:0] RESULT;
wire Carry_Flag;
wire Greater_Flag;
wire Less_Flag;
wire Equal_Flag;
wire BCD_Zero_Flag;

final_ALU DUT (
    .clk(clk),
    .A(A),
    .B(B),
    .select(select),
    .RESULT(RESULT),
    .Carry_Flag(Carry_Flag),
    .Greater_Flag(Greater_Flag),
    .Less_Flag(Less_Flag),
    .Equal_Flag(Equal_Flag),
    .BCD_Zero_Flag(BCD_Zero_Flag)
);

/////////////////////////////////////////////////
// CLOCK GENERATION

initial begin
    clk = 0;
    forever #5 clk = ~clk;   // 100 MHz clock
end

/////////////////////////////////////////////////
// TEST VECTORS

initial begin

    A = 0;
    B = 0;
    select = 0;

    #20;

    // ADDITION
    A = 4'd9;
    B = 4'd6;
    select = 3'b000;
    #20;

    // SUBTRACTION
    A = 4'd12;
    B = 4'd5;
    select = 3'b001;
    #20;

    // MULTIPLICATION
    A = 4'd7;
    B = 4'd3;
    select = 3'b010;
    #20;

    // COMPARATOR A>B
    A = 4'd10;
    B = 4'd4;
    select = 3'b011;
    #20;

    // COMPARATOR A<B
    A = 4'd3;
    B = 4'd9;
    select = 3'b011;
    #20;

    // COMPARATOR A=B
    A = 4'd8;
    B = 4'd8;
    select = 3'b011;
    #20;

    // AND
    A = 4'b1101;
    B = 4'b1010;
    select = 3'b100;
    #20;

    // XOR
    A = 4'b1101;
    B = 4'b1010;
    select = 3'b101;
    #20;

    // ROTATE LEFT
    A = 4'b1011;
    B = 4'b0000;
    select = 3'b110;
    #20;

    // ROTATE RIGHT
    A = 4'b1011;
    B = 4'b0001;
    select = 3'b110;
    #20;

    // BCD (LESS THAN 10)
    A = 4'd7;
    B = 4'd0;
    select = 3'b111;
    #20;

    // BCD (GREATER THAN 9)
    A = 4'd13;
    B = 4'd0;
    select = 3'b111;
    #20;

    // BCD ZERO FLAG
    A = 4'd0;
    B = 4'd0;
    select = 3'b111;
    #20;

    $finish;

end

/////////////////////////////////////////////////
// MONITOR

initial begin
    $monitor(
    "T=%0t CLK=%b A=%d B=%d SEL=%b RESULT=%b Carry=%b GT=%b LT=%b EQ=%b BCDZ=%b",
    $time,
    clk,
    A,
    B,
    select,
    RESULT,
    Carry_Flag,
    Greater_Flag,
    Less_Flag,
    Equal_Flag,
    BCD_Zero_Flag
    );
end

endmodule
