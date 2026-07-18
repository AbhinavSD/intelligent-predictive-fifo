`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.06.2026 20:13:13
// Design Name: 
// Module Name: intelligent_fifo_top
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


module intelligent_fifo_top(

    input clk,
    input rst,

    input wr_en,
    input rd_en,

    input [7:0] data_in,

    output [7:0] data_out,

    output full,
    output empty,

    output burst_detect,

    output [4:0] predicted_occupancy,
    output [4:0] adaptive_threshold,

    output warning,

    // Debug Outputs
    output [4:0] occupancy_dbg,
    output [3:0] writes_last_window_dbg,
    output [3:0] reads_last_window_dbg

);

    //--------------------------------------------------
    // Internal Signals
    //--------------------------------------------------

    wire [4:0] occupancy;

    wire [3:0] write_count;
    wire [3:0] read_count;

    wire [3:0] writes_last_window;
    wire [3:0] reads_last_window;

    //--------------------------------------------------
    // FIFO Core
    //--------------------------------------------------

    fifo_core fifo_core_inst(

        .clk(clk),
        .rst(rst),

        .wr_en(wr_en),
        .rd_en(rd_en),

        .data_in(data_in),
        .data_out(data_out),

        .full(full),
        .empty(empty),

        .occupancy(occupancy)
    );

    //--------------------------------------------------
    // Traffic Monitor
    //--------------------------------------------------

    traffic_monitor traffic_monitor_inst(

        .clk(clk),
        .rst(rst),

        .wr_en(wr_en),
        .rd_en(rd_en),

        .write_count(write_count),
        .read_count(read_count),

        .writes_last_window(writes_last_window),
        .reads_last_window(reads_last_window)
    );

    //--------------------------------------------------
    // Burst Detector
    //--------------------------------------------------

    burst_detector burst_detector_inst(

        .writes_last_window(writes_last_window),
        .reads_last_window(reads_last_window),

        .burst_detect(burst_detect)
    );

    //--------------------------------------------------
    // Occupancy Predictor
    //--------------------------------------------------

    occupancy_predictor occupancy_predictor_inst(

        .occupancy(occupancy),

        .writes_last_window(writes_last_window),
        .reads_last_window(reads_last_window),

        .predicted_occupancy(predicted_occupancy)
    );

    //--------------------------------------------------
    // Adaptive Threshold
    //--------------------------------------------------

    adaptive_threshold adaptive_threshold_inst(

        .burst_detect(burst_detect),

        .predicted_occupancy(predicted_occupancy),

        .adaptive_threshold(adaptive_threshold),

        .warning(warning)
    );

    //--------------------------------------------------
    // Debug Connections
    //--------------------------------------------------

    assign occupancy_dbg          = occupancy;
    assign writes_last_window_dbg = writes_last_window;
    assign reads_last_window_dbg  = reads_last_window;

endmodule
