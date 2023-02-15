`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/12 14:34:52
// Design Name: 
// Module Name: data_gen
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


module data_gen #(
    parameter site_x = 16'h0000,
    parameter site_y = 16'h0000,
    parameter size_x = 16'd240,
    parameter size_y = 16'd320
) (
    input             sys_clk,
    input             rst_n,
    /******************/
    output            app_de,         //fifo
    output            app_show_en,
    output reg [15:0] app_show_dout,
    input      [15:0] app_pos_x,
    input      [15:0] app_pos_y,
    /******************/
    input             sys_init_done,
    input             app_plot_done
);
//   localparam pxiel_cnt = size_x * size_y;
  localparam pxiel_cnt = 32'd76800;
  localparam Black = 16'h0000;
  localparam Red = 16'hF800;
  localparam Green = 16'h07E0;
  localparam Blue = 16'h001F;
  localparam White = 16'hFFFF;
  localparam Purple = 16'hF11F;
  localparam Yellow = 16'hFFE0;
  localparam Cyan = 16'h07FF;
  /*****************************************/
  //打拍使能信号
  wire sys_en;
  reg en_d0, en_d1;
  always @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) begin
      en_d0 <= 1'b0;
      en_d1 <= 1'b0;
    end else begin
      en_d0 <= app_plot_done;
      en_d1 <= en_d0;
    end
  end
  assign sys_en = en_d0 && !en_d1;
  /*****************************************/
  reg [3:0] S_STATE, S_STATE_NEXT;
  localparam S_IDLE = 0;  //
  localparam S_INIT = 1;  //
  localparam S_EN = 2;  //
  localparam S_WRITE = 3;  //
  localparam S_DONE = 4;
  /**************************/
  always @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) S_STATE <= S_IDLE;
    else S_STATE <= S_STATE_NEXT;
  end
  /**************************/
  reg [31:0] clk_cnt;
  always @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) clk_cnt <= 32'd0;
    else if (S_STATE == S_WRITE) clk_cnt <= clk_cnt + 1'd1;
    else clk_cnt <= 32'd0;
  end
  /**************************/
  always @(*) begin
    case (S_STATE)
      S_IDLE: begin
        if (sys_init_done) S_STATE_NEXT = S_INIT;
        else S_STATE_NEXT = S_IDLE;
      end
      S_INIT: begin
        S_STATE_NEXT = S_EN;
      end
      S_EN: begin
        if (sys_en) S_STATE_NEXT = S_WRITE;
        else S_STATE_NEXT = S_EN;
      end
      S_WRITE: begin
        if (clk_cnt == pxiel_cnt - 1) S_STATE_NEXT = S_DONE;
        else S_STATE_NEXT = S_WRITE;
      end
      S_DONE: begin
        S_STATE_NEXT = S_IDLE;
      end
      default: S_STATE_NEXT = S_IDLE;
    endcase
  end
  assign app_de      = (S_STATE != S_INIT);
  assign app_show_en = (S_STATE == S_WRITE);
  reg [7:0] color_cnt;
  always @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) begin
      color_cnt     <= 8'd0;
      app_show_dout <= Green;
    end else if (S_STATE == S_INIT) begin
      color_cnt <= color_cnt + 1'd1;
      case (color_cnt)
        8'd0:    app_show_dout <= Green;
        8'd1:    app_show_dout <= Red;
        8'd2:    app_show_dout <= Black;
        8'd3:    app_show_dout <= Blue;
        8'd4:    app_show_dout <= White;
        8'd5:    app_show_dout <= Purple;
        8'd6:    app_show_dout <= Yellow;
        8'd7: begin
          app_show_dout  <= Cyan;
          color_cnt <= 8'd0;
        end
        default: app_show_dout <= Green;
      endcase
    end else begin
      color_cnt     <= color_cnt;
      app_show_dout <= app_show_dout;
    end
  end
endmodule
