`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2026 19:51:09
// Design Name: 
// Module Name: fifo_core.v
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

module fifo_core #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   clk,
    input                   rst,

    input                   wr_en,
    input                   rd_en,

    input  [WIDTH-1:0]      data_in,
    output reg [WIDTH-1:0]  data_out,

    output                  full,
    output                  empty,

    output reg [4:0]        occupancy
);

    // Memory
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Pointers
    reg [3:0] wr_ptr;
    reg [3:0] rd_ptr;

    // Status flags
    assign full  = (occupancy == DEPTH);
    assign empty = (occupancy == 0);

    always @(posedge clk)
    begin
        if(rst)
        begin
            wr_ptr    <= 4'd0;
            rd_ptr    <= 4'd0;
            occupancy <= 5'd0;
            data_out  <= {WIDTH{1'b0}};
        end
        else
        begin

            // Write Operation
            if(wr_en && !full)
            begin
                mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1'b1;
            end

            // Read Operation
            if(rd_en && !empty)
            begin
                data_out <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1'b1;
            end

            // Occupancy Management
            case ({wr_en && !full, rd_en && !empty})

                2'b00:
                    occupancy <= occupancy;

                2'b10:
                    occupancy <= occupancy + 1'b1;

                2'b01:
                    occupancy <= occupancy - 1'b1;

                2'b11:
                    occupancy <= occupancy;

                default:
                    occupancy <= occupancy;

            endcase

        end
    end

endmodule
