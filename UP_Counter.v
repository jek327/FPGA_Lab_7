`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 09:30:01 PM
// Design Name: 
// Module Name: UP_Counter
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


module UP_Counter (
    input  wire clk,
    input  wire reset,        // asynchronous active-high reset
    output reg  [11:0] count  // 12-bit counter (0 to 4095)
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 12'd0;              // reset count to 0
        else
            count <= count + 12'd1;      // increment by 1
    end

endmodule
