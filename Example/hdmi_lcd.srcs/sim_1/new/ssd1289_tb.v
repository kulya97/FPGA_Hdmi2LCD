`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/15 00:50:11
// Design Name: 
// Module Name: ssd1289_tb
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


module ssd1289_tb;
  // SSD1289_Module Parameters
  parameter PERIOD = 10;
  parameter size_x = 16'd10;
  parameter size_y = 16'd2;

  // SSD1289_Module Inputs
  reg         pixel_clk = 0;
  reg         rst_n = 0;
  reg  [15:0] pixel_din = 16'h1234;
  reg         pixel_de = 0;
  reg         pixel_vsync = 0;
  reg         pixel_hsync = 0;
  reg         tft_clk = 0;

  // SSD1289_Module Outputs
  wire        bus_CS;
  wire        bus_DC;
  wire        bus_WR;
  wire        bus_RD;
  wire [15:0] bus_DATA;
  wire        bus_RST;
  wire        sys_init_done;
  wire        sys_plot_done;


  initial begin
    forever #(PERIOD / 2) pixel_clk = ~pixel_clk;
  end

  initial begin
    #(PERIOD * 2) rst_n = 1;
    wait (sys_init_done == 1'b1);
    /***************************/
    #(PERIOD * 2) pixel_vsync = 1;
    pixel_de    = 0;
    pixel_hsync = 0;
    #(PERIOD * 5) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    #(PERIOD * 5) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 1;
    #(PERIOD * 2) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    #(PERIOD * 20) pixel_vsync = 0;
    pixel_de    = 1;
    pixel_hsync = 0;
    #(PERIOD * 20) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    //
    #(PERIOD * 5) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 1;
    #(PERIOD * 2) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    #(PERIOD * 20) pixel_vsync = 0;
    pixel_de    = 1;
    pixel_hsync = 0;
    #(PERIOD * 10) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    //
    #(PERIOD * 5) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 1;
    #(PERIOD * 2) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    #(PERIOD * 20) pixel_vsync = 0;
    pixel_de    = 1;
    pixel_hsync = 0;
    #(PERIOD * 10) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    //
    #(PERIOD * 5) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 1;
    #(PERIOD * 2) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    #(PERIOD * 20) pixel_vsync = 0;
    pixel_de    = 1;
    pixel_hsync = 0;
    #(PERIOD * 10) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    /***************************/
    #(PERIOD * 2) pixel_vsync = 1;
    pixel_de    = 0;
    pixel_hsync = 0;
    #(PERIOD * 5) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    #(PERIOD * 5) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 1;
    #(PERIOD * 2) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    #(PERIOD * 20) pixel_vsync = 0;
    pixel_de    = 1;
    pixel_hsync = 0;
    #(PERIOD * 10) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    //
    #(PERIOD * 5) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 1;
    #(PERIOD * 2) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    #(PERIOD * 20) pixel_vsync = 0;
    pixel_de    = 1;
    pixel_hsync = 0;
    #(PERIOD * 10) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    //
    #(PERIOD * 5) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 1;
    #(PERIOD * 2) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    #(PERIOD * 20) pixel_vsync = 0;
    pixel_de    = 1;
    pixel_hsync = 0;
    #(PERIOD * 10) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    //
    #(PERIOD * 5) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 1;
    #(PERIOD * 2) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
    #(PERIOD * 20) pixel_vsync = 0;
    pixel_de    = 1;
    pixel_hsync = 0;
    #(PERIOD * 10) pixel_vsync = 0;
    pixel_de    = 0;
    pixel_hsync = 0;
  end


  SSD1289_Module #(
      .size_x(size_x),
      .size_y(size_y)
  ) u_SSD1289_Module (
      .pixel_clk  (pixel_clk),
      .rst_n      (rst_n),
      .pixel_din  (pixel_din[15:0]),
      .pixel_de   (pixel_de),
      .pixel_vsync(pixel_vsync),
      .pixel_hsync(pixel_hsync),

      .bus_CS       (bus_CS),
      .bus_DC       (bus_DC),
      .bus_WR       (bus_WR),
      .bus_RD       (bus_RD),
      .bus_DATA     (bus_DATA[15:0]),
      .bus_RST      (bus_RST),
      .sys_init_done(sys_init_done),
      .sys_plot_done(sys_plot_done)
  );


endmodule
