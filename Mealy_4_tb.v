`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 09:11:46 PM
// Design Name: 
// Module Name: Mealy_4_tb
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


module Mealy_4_tb;

    reg clk, reset;
    reg P1, P2;
    wire z;

    // DUT instance - change name/ports here if needed
    Mealy_4 dut (
        .P1(P1),
        .P2(P2),
        .clk(clk),
        .reset(reset),
        .z(z)
    );

    // 1) Clock generation: 10 ns period (100 MHz style)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 2) Task to send one serial bit using P1/P2
    // b = 1 → P1 = 1, P2 = 0
    // b = 0 → P1 = 0, P2 = 1
    task send_bit;
        input b;
    begin
        if (b) begin
            P1 = 1; P2 = 0;   // bit = 1
        end else begin
            P1 = 0; P2 = 1;   // bit = 0
        end
        #10;                  // hold for one full clock period
    end
    endtask

    // 3) Stimulus
    initial begin
        // Optional: initialize for nicer waveforms
        P1 = 0; P2 = 0;
        reset = 1;

        // Hold reset for a bit
        #20;
        reset = 0;

        // Now apply a sequence of bits.
        // We'll include a few 1101 patterns, including overlaps.

        // ---- First 1101 ----
        // Input stream: 1 1 0 1
        send_bit(1);   // expect: S0 -> S1
        send_bit(1);   // expect: S1 -> S2
        send_bit(0);   // expect: S2 -> S3
        send_bit(1);   // expect: S3 + input=1 → z = 1 (Mealy)

        // Some random bits in between
        send_bit(0);
        send_bit(0);

        // ---- Overlapping pattern: 1 1 0 1 1 0 1 ----
        // This tests that multiple detections work
        send_bit(1);   // start new pattern
        send_bit(1);
        send_bit(0);
        send_bit(1);   // first 1101 here → z should pulse
        send_bit(1);   // could be start of a new pattern again
        send_bit(0);
        send_bit(1);   // another 1101 → z should pulse again

        #40;
        $finish;
    end

endmodule

