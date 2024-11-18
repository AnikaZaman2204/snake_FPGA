`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11/15/2024
// Design Name:     
// Module Name:    snake_vga_top.v
// Project Name:    snake_Gane
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
// Author: Anika Zaman Aleena Imran 
// Description: Port from NEXYS3 to NEXYS4
//////////////////////////////////////////////////////////////////////////////////
module vga_top(
    input ClkPort,
    input BtnC,  // Reset button
    input BtnU,  // Movement buttons

    // VGA signals
    output hSync, vSync,
    output [3:0] vgaR, vgaG, vgaB,

    // SSG signals
    output An0, An1, An2, An3, An4, An5, An6, An7,
    output Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,

    output MemOE, MemWR, RamCS, QuadSpiFlashCS
);

    wire bright;
    wire [9:0] hc, vc;
    wire [15:0] score;
    wire [6:0] ssdOut;
    wire [3:0] anode;
    wire [11:0] rgb;

    reg [9:0] snake_x [0:31]; // 32 segments..
    reg [9:0] snake_y [0:31];
    reg [9:0] food_x, food_y; // food placements...
    reg [4:0] snake_length;

    wire collision; // lol
    wire food_eaten; //

    // Display controller for VGA signals
    display_controller dc (
        .clk(ClkPort),
        .hSync(hSync),
        .vSync(vSync),
        .bright(bright),
        .hCount(hc),
        .vCount(vc)
    );

    // Snake game logic and VGA rendering
    vga_snake vs ( // check VGA
        .clk(ClkPort),
        .bright(bright),
        .hCount(hc),
        .vCount(vc),
        .button(BtnU),
        .snake_x(snake_x),
        .snake_y(snake_y),
        .food_x(food_x),
        .food_y(food_y),
        .snake_length(snake_length),
        .rgb(rgb),
        .collision(collision),
        .food_eaten(food_eaten)
    );

    // Snake movement logic
    snake_movement sm ( // ?
        .clk(ClkPort),
        .reset(BtnC),
        .direction(BtnU),
        .food_eaten(food_eaten),
        .collision(collision),
        .snake_x(snake_x),
        .snake_y(snake_y),
        .snake_length(snake_length)
    );

    // Food placement logic
    food_placement fp ( // logic skeleton 
        .clk(ClkPort),
        .reset(BtnC),
        .food_eaten(food_eaten),
        .snake_x(snake_x),
        .snake_y(snake_y),
        .snake_length(snake_length),
        .food_x(food_x),
        .food_y(food_y)
    );

    // Seven-segment display for score
    counter cnt (
        .clk(ClkPort),
        .displayNumber(score),
        .anode(anode),
        .ssdOut(ssdOut)
    );

    assign Dp = 1;
    assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg} = ssdOut[6:0];
    assign {An7, An6, An5, An4, An3, An2, An1, An0} = {4'b1111, anode};

    assign vgaR = rgb[11:8];
    assign vgaG = rgb[7:4];
    assign vgaB = rgb[3:0];

    // Disable memory ports
    assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;

endmodule

