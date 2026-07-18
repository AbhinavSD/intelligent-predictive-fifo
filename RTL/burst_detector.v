`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2026 21:56:04
// Design Name: 
// Module Name: burst_detector
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


module burst_detector #(
    parameter BURST_THRESHOLD = 4
)(
    input [3:0] writes_last_window,
    input [3:0] reads_last_window,

    output burst_detect
);

    wire signed [4:0] net_traffic;

    assign net_traffic =
           $signed({1'b0,writes_last_window}) -
           $signed({1'b0,reads_last_window});

    assign burst_detect =
           (net_traffic >= BURST_THRESHOLD);

endmodule
