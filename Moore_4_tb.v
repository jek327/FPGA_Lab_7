`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 07:56:58 PM
// Design Name: 
// Module Name: Moore_4_tb
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


module Moore_4_tb;

    reg clk, reset;
    reg P1, P2;
    wire z;

    // DUT
    Moore_4 dut (
        .clk(clk),
        .reset(reset),
        .P1(P1),
        .P2(P2),
        .z(z)
    );

    // Clock generation: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Task to send one serial bit using P1/P2
    task send_bit;
        input b;
    begin
        if (b) begin
            P1 = 1; P2 = 0;   // bit = 1
        end else begin
            P1 = 0; P2 = 1;   // bit = 0
        end
        #10;                  // hold for one clock period
    end
    endtask

    initial begin
        // init
        P1 = 0; P2 = 0;
        reset = 1;
        #20;
        reset = 0;

        // Example input stream: 1 1 0 0  1 1 0 0
        send_bit(1);
        send_bit(1);
        send_bit(0);
        send_bit(0);   // z should go high here (first 1100)

        send_bit(1);
        send_bit(1);
        send_bit(0);
        send_bit(0);   // z high again (second 1100)

        #20;
        $finish;
    end

endmodule

