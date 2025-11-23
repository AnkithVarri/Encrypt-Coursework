/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

`include "params.h"

module encrypt_comb(  input wire [ `N_K - 1 : 0 ]   k,   //  input    data: cipher key
                      input wire [ `N_B - 1 : 0 ]   m,   //  input    data:  plaintext message
                     output wire [ `N_B - 1 : 0 ]   c ); // output    data: ciphertext message

            wire  [63:0] w;       //Output of m
            perm_IP p1(w, m);


            wire  [55:0] w1;         //Output of k
            perm_PC1 pc(w1, k);

            wire [31:0] sm0, sm1;   // Split 2: sm0=L0, sm1=R0
            split_2 s2(sm0,sm1,w);


            wire [55:0] k1;  // output wire 1
            wire [47:0] rm1;
            wire [31:0] sm2, sm3; 

            key_schedule ks1(k1, rm1, w1, 4'b0000);
            round rd1 (sm2,sm3,sm1, sm0, rm1);


            wire [55:0] k2;  
            wire [47:0] rm2;
            wire [31:0] sm4, sm5; 

            key_schedule ks2(k2, rm2, k1, 4'b0001);
            round rd2 (sm4,sm5,sm2, sm3, rm2);  



            wire [55:0] k3; 
            wire [47:0] rm3;
            wire [31:0] sm6, sm7; 

            key_schedule ks3(k3, rm3, k2, 4'b0010);
            round rd3 (sm6,sm7,sm4, sm5, rm3); 



            wire [55:0] k4;  
            wire [47:0] rm4;
            wire [31:0] sm8, sm9; 

            key_schedule ks4(k4, rm4, k3, 4'b0011);
            round rd4 (sm8,sm9,sm6, sm7, rm4); 



            wire [55:0] k5;  
            wire [47:0] rm5;
            wire [31:0] sm10, sm11; 

            key_schedule ks5(k5, rm5, k4, 4'b0100);
            round rd5 (sm10,sm11,sm8, sm9, rm5); 



            wire [55:0] k6; 
            wire [47:0] rm6;
            wire [31:0] sm12, sm13; 

            key_schedule ks6(k6, rm6, k5, 4'b0101);
            round rd6(sm12,sm13,sm10, sm11, rm6);  



            wire [55:0] k7;  
            wire [47:0] rm7;
            wire [31:0] sm14, sm15; 

            key_schedule ks7(k7, rm7, k6, 4'b0110);
            round rd7 (sm14,sm15,sm12, sm13, rm7);  


            wire [55:0] k8;  
            wire [47:0] rm8;
            wire [31:0] sm16, sm17; 

            key_schedule ks8(k8, rm8, k7, 4'b0111);
            round rd8 (sm16,sm17,sm14, sm15, rm8);  



            wire [55:0] k9; 
            wire [47:0] rm9;
            wire [31:0] sm18, sm19; 

            key_schedule ks9(k9, rm9, k8, 4'b1000);
            round rd9 (sm18,sm19,sm16, sm17, rm9); 


            wire [55:0] k10;  
            wire [47:0] rm10;
            wire [31:0] sm20, sm21; 

            key_schedule ks10(k10, rm10, k9, 4'b1001);
            round rd10 (sm20,sm21,sm18, sm19, rm10);  



            wire [55:0] k11;  
            wire [47:0] rm11;
            wire [31:0] sm22, sm23; 

            key_schedule ks11(k11, rm11, k10, 4'b1010);
            round rd11 (sm22,sm23,sm20, sm21, rm11); 



            wire [55:0] k12;  
            wire [47:0] rm12;
            wire [31:0] sm24, sm25; 

            key_schedule ks12(k12, rm12, k11, 4'b1011);
            round rd12(sm24,sm25,sm22, sm23, rm12);  



            wire [55:0] k13; 
            wire [47:0] rm13;
            wire [31:0] sm26, sm27; 

            key_schedule ks13(k13, rm13, k12, 4'b1100);
            round rd13(sm26,sm27,sm24, sm25, rm13);  



            wire [55:0] k14; 
            wire [47:0] rm14;
            wire [31:0] sm28, sm29; 

            key_schedule ks14(k14, rm14, k13, 4'b1101);
            round rd14(sm28,sm29,sm26, sm27, rm14);  



            wire [55:0] k15;  
            wire [47:0] rm15;
            wire [31:0] sm30, sm31; 

            key_schedule ks15(k15, rm15, k14, 4'b1110);
            round rd15(sm30,sm31,sm28, sm29, rm15);  



            wire [55:0] k16;  // output wire.  -- 16th ROUND
            wire [47:0] rm16;
            wire [31:0] sm32, sm33; 

            key_schedule ks16(k16, rm16, k15, 4'b1111);
            round rd16(sm32,sm33,sm30, sm31, rm16); 

            wire [63:0] mgOut;
            merge_2 mg2(mgOut, sm32, sm33);

            wire [63:0] pOut;
            perm_FP pFP(pOut, mgOut);

            assign c = pOut;
            
endmodule