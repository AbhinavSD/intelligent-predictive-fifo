`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2026 22:16:34
// Design Name: 
// Module Name: occupancy_predictor
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


module occupancy_predictor(

    input [4:0] occupancy,

    input [3:0] writes_last_window,
    input [3:0] reads_last_window,

    output reg [4:0] predicted_occupancy

);

    reg signed [5:0] temp_prediction;

    always @(*)
    begin

        temp_prediction =
            $signed({1'b0,occupancy}) +
            $signed({1'b0,writes_last_window}) -
            $signed({1'b0,reads_last_window});

        if(temp_prediction < 0)
            predicted_occupancy = 0;

        else if(temp_prediction > 16)
            predicted_occupancy = 16;

        else
            predicted_occupancy = temp_prediction[4:0];

    end

endmodule
