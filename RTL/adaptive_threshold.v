`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2026 23:02:30
// Design Name: 
// Module Name: adaptive_threshold
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

module adaptive_threshold(

    input burst_detect,
    input [4:0] predicted_occupancy,

    output reg [4:0] adaptive_threshold,
    output reg warning
);

    always @(*)
    begin

        // Default values
        adaptive_threshold = 5'd14;

        if(burst_detect)
            adaptive_threshold = 5'd10;

        else if(predicted_occupancy >= 5'd14)
            adaptive_threshold = 5'd11;

        else if(predicted_occupancy >= 5'd12)
            adaptive_threshold = 5'd12;

        else if(predicted_occupancy >= 5'd8)
            adaptive_threshold = 5'd13;

        else
            adaptive_threshold = 5'd14;

        warning =
            (predicted_occupancy >= adaptive_threshold);

    end

endmodule
