`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 10:40:41 PM
// Design Name: 
// Module Name: Bin_BCD
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


module Bin_BCD(
    input        clk,
    input        en,           // start conversion when en=1 (for one cycle in IDLE)
    input  [11:0] bin_d_in,    // 12-bit binary input (0-4095)
    output [15:0] bcd_d_out,   // 4 BCD digits: [15:12]=thousands, [11:8]=hundreds, [7:4]=tens, [3:0]=ones
    output       rdy           // goes high for 1 cycle when result is ready
    );

    // States
    parameter IDLE  = 3'b000;
    parameter SETUP = 3'b001;
    parameter ADD   = 3'b010;
    parameter SHIFT = 3'b011;
    parameter DONE  = 3'b100;

    reg [27:0] bcd_data   = 28'd0;  // [27:12]=BCD, [11:0]=binary
    reg [2:0]  state      = IDLE;
    reg [3:0]  sh_counter = 4'd0;   // counts how many shifts done (0..11)
    reg        result_rdy = 1'b0;

    // Main FSM
    always @(posedge clk) begin
        case (state)

            // Wait for 'en' to start a new conversion
            IDLE: begin
                result_rdy <= 1'b0;
                if (en) begin
                    // load binary into lower 12 bits, clear BCD digits
                    bcd_data   <= {16'd0, bin_d_in};
                    sh_counter <= 4'd0;
                    state      <= SETUP;
                end
            end

            // Just a staging state; immediately go to ADD
            SETUP: begin
                state <= ADD;
            end

            // Double dabble: if any BCD digit >= 5, add 3 to it
            ADD: begin
                // thousands digit [27:24]
                if (bcd_data[27:24] >= 5)
                    bcd_data[27:24] <= bcd_data[27:24] + 4'd3;
                // hundreds digit [23:20]
                if (bcd_data[23:20] >= 5)
                    bcd_data[23:20] <= bcd_data[23:20] + 4'd3;
                // tens digit [19:16]
                if (bcd_data[19:16] >= 5)
                    bcd_data[19:16] <= bcd_data[19:16] + 4'd3;
                // ones digit [15:12]
                if (bcd_data[15:12] >= 5)
                    bcd_data[15:12] <= bcd_data[15:12] + 4'd3;

                state <= SHIFT;
            end

            // Shift left by 1; repeat until we've shifted 12 times
            SHIFT: begin
                bcd_data   <= bcd_data << 1;
                sh_counter <= sh_counter + 1'b1;

                if (sh_counter == 4'd11)  // done 12 shifts (0..11)
                    state <= DONE;
                else
                    state <= ADD;
            end

            // Conversion finished
            DONE: begin
                result_rdy <= 1'b1;  // pulse ready
                state      <= IDLE;  // back to idle
            end

            default: begin
                state <= IDLE;
            end
        endcase
    end

    // Outputs
    assign bcd_d_out = bcd_data[27:12]; // 4 BCD digits
    assign rdy       = result_rdy;

endmodule
