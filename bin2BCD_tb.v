`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 10:02:49 PM
// Design Name: 
// Module Name: bin2BCD_tb
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


module bin2BCD_tb;

    reg        clk;
    reg        en;
    reg [11:0] bin_d_in;
    wire [15:0] bcd_d_out;
    wire       rdy;

    bin2BCD dut (
        .clk(clk),
        .en(en),
        .bin_d_in(bin_d_in),
        .bcd_d_out(bcd_d_out),
        .rdy(rdy)
    );

    // Clock: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Simple task to start a conversion
    task do_convert;
        input [11:0] value;
    begin
        bin_d_in = value;
        en       = 1;
        #10;          // one clock period
        en       = 0;

        // wait until rdy goes high
        wait (rdy == 1);
        #10;          // look one more cycle for clean display

        $display("BIN = %4d  =>  BCD digits = %1d%1d%1d%1d",
                 value,
                 bcd_d_out[15:12],  // thousands
                 bcd_d_out[11:8],   // hundreds
                 bcd_d_out[7:4],    // tens
                 bcd_d_out[3:0]);   // ones
    end
    endtask

    initial begin
        // init
        en       = 0;
        bin_d_in = 0;

        #20;

        do_convert(12'd0);
        do_convert(12'd5);
        do_convert(12'd9);
        do_convert(12'd10);
        do_convert(12'd255);
        do_convert(12'd4095);  // max value

        #50;
        $finish;
    end

endmodule

