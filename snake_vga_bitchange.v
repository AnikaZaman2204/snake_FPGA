`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:15:38 12/14/2017 
// Design Name: 
// Module Name:    vgaBitChange 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
// Date: 04/04/2020
// Author: Yue (Julien) Niu
// Description: Port from NEXYS3 to NEXYS4
//////////////////////////////////////////////////////////////////////////////////
module vga_bitchange(
    input clk,
    input bright,
    input button,
    input [9:0] hCount, vCount,
    output reg [11:0] rgb,
    output reg [15:0] score
);

    // Define colors
    parameter BLACK = 12'b0000_0000_0000; // Grid color
    parameter RED   = 12'b1111_0000_0000; // Apple color
    parameter BLUE  = 12'b0000_0000_1111; // Snake color

    // Snake and food positions
    reg [9:0] snake_x [0:31];
    reg [9:0] snake_y [0:31];
    reg [9:0] food_x, food_y;
    reg [4:0] snake_length;
    integer i;

    // Grid logic
    wire is_grid_line;
    assign is_grid_line = ((hCount % 10 == 0) || (vCount % 10 == 0)) ? 1 : 0;

    // Object flags
    wire is_snake, is_food;

    assign is_snake = (
        (hCount >= snake_x[0] && hCount < snake_x[0] + 10) &&
        (vCount >= snake_y[0] && vCount < snake_y[0] + 10)
    );

    assign is_food = (
        (hCount >= food_x && hCount < food_x + 10) &&
        (vCount >= food_y && vCount < food_y + 10)
    );

    // Initialization
    initial begin
        snake_x[0] = 10'd320; // Initial snake position
        snake_y[0] = 10'd240;
        food_x = 10'd160;     // Initial food position
        food_y = 10'd120;
        snake_length = 1;     // Start with 1 segment
        score = 0;
    end


    always @(*) begin   // RGB Logic: Determine color based on object type
        if (~bright) begin
            rgb = BLACK; // Outside visible area
        end else if (is_snake) begin
            rgb = BLUE; // Snake body
        end else if (is_food) begin
            rgb = RED; // Food (apple)
        end else if (is_grid_line) begin
            rgb = BLACK; // Grid (use BLACK to let snake and apple stand out)
        end else begin
            rgb = BLACK; // Default background
        end
    end

    // Snake movement logic // fix 
    always @(posedge clk) begin
        if (button) begin
            // Shift body positions
            for (i = snake_length - 1; i > 0; i = i - 1) begin
                snake_x[i] <= snake_x[i - 1];
                snake_y[i] <= snake_y[i - 1];
            end

            // Update head position (example: move right)
            snake_x[0] <= snake_x[0] + 10; // Replace with directional control
        end

        // Collision with food
        if (snake_x[0] == food_x && snake_y[0] == food_y) begin
            score <= score + 1;
            snake_length <= snake_length + 1; //??

            // Generate new food position 
			///
        end
    end

endmodule

