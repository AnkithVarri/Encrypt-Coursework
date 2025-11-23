/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

`include "params.h"

module encrypt_iter(    input wire [ `N_K - 1 : 0 ]   k,   //  input    data: cipher key                      64 Bit 
                        input wire [ `N_B - 1 : 0 ]   m,   //  input    data:  plaintext message              64 Bit
                        output wire [ `N_B - 1 : 0 ]   c,   // output    data: ciphertext message              64 Bit
                        
                        input wire                  clk,   //  input control:       clock signal
                        input wire                  rst,   //  input control:       reset signal
                        input wire                  req,   //  input control:     request signal
                        output wire                  ack ); // output control: acknowledge signal

localparam IDLE = 2'b00;
localparam COMPUTE = 2'b01;
localparam FINISH = 2'b10;

reg [1:0] current_state; 
reg [1:0] next_state;    
reg ack_reg;
reg [4:0] round_count;

wire  [63:0] w;      
perm_IP p1(w, m);

wire  [55:0] w1;      
perm_PC1 pc(w1, k);

wire [31:0] sm0, sm1;   
split_2 s2(sm0, sm1, w);

reg [55:0] key;      
reg [31:0] left;   
reg [31:0] right;    
reg [63:0] c_temp;       

wire [55:0] key_next;           
wire [31:0] round_out_1;       
wire [31:0] round_out_2;         
wire [47:0] round_key;      

key_schedule ks(key_next, round_key, key, round_count[3:0] - 1'b1);
round rd(round_out_1, round_out_2, right, left, round_key);

wire [63:0] mgOut;
wire [63:0] pOut;
merge_2 mg2(mgOut, right, left);
perm_FP pFP(pOut, mgOut);

assign c = c_temp;
assign ack = ack_reg;

always @(posedge clk) begin
    if (rst) begin
        current_state <= IDLE;
        ack_reg <= 1'b0;
        round_count <= 5'b00001;
        key <= 56'b0;
        left <= 32'b0;
        right <= 32'b0;
        c_temp <= 64'b0;
    end else begin
        case (current_state)
            IDLE: begin
                if (req) begin
                    key <= w1;
                    left <= sm0;   
                    right <= sm1;  
                    round_count <= 5'b00001;
                    current_state <= COMPUTE;
                end else begin
                    current_state <= IDLE;
                end
                ack_reg <= 1'b0;
            end
            
            COMPUTE: begin
                key <= key_next;
                left <= round_out_2;  
                right <= round_out_1; 
                round_count <= round_count + 1;
                ack_reg <= 1'b0;
                    
                if (round_count > 15) begin
                    current_state <= FINISH;
                end else begin
                    current_state <= COMPUTE;
                end
            end
            
            FINISH: begin
                c_temp <= pOut;
                ack_reg <= 1'b1;
                
                if (!req) begin
                    current_state <= IDLE;
                end else begin
                    current_state <= FINISH;
                end
            end
            
            default: begin
                ack_reg <= 1'b0;
                current_state <= IDLE;
            end
        endcase
    end
end

endmodule