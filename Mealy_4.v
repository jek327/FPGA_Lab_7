`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 09:06:10 PM
// Design Name: 
// Module Name: Mealy_4
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


module Mealy_4(
    input  P1, P2, clk, reset,   // P1 -> 1, P2 -> 0
    output reg z
);

    // State encoding
    parameter S0 = 2'd0,   // no match
              S1 = 2'd1,   // '1'
              S2 = 2'd2,   // '11'
              S3 = 2'd3;   // '110'

    reg [1:0] PS, NS;      // present state, next state

    // 1) State register (sequential)
    always @(posedge clk or posedge reset) begin
        if (reset)
            PS <= S0;
        else
            PS <= NS;
    end

    // 2) Next-state logic (combinational)
    always @(*) begin
        NS = PS;   // default, avoids latches
        case (PS)
            S0: begin
                if (P1)       NS = S1;   // saw '1'
                else if (P2)  NS = S0;   // saw '0'
            end

            S1: begin        // we have '1'
                if (P1)       NS = S2;   // '11'
                else if (P2)  NS = S0;   // '10' -> no useful prefix
            end

            S2: begin        // we have '11'
                if (P2)       NS = S3;   // '110'
                else if (P1)  NS = S2;   // '111' -> suffix '11' still good
            end

            S3: begin        // we have '110'
                if (P1)       NS = S1;   // '1101' detected -> suffix '1' is prefix
                else if (P2)  NS = S0;   // '1100' -> no prefix
            end
        endcase
    end

    // 3) Mealy output logic: depends on state + input
    always @(*) begin
        z = 0;   // default
        case (PS)
            S3: begin
                if (P1)      // current bit = 1, so we see 1101
                    z = 1;
            end
            default: z = 0;
        endcase
    end

endmodule

