`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 11:03:04 PM
// Design Name: 
// Module Name: Display_Top_tb
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


module Display_Top_tb;

    reg mclk;
    reg reset;
    wire [6:0] seg;
    wire [3:0] an;

    // DUT
    Display_Top dut (
        .mclk (mclk),
        .reset(reset),
        .seg  (seg),
        .an   (an)
    );

    // 100 MHz clock: 10 ns period
    initial begin
        mclk = 0;
        forever #5 mclk = ~mclk;
    end

    initial begin
        // Initial reset
        reset = 1;
        #50;          // hold reset for a little bit
        reset = 0;

        // Let the design run for a while
        #500000;      // 500 us of sim time (adjust as needed)
        $finish;
    end

    // Optional: monitor seg/an activity in the console
    initial begin
        $display(" time     reset   an    seg");
        $monitor("%6t   %b   %b   %b", $time, reset, an, seg);
    end

endmodule


