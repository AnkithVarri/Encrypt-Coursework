/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */






module key_schedule( output wire [ 55 : 0 ] r,
                     output wire [ 47 : 0 ] k,
                      input wire [ 55 : 0 ] x,
                      input wire [  3 : 0 ] i );

    wire [27:0] r0;
    wire [27:0] r1; 
    
    split_0 s1(r0, r1, x);

    wire [27:0] r2;
    wire [27:0] r3; 
        
    clr_28bit clr_left  (r2, r0, i);    
    clr_28bit clr_right (r3, r1, i);   

    wire [55:0] out;

    merge_0 m1(out, r2, r3);
    
    assign r = out;
    perm_PC2 p1(k, out);
endmodule
