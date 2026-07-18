`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2026 22:45:52
// Design Name: 
// Module Name: traffic_monitor
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


module traffic_monitor #(
    parameter WINDOW = 8
)(
    input clk,
    input rst,

    input wr_en,
    input rd_en,

    // Current window counts
    output reg [3:0] write_count,
    output reg [3:0] read_count,

    // Previous completed window statistics
    output reg [3:0] writes_last_window,
    output reg [3:0] reads_last_window
);

    reg [2:0] window_counter;

    always @(posedge clk)
    begin
        if(rst)
        begin
            write_count        <= 4'd0;
            read_count         <= 4'd0;

            writes_last_window <= 4'd0;
            reads_last_window  <= 4'd0;

            window_counter     <= 3'd0;
        end
        else
        begin

            //------------------------------------------------
            // End of observation window
            //------------------------------------------------
            if(window_counter == WINDOW-1)
            begin

                // Save completed window statistics
                writes_last_window <= write_count + (wr_en ? 1'b1 : 1'b0);
                reads_last_window  <= read_count  + (rd_en ? 1'b1 : 1'b0);

                // Start new window
                write_count    <= 4'd0;
                read_count     <= 4'd0;

                window_counter <= 3'd0;

            end
            else
            begin

                // Count writes
                if(wr_en)
                    write_count <= write_count + 1'b1;

                // Count reads
                if(rd_en)
                    read_count <= read_count + 1'b1;

                window_counter <= window_counter + 1'b1;

            end

        end
    end

endmodule
