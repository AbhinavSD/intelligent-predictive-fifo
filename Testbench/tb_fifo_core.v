`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2026 20:20:39
// Design Name: 
// Module Name: tb_fifo_core
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

`timescale 1ns/1ps

module tb_fifo_core;

    reg clk;
    reg rst;

    reg wr_en;
    reg rd_en;

    reg [7:0] data_in;

    wire [7:0] data_out;
    wire full;
    wire empty;
    wire [4:0] occupancy;

    integer i;

    // DUT
    fifo_core uut (
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
    // Clock Generation (10ns Period)
    //--------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //--------------------------------------------------
    // Monitor
    //--------------------------------------------------
    initial begin
        $monitor(
        "T=%0t | wr=%b rd=%b | din=%0d dout=%0d | occ=%0d | full=%b empty=%b",
        $time, wr_en, rd_en, data_in, data_out,
        occupancy, full, empty);
    end
always @(posedge clk)
begin
    if(rd_en && !empty)
        $display("TIME=%0t READ=%0d", $time, data_out);
end
    //--------------------------------------------------
    // Test Sequence
    //--------------------------------------------------
    initial begin

        //--------------------------------------------------
        // Reset
        //--------------------------------------------------
        rst     = 1;
        wr_en   = 0;
        rd_en   = 0;
        data_in = 0;

        #20;
        rst = 0;

        //--------------------------------------------------
        // TEST 1 : Write 11,22,33
        //--------------------------------------------------
        $display("\n===== TEST 1 : WRITE 11,22,33 =====");

        @(posedge clk);
        wr_en   = 1;
        data_in = 8'd11;

        @(posedge clk);
        data_in = 8'd22;

        @(posedge clk);
        data_in = 8'd33;

        @(posedge clk);
        wr_en = 0;

        //--------------------------------------------------
        // TEST 2 : Read back
        //--------------------------------------------------
        $display("\n===== TEST 2 : READ DATA =====");

        @(posedge clk);
        rd_en = 1;

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

        rd_en = 0;

        //--------------------------------------------------
        // TEST 3 : Read when Empty
        //--------------------------------------------------
        $display("\n===== TEST 3 : READ WHEN EMPTY =====");

        @(posedge clk);
        rd_en = 1;

        @(posedge clk);
        rd_en = 0;

        //--------------------------------------------------
        // TEST 4 : Fill FIFO completely
        //--------------------------------------------------
        $display("\n===== TEST 4 : FILL FIFO =====");

        for(i=0; i<16; i=i+1)
        begin
            @(posedge clk);
            wr_en   = 1;
            data_in = i;
        end

        @(posedge clk);
        wr_en = 0;

        //--------------------------------------------------
        // TEST 5 : Write when Full
        //--------------------------------------------------
        $display("\n===== TEST 5 : WRITE WHEN FULL =====");

        @(posedge clk);
        wr_en   = 1;
        data_in = 8'hAA;

        @(posedge clk);
        wr_en = 0;

        //--------------------------------------------------
        // TEST 6 : Simultaneous Read + Write
        //--------------------------------------------------
        $display("\n===== TEST 6 : SIMULTANEOUS READ/WRITE =====");

        @(posedge clk);
        wr_en   = 1;
        rd_en   = 1;
        data_in = 8'h55;

        @(posedge clk);

        wr_en = 0;
        rd_en = 0;

        //--------------------------------------------------
        // TEST 7 : Empty FIFO completely
        //--------------------------------------------------
        $display("\n===== TEST 7 : EMPTY FIFO =====");

        rd_en = 1;

        repeat(20)
            @(posedge clk);

        rd_en = 0;

        //--------------------------------------------------
        // End Simulation
        //--------------------------------------------------
        #20;

        $display("\n===== SIMULATION FINISHED =====");

        $finish;

    end

endmodule
