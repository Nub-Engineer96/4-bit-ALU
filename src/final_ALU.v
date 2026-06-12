module final_ALU(
input clk,
input [3:0] A,
input [3:0] B,
input [2:0] select,
output reg [7:0] RESULT,
output reg Carry_Flag,
output reg Greater_Flag,
output reg Less_Flag,
output reg Equal_Flag,
output reg BCD_Zero_Flag
);

////////////////////////////////////////////////////////
// INPUT REGISTERS

reg [3:0] A_reg;
reg [3:0] B_reg;
reg [2:0] select_reg;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    select_reg <= select;
    Greater_Flag  <= 1'b0;
    Less_Flag     <= 1'b0;
    Equal_Flag    <= 1'b0;
    BCD_Zero_Flag <= 1'b0;
end

////////////////////////////////////////////////////////
// ADDER

wire [3:0] Sum;
wire Cout;

ripple_carry_adder_4bit ADDER(
.A(A_reg),
.B(B_reg),
.Cin(1'b0),
.Sum(Sum),
.Cout(Cout)
);

////////////////////////////////////////////////////////
// SUBTRACTOR

wire [3:0] D;
wire Bout;

subtractor SUB(
.A(A_reg),
.B(B_reg),
.Bin(1'b0),
.D(D),
.Bout(Bout)
);

////////////////////////////////////////////////////////
// MULTIPLIER

wire p0,p1,p2,p3,p4,p5,p6,p7;

multiplier MUL(
.A(A_reg),
.B(B_reg),
.p0(p0),
.p1(p1),
.p2(p2),
.p3(p3),
.p4(p4),
.p5(p5),
.p6(p6),
.p7(p7)
);

////////////////////////////////////////////////////////
// ROTATOR

wire [3:0] rotate_out;

rotator ROT(
.A(A_reg),
.dir(select_reg[0]),
.Y(rotate_out)
);

////////////////////////////////////////////////////////
// BINARY TO BCD

wire [7:0] BCD_out;

binary_to_bcd BCD(
.binary(A_reg),
.bcd(BCD_out)
);

////////////////////////////////////////////////////////
// MAGNITUDE COMPARATOR

wire cp1, cp2, cp3;

mag_comparator COMP(
.A(A_reg),
.B(B_reg),
.p1(cp1),
.p2(cp2),
.p3(cp3)
);

////////////////////////////////////////////////////////
// LOGICAL OPERATIONS

wire [3:0] AND_out;
wire [3:0] XOR_out;

assign AND_out = A_reg & B_reg;
assign XOR_out = A_reg ^ B_reg;

////////////////////////////////////////////////////////
// RESULT REGISTER

always @(posedge clk) begin

case(select_reg)

3'b000:
begin
    RESULT <= {3'b000, Cout, Sum};
    Carry_Flag <= Cout;
end
3'b001:
RESULT <= {3'b000, Bout, D}; // SUBTRACT

3'b010:
RESULT <= {p7,p6,p5,p4,p3,p2,p1,p0}; // MULTIPLY


3'b011:
begin
    RESULT <= {5'b00000, cp1, cp2, cp3};

    Greater_Flag <= cp1;
    Less_Flag    <= cp2;
    Equal_Flag   <= cp3;
end

3'b100:
RESULT <= {4'b0000, AND_out}; // AND

3'b101:
RESULT <= {4'b0000, XOR_out}; // XOR

3'b110:
RESULT <= {4'b0000, rotate_out}; // ROTATOR

3'b111:
begin
    RESULT <= BCD_out;

    if(BCD_out == 8'b00000000)
        BCD_Zero_Flag <= 1'b1;
    else
        BCD_Zero_Flag <= 1'b0;
end

default:
RESULT <= 8'b00000000;

endcase

end

endmodule

////////////////////////////////////////////////////////
// FULL ADDER

module full_adder(
input a,
input b,
input cin,
output sum,
output cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (b & cin) | (a & cin);

endmodule

////////////////////////////////////////////////////////
// RIPPLE CARRY ADDER

module ripple_carry_adder_4bit(
input [3:0] A,
input [3:0] B,
input Cin,
output [3:0] Sum,
output Cout
);

wire c1,c2,c3;

full_adder FA1(A[0],B[0],Cin,Sum[0],c1);
full_adder FA2(A[1],B[1],c1,Sum[1],c2);
full_adder FA3(A[2],B[2],c2,Sum[2],c3);
full_adder FA4(A[3],B[3],c3,Sum[3],Cout);

endmodule

////////////////////////////////////////////////////////
// MULTIPLIER

module multiplier(
input [3:0] A,
input [3:0] B,
output p0,p1,p2,p3,p4,p5,p6,p7
);

wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12;
wire s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12;

full_adder FA1(A[1]&B[0],A[0]&B[1],1'b0,s1,c1);
full_adder FA2(A[2]&B[0],A[1]&B[1],1'b0,s2,c2);
full_adder FA3(A[3]&B[0],A[2]&B[1],1'b0,s3,c3);

full_adder FA4(s2,A[0]&B[2],c1,s4,c4);
full_adder FA5(s3,A[1]&B[2],c2,s5,c5);
full_adder FA6(A[3]&B[1],A[2]&B[2],c3,s6,c6);

full_adder FA7(s5,A[0]&B[3],c4,s7,c7);
full_adder FA8(s6,A[1]&B[3],c5,s8,c8);
full_adder FA9(A[3]&B[2],A[2]&B[3],c6,s9,c9);

full_adder FA10(s8,1'b0,c7,s10,c10);
full_adder FA11(s9,c10,c8,s11,c11);
full_adder FA12(A[3]&B[3],c11,c9,s12,c12);

assign p0 = A[0]&B[0];
assign p1 = s1;
assign p2 = s4;
assign p3 = s7;
assign p4 = s10;
assign p5 = s11;
assign p6 = s12;
assign p7 = c12;

endmodule

////////////////////////////////////////////////////////
// SUBTRACTOR

module subtractor(
input [3:0] A,
input [3:0] B,
input Bin,
output [3:0] D,
output Bout
);

assign D = A - B;
assign Bout = (A < B);

endmodule

////////////////////////////////////////////////////////
// ROTATOR

module rotator(
input [3:0] A,
input dir,
output [3:0] Y
);

assign Y = (dir == 0) ?
           {A[2:0], A[3]} :
           {A[0], A[3:1]};

endmodule

////////////////////////////////////////////////////////
// BINARY TO BCD

module binary_to_bcd(
input [3:0] binary,
output reg [7:0] bcd
);

always @(*) begin

if(binary < 10)
    bcd = {4'b0000, binary};
else
    bcd = {4'b0001, binary - 4'd10};

end

endmodule

////////////////////////////////////////////////////////
// MAGNITUDE COMPARATOR

module mag_comparator(
input [3:0] A,
input [3:0] B,
output p1,
output p2,
output p3
);

wire a1,a2,a3,a4,a5,a6,a7,a8;
wire n1,n2,n3,n4;

assign a1 = A[3] & ~B[3];
assign a2 = ~A[3] & B[3];

assign n1 = ~(a1 | a2);

assign a3 = A[2] & ~B[2] & n1;
assign a4 = ~A[2] & B[2] & n1;

assign n2 = ~(a3 | a4);

assign a5 = A[1] & ~B[1] & n1 & n2;
assign a6 = ~A[1] & B[1] & n1 & n2;

assign n3 = ~(a5 | a6);

assign a7 = A[0] & ~B[0] & n1 & n2 & n3;
assign a8 = ~A[0] & B[0] & n1 & n2 & n3;

assign n4 = ~(a7 | a8);

assign p1 = a1 | a3 | a5 | a7; // A>B
assign p2 = a2 | a4 | a6 | a8; // A<B
assign p3 = n1 & n2 & n3 & n4; // A=B

endmodule   yes Sir i have added these and this is the final code Sir.