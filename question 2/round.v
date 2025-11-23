/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

module round(
        output wire [31:0] rl,
        output wire [31:0] rr,
        input  wire [31:0] xl,
        input  wire [31:0] xr,
        input  wire [47:0] k
    );

    wire [47:0] exp;
    perm_E p1(exp, xr);

    wire [47:0] x;
    assign x = exp ^ k;

    wire [5:0] r0,r1,r2,r3,r4,r5,r6,r7;

    split_1 sp1(r0,r1,r2,r3,r4,r5,r6,r7,x);
    wire [3:0] s0,s1,s2,s3,s4,s5,s6,s7; 

    sbox_0 sb0(s0, r0);
    sbox_1 sb1(s1, r1);
    sbox_2 sb2(s2, r2);
    sbox_3 sb3(s3, r3);
    sbox_4 sb4(s4, r4);
    sbox_5 sb5(s5, r5);
    sbox_6 sb6(s6, r6);
    sbox_7 sb7(s7, r7);

    wire [31:0] merge;
    merge_1 m1(merge,s0,s1,s2,s3,s4,s5,s6,s7);

    wire [31:0] perm;
    perm_P pp1(perm, merge);

    assign rr =  perm ^ xl;
    assign rl = xr;

endmodule

