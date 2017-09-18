module matrixMultiply
  (input logic clock, reset_l,
    output logic [15:0] outResult, clockTicks);

  logic [11:0] A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11;
  logic [11:0] A12, A13, A14, A15, A16, A17, A18, A19, A20, A21;
  logic [11:0] A22, A23, A24, A25, A26, A27, A28, A29, A30, A31, A32;
  logic [5:0] B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, B11;
  logic [5:0] B12, B13, B14, B15, B16;

  logic [7:0] Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11;
  logic [7:0] Q12, Q13, Q14, Q15, Q16;
  logic [7:0] q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11;
  logic [7:0] q12, q13, q14, q15, q16;

  logic [15:0] result1, result2, result3, result4, result5, result6;
  logic [15:0] result7, result8, result9, result10, result11;
  logic [15:0] result12, result13, result14, result15 ,result16;


  logic [15:0] tempresult;
  logic [7:0] rowCount;


  romA matA1(.address_a(A1), .address_b(A2), .clock(clock),
              .q_a(Q1), .q_b(Q2));
  romB matB1(.address_a(B1), .address_b(B2), .clock(clock),
              .q_a(q1), .q_b(q2));

  multiplier mul11(.dataa(Q1), .datab(q1), .result(result1));

  multiplier mul12(.dataa(Q2), .datab(q2), .result(result2));


  romA matA2(.address_a(A3), .address_b(A4), .clock(clock),
              .q_a(Q3), .q_b(Q4));
  romB matB2(.address_a(B3), .address_b(B4), .clock(clock),
              .q_a(q3), .q_b(q4));

  multiplier mul21(.dataa(Q3), .datab(q3), .result(result3));

  multiplier mul22(.dataa(Q4), .datab(q4), .result(result4));


  romA matA3(.address_a(A5), .address_b(A6), .clock(clock),
              .q_a(Q5), .q_b(Q6));
  romB matB3(.address_a(B5), .address_b(B6), .clock(clock),
              .q_a(q5), .q_b(q6));

  multiplier mul31(.dataa(Q5), .datab(q5), .result(result5));

  multiplier mul32(.dataa(Q6), .datab(q6), .result(result6));

  romA matA4(.address_a(A7), .address_b(A8), .clock(clock),
              .q_a(Q7), .q_b(Q8));
  romB matB4(.address_a(B7), .address_b(B8), .clock(clock),
              .q_a(q7), .q_b(q8));

  multiplier mul41(.dataa(Q7), .datab(q7), .result(result7));

  multiplier mul42(.dataa(Q8), .datab(q8), .result(result8));

  romA matA5(.address_a(A9), .address_b(A10), .clock(clock),
              .q_a(Q9), .q_b(Q10));
  romB matB5(.address_a(B9), .address_b(B10), .clock(clock),
              .q_a(q9), .q_b(q10));

  multiplier mul51(.dataa(Q9), .datab(q9), .result(result9));

  multiplier mul52(.dataa(Q10), .datab(q10), .result(result10));

  romA matA6(.address_a(A11), .address_b(A12), .clock(clock),
              .q_a(Q11), .q_b(Q12));
  romB matB6(.address_a(B11), .address_b(B12), .clock(clock),
              .q_a(q11), .q_b(q12));

  multiplier mul61(.dataa(Q11), .datab(q11), .result(result11));

  multiplier mul62(.dataa(Q12), .datab(q12), .result(result12));

  romA matA7(.address_a(A13), .address_b(A14), .clock(clock),
              .q_a(Q13), .q_b(Q14));
  romB matB7(.address_a(B13), .address_b(B14), .clock(clock),
              .q_a(q13), .q_b(q14));

  multiplier mul71(.dataa(Q13), .datab(q13), .result(result13));

  multiplier mul72(.dataa(Q14), .datab(q14), .result(result14));

  romA matA8(.address_a(A15), .address_b(A16), .clock(clock),
              .q_a(Q15), .q_b(Q16));
  romB matB8(.address_a(B15), .address_b(B16), .clock(clock),
              .q_a(q15), .q_b(q16));

  multiplier mul81(.dataa(Q15), .datab(q15), .result(result15));

  multiplier mul82(.dataa(Q16), .datab(q16), .result(result16));


  always_ff @ (posedge clock, negedge reset_l) begin
    if(~reset_l) begin
      A1 = 0;
      A2 = 1;
      B1 = 0;
      B2 = 1;
      A3 = 2; A4 = 3; A5 = 4; A6= 5;  A7= 6; A8= 7;
      A9 = 8; A10 = 9; A11= 10;
      A12 = 11; A13 = 12; A14= 13; A15= 14; A16 = 15;


      B3 = 2; B4 = 3; B5 = 4; B6= 5;  B7= 6; B8= 7;
      B9 = 8; B10 = 9; B11= 10;
      B12 = 11; B13 = 12; B14= 13; B15= 14; B16 = 15;


      clockTicks = 0;
      outResult = 0;
      rowCount = 0;
      tempresult = 0;
    end
    else if(rowCount < 'd65) begin
      A1 <= A1 + 16;
      A2 <= A2 + 16;
      A3 <= A3 + 16;
      A4 <= A4 + 16;
      A5 <= A5 + 16;
      A6 <= A6 + 16;
      A7 <= A7 + 16;
      A8 <= A8 + 16;
      A9 <= A9 + 16;
      A10 <= A10 + 16;
      A11 <= A11 + 16;
      A12 <= A12 + 16;
      A13 <= A13 + 16;
      A14 <= A14+ 16;
      A15 <= A15 + 16;
      A16 <= A16 + 16;


      B1 <= B1 + 16;
      B2 <=  B2 + 16;
      B3 <=   B3 + 16;
      B4 <=   B4 + 16;
      B5 <=   B5 + 16;
      B6 <=   B6 + 16;
      B7 <=   B7 + 16;
      B8 <=   B8 + 16;
      B9 <=   B9 + 16;
      B10 <=   B10 + 16;
      B11 <=   B11 + 16;
      B12 <=   B12 + 16;
      B13 <=   B13 + 16;
      B14 <=   B14+ 16;
      B15 <=   B15 + 16;
      B16 <=   B16 + 16;




      clockTicks <= clockTicks + 1;

      tempresult <= (clockTicks == 0)? 0: (tempresult + result1+
                  result2+ result3+ result4+ result5+ result6 +
                  result7+ result8+ result9+ result10+ result11 +
                  result12+ result13+ result14+ result15 +result16);

      rowCount <= (B1 == 0)? rowCount + 1: rowCount;
      outResult <= 0;
    end
    else begin
      outResult <= tempresult;
      clockTicks <= clockTicks;
    end
  end

endmodule: matrixMultiply

module ChipInterface
  (input  logic       CLOCK_50,
   input  logic [9:0] SW,
   input  logic [2:0] BUTTON,
   output logic [6:0] HEX3_D, HEX2_D, HEX1_D, HEX0_D);

   logic [15:0] outResult, clockTicks;
   logic [3:0] BCD3, BCD2, BCD1, BCD0;
	 logic [3:0] turn_on;

   assign turn_on = 4'b0000;
	 assign BCD0 = (SW == 0) ? outResult[3:0] : clockTicks[3:0];
	 assign BCD1 = (SW == 0) ? outResult[7:4] : clockTicks[7:4];
	 assign BCD2 = (SW == 0) ? outResult[11:8] : clockTicks[11:8];
	 assign BCD3 = (SW == 0) ? outResult[15:12] : clockTicks[15:12];

   matrixMultiply Mm(.clock(CLOCK_50), .reset_l(BUTTON[0]),
                      .outResult(outResult), .clockTicks(clockTicks));


   SevenSegmentControl lightup(.HEX0(HEX0_D), .HEX1(HEX1_D),
                      .HEX2(HEX2_D), .HEX3(HEX3_D), .*);

endmodule: ChipInterface

// module tb;
//   logic clock;
//   logic [11:0] A1, A2;
//   logic [5:0] B1, B2;
//   logic [7:0] Q1, Q2, q1, q2;
//   logic [7:0] dataa1, datab1, dataa2, datab2;
//   logic [15:0] result1, result2;
//   logic [15:0] tempresult;
//   logic [15:0] clockTicks;
//   logic [7:0] rowCount;
//   logic [15:0] outResult;
//   logic reset_l;
//
//   matrixMultiply dut(.*);
//
//     initial begin
//       clock = 0;
//       reset_l = 0;
//       reset_l <= #1 1;
//       forever #5 clock = ~clock;
//     end
//
//     initial begin
//       $monitor ($time,,"reset = %b, tempresult = %h, rowCount = %d, clockTicks = %d, outResult = %h, B1 = %d",
//                             reset_l, dut.tempresult, dut.rowCount, dut.clockTicks, dut.outResult, dut.B1);
//       #300000 $finish;
//     end
// endmodule: tb
