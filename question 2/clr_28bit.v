/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */


module mux2_1bit (output wire r,
                  input wire c,
                  input wire x,
                  input wire y );
              
  wire w0 , w1 , w2;

  not t0( w0 , c );

  and t1( w1 , x, w0 );
  and t2( w2 , y, c );

  or t3( r, w1 , w2 );
endmodule 



module clr_28bit( output wire [ 27 : 0 ] r,
                   input wire [ 27 : 0 ] x,
                   input wire [  3 : 0 ] y );

    // Check if y == 0, y == 1, y == 8, y == 15

    wire eq0, eq1, eq8, eq15, help1, help2, ctrl;

    and(eq0, ~y[3],~y[2],~y[1], ~y[0]); // 0
    and(eq1, ~y[3],~y[2],~y[1], y[0]); // 1
    and(eq8, y[3], ~y[2],~y[1], ~y[0]); // 8
    and(eq15, y[3], y[2], y[1],  y[0]); // 15

  
    or(help1,  eq0, eq1);
    or(help2,  eq8, eq15); 
    or(ctrl, help1, help2); // The control signal seeing whether to do left shift 1 or 2




  mux2_1bit m0 (r[0], ctrl, x[26], x[27]);  // shift by 1: from 27, shift by 2: from 26
  mux2_1bit m1 (r[1], ctrl, x[27], x[0]);   // shift by 1: from 0, shift by 2: from 27
  mux2_1bit m2 (r[2], ctrl, x[0], x[1]);    // shift by 1: from 1, shift by 2: from 0
  mux2_1bit m3 (r[3], ctrl, x[1], x[2]);    // shift by 1: from 2, shift by 2: from 1

  mux2_1bit m4 (r[4], ctrl, x[2], x[3]);    // shift by 1: from 3, shift by 2: from 2
  mux2_1bit m5 (r[5], ctrl, x[3], x[4]);    // shift by 1: from 4, shift by 2: from 3
  mux2_1bit m6 (r[6], ctrl, x[4], x[5]);    // shift by 1: from 5, shift by 2: from 4
  mux2_1bit m7 (r[7], ctrl, x[5], x[6]);    // shift by 1: from 6, shift by 2: from 5

  mux2_1bit m8 (r[8], ctrl, x[6], x[7]);     // shift by 1: from 7, shift by 2: from 6
  mux2_1bit m9 (r[9], ctrl, x[7], x[8]);    // shift by 1: from 8, shift by 2: from 7
  mux2_1bit m10 (r[10], ctrl, x[8], x[9]);  // shift by 1: from 9, shift by 2: from 8
  mux2_1bit m11 (r[11], ctrl, x[9], x[10]); // shift by 1: from 10, shift by 2: from 9

  mux2_1bit m12 (r[12], ctrl, x[10], x[11]); // shift by 1: from 11, shift by 2: from 10
  mux2_1bit m13 (r[13], ctrl, x[11], x[12]); // shift by 1: from 12, shift by 2: from 11
  mux2_1bit m14 (r[14], ctrl, x[12], x[13]); // shift by 1: from 13, shift by 2: from 12
  mux2_1bit m15 (r[15], ctrl, x[13], x[14]); // shift by 1: from 14, shift by 2: from 13

  mux2_1bit m16 (r[16], ctrl, x[14], x[15]); // shift by 1: from 15, shift by 2: from 14
  mux2_1bit m17 (r[17], ctrl, x[15], x[16]); // shift by 1: from 16, shift by 2: from 15
  mux2_1bit m18 (r[18], ctrl, x[16], x[17]); // shift by 1: from 17, shift by 2: from 16
  mux2_1bit m19 (r[19], ctrl, x[17], x[18]); // shift by 1: from 18, shift by 2: from 17

  mux2_1bit m20 (r[20], ctrl, x[18], x[19]); // shift by 1: from 19, shift by 2: from 18
  mux2_1bit m21 (r[21], ctrl, x[19], x[20]); // shift by 1: from 20, shift by 2: from 19
  mux2_1bit m22 (r[22], ctrl, x[20], x[21]); // shift by 1: from 21, shift by 2: from 20
  mux2_1bit m23 (r[23], ctrl, x[21], x[22]); // shift by 1: from 22, shift by 2: from 21

  mux2_1bit m24 (r[24], ctrl, x[22], x[23]); // shift by 1: from 23, shift by 2: from 22
  mux2_1bit m25 (r[25], ctrl, x[23], x[24]); // shift by 1: from 24, shift by 2: from 23
  mux2_1bit m26 (r[26], ctrl, x[24], x[25]); // shift by 1: from 25, shift by 2: from 24
  mux2_1bit m27 (r[27], ctrl, x[25], x[26]); // shift by 1: from 26, shift by 2: from 25
  // Stage 1: c omplete this module implementation

endmodule




