`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 09:30:54 PM
// Design Name: 
// Module Name: UP_Counter_tb
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


module UP_Counter_tb;

    reg clk;
    reg reset;
    wire [11:0] count;

    // Instantiate DUT
    UP_Counter dut (
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initial values
        reset = 1;
        #20;
        reset = 0;

        // Run counter for a while
        // (You can adjust this to run longer)
        #500;

        // Apply reset mid-way
        reset = 1;
        #20;
        reset = 0;

        #200;
        $finish;
    end

    // Optional console monitor
    initial begin
        $display(" time     clk   reset    count");
        $monitor("%4t     %b      %b       %d", $time, clk, reset, count);
    end

endmodule

