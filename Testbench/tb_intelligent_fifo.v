`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.06.2026 20:46:23
// Design Name: 
// Module Name: tb_intelligent_fifo
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


module tb_intelligent_fifo;

    reg clk;
    reg rst;

    reg wr_en;
    reg rd_en;

    reg [7:0] data_in;

    wire [7:0] data_out;

    wire full;
    wire empty;

    wire burst_detect;

    wire [4:0] predicted_occupancy;
    wire [4:0] adaptive_threshold;

    wire warning;

    wire [4:0] occupancy_dbg;

    wire [3:0] writes_last_window_dbg;
    wire [3:0] reads_last_window_dbg;

    //--------------------------------------------------
    // DUT
    //--------------------------------------------------

    intelligent_fifo_top dut(

        .clk(clk),
        .rst(rst),

        .wr_en(wr_en),
        .rd_en(rd_en),

        .data_in(data_in),

        .data_out(data_out),

        .full(full),
        .empty(empty),

        .burst_detect(burst_detect),

        .predicted_occupancy(predicted_occupancy),
        .adaptive_threshold(adaptive_threshold),

        .warning(warning),

        .occupancy_dbg(occupancy_dbg),

        .writes_last_window_dbg(writes_last_window_dbg),
        .reads_last_window_dbg(reads_last_window_dbg)
    );

    //--------------------------------------------------
    // Clock Generation
    //--------------------------------------------------

    initial
    begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //--------------------------------------------------
    // Console Monitor
    //--------------------------------------------------

    initial
    begin

        $display("--------------------------------------------------------------");
        $display("TIME OCC WR_WIN RD_WIN BURST PRED THR WARN FULL EMPTY");
        $display("--------------------------------------------------------------");

        $monitor("%0t   %0d    %0d      %0d      %0b      %0d    %0d    %0b    %0b    %0b",
                 $time,
                 occupancy_dbg,
                 writes_last_window_dbg,
                 reads_last_window_dbg,
                 burst_detect,
                 predicted_occupancy,
                 adaptive_threshold,
                 warning,
                 full,
                 empty);
    end

    //--------------------------------------------------
    // Stimulus
    //--------------------------------------------------

    initial
    begin

        rst     = 1;
        wr_en   = 0;
        rd_en   = 0;
        data_in = 8'd0;

        #20;
        rst = 0;

        //--------------------------------------------------
        // TEST 1 : Balanced Traffic
        //--------------------------------------------------

        repeat(4)
        begin
            @(posedge clk);
            wr_en   <= 1;
            rd_en   <= 1;
            data_in <= data_in + 1;
        end

        @(posedge clk);
        wr_en <= 0;
        rd_en <= 0;

        #20;

        //--------------------------------------------------
        // TEST 2 : Write Burst
        //--------------------------------------------------

        repeat(8)
        begin
            @(posedge clk);
            wr_en   <= 1;
            rd_en   <= 0;
            data_in <= data_in + 1;
        end

        @(posedge clk);
        wr_en <= 0;

        #20;

        //--------------------------------------------------
        // TEST 3 : Read Burst
        //--------------------------------------------------

        repeat(6)
        begin
            @(posedge clk);
            wr_en <= 0;
            rd_en <= 1;
        end

        @(posedge clk);
        rd_en <= 0;

        #20;

        //--------------------------------------------------
        // TEST 4 : Near Full Condition
        //--------------------------------------------------

        repeat(12)
        begin
            @(posedge clk);
            wr_en   <= 1;
            rd_en   <= 0;
            data_in <= data_in + 1;
        end

        @(posedge clk);
        wr_en <= 0;

        //--------------------------------------------------
        // Finish
        //--------------------------------------------------

        #100;

        $display("");
        $display("========== SIMULATION COMPLETED ==========");
        $display("");

        $finish;

    end

endmodule
