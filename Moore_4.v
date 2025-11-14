`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 05:16:34 PM
// Design Name: 
// Module Name: Moore_4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Moore_4(
    input  wire clk,
    input  wire reset,
    input  wire P1,   // represents input bit = 1
    input  wire P2,   // represents input bit = 0
    output reg  z     // goes high when 1100 detected (Moore)
);

    // State encoding
    // S0: no match
    // S1: matched '1'
    // S2: matched '11'
    // S3: matched '110'
    // S4: matched '1100'  -> output = 1
    localparam S0 = 3'd0,
               S1 = 3'd1,
               S2 = 3'd2,
               S3 = 3'd3,
               S4 = 3'd4;

    reg [2:0] PS, NS;  // Present State, Next State

    // 1) State register (sequential)
    always @(posedge clk or posedge reset) begin
        if (reset)
            PS <= S0;
        else
            PS <= NS;
    end

    // 2) Next-state logic (combinational)
    always @(*) begin
        NS = PS;   // default
        case (PS)
            S0: begin
                if (P1)       NS = S1;   // saw '1'
                else if (P2)  NS = S0;   // saw '0'
            end

            S1: begin
                if (P1)       NS = S2;   // matched "11"
                else if (P2)  NS = S0;   // pattern broke
            end

            S2: begin
                if (P2)       NS = S3;   // matched "110"
                else if (P1)  NS = S2;   // still "11..." (overlap)
            end

            S3: begin
                if (P2)       NS = S4;   // matched "1100"
                else if (P1)  NS = S1;   // could be start of new pattern
            end

            S4: begin
                // already detected 1100 (Moore output state)
                // next bit may start a new match
                if (P1)       NS = S1;
                else if (P2)  NS = S0;
            end

            default: NS = S0;
        endcase
    end

    // 3) Output logic (pure Moore: depends ONLY on PS)
    always @(*) begin
        case (PS)
            S4:     z = 1'b1;  // pattern 1100 detected
            default z = 1'b0;
        endcase
    end

endmodule



