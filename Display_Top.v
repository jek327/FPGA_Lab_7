`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 11:02:31 PM
// Design Name: 
// Module Name: Display_Top
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


module Display_Top(
    input  mclk,             // 100 MHz Basys-3 clock
    input  reset,            // optional reset button
    output [6:0] seg,
    output [3:0] an
);

    // Wires between modules
    wire clk_slow;           // divided clock for counter / display
    wire [11:0] bin_cnt;     // counter output
    wire [15:0] bcd_d_out;   // BCD from converter
    wire rdy;                // ready from converter

    reg  [15:0] stat_bcd = 16'd0;  // latched BCD for display

    // 1) Clock divider
    Clock_Divider uut_clk (
        .clock_in   (mclk),
        .clock_out(clk_slow)
    );

    // 2) 12-bit UP counter (0..4095)
    UP_Counter uut_cnt (
        .clk    (clk_slow),
        .reset  (reset),
        .count(bin_cnt)
    );

    // 3) Binary -> BCD converter
    Bin_BCD uut_bcd (
        .clk      (clk_slow),
        .en       (1'b1),        // always enabled, or pulse if your FSM needs it
        .bin_d_in (bin_cnt),
        .bcd_d_out(bcd_d_out),
        .rdy      (rdy)
    );

    // 4) Latch BCD result when ready (optional - you can also just use bcd_d_out directly)
    always @(posedge clk_slow) begin
        if (rdy)
            stat_bcd <= bcd_d_out;
    end

    // 5) Multi-digit 7-seg driver
    Multiseg_Driver uut_disp (
        .clk   (clk_slow),   // or mclk if your driver expects fast clock
        .bcd_in(stat_bcd),   // 4 BCD digits
        .seg_cathode   (seg),
        .seg_anode    (an)
    );

endmodule

