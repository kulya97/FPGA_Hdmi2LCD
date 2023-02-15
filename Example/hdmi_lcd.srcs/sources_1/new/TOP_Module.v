`timescale 1ns / 1ps
//****************************************************************************************//
module TOP_Module (
    input         sys_clk,          //50Mϵͳʱ��
    input         rst_n,            //ϵͳ��λ������Ч
    //hdmi in
    input         hdmi_ddc_scl_io,  //IICʱ��
    inout         hdmi_ddc_sda_io,  //IIC����
    output        hdmi_in_hpd,      //�Ȳ���ź�
    output [ 0:0] hdmi_in_oen,      //��������л��ź� 
    input         clk_hdmi_in_n,    //������ʱ��
    input         clk_hdmi_in_p,    //������ʱ��
    input  [ 2:0] data_hdmi_in_n,   //����������
    input  [ 2:0] data_hdmi_in_p,   //����������
    //hdmi out
    output [ 0:0] hdmi_out_oen,     //��������л��ź� 
    output        clk_hdmi_out_n,   //������ʱ��
    output        clk_hdmi_out_p,   //������ʱ��
    output [ 2:0] data_hdmi_out_n,  //����������
    output [ 2:0] data_hdmi_out_p,  //����������
    /***********************************/
    output        bus_CS,
    output        bus_DC,
    output        bus_WR,
    output        bus_RD,
    output [15:0] bus_DATA,
    output        bus_RST
);
  parameter size_x = 16'd320;
  parameter size_y = 16'd240;

  //wire define
  wire        clk_10m;  //10mʱ��
  wire        clk_200m;  //200mʱ��
  wire        clk_600m;  //200mʱ��
  wire        rx_rst;  //��λ�źţ�����Ч
  wire        pixel_clk;  //����ʱ��
  wire        pixel_clk_5x;  //5������ʱ��
  wire        video_hs;  //���ź�
  wire        video_vs;  //���ź�
  wire        video_de;  //������Чʹ��

  wire [23:0] video_rgb;  //��������

  /*****************************************************/
  wire        lcd_clk;

  //ʱ��ģ��
  mmcm u_mmcm (
      .clk_out1(clk_10m),   // output clk_out1
      .clk_out2(clk_200m),  // output clk_out1
      .clk_out3(lcd_clk),
      .clk_out4(clk_600m),
      .locked  (),          // output locked
      .clk_in1 (sys_clk)    // input clk_in1
  );
  /*****************************************************/

  wire [15:0] video_show_dout;
  wire sys_init_done, sys_plot_done;
  assign video_show_dout = {video_rgb[23:19], video_rgb[15:10], video_rgb[7:3]};
  wire [127:0] show_dout;
  wire         fifo_valid;
  /*****************************************************/
  wire         hsync;
  reg hsync_d0, hsync_d1;
  always @(posedge pixel_clk, negedge rst_n) begin
    if (!rst_n) begin
      hsync_d0 <= 1'b0;
      hsync_d1 <= 1'b0;
    end else begin
      hsync_d0 <= video_de;
      hsync_d1 <= hsync_d0;
    end
  end
  assign hsync = !hsync_d0 && hsync_d1;
  reg [15:0] pixel_h_cnt;
  always @(posedge pixel_clk, negedge rst_n) begin
    if (!rst_n) pixel_h_cnt <= 8'b0;
    else if (video_vs) pixel_h_cnt <= 8'b0;
    else if (pixel_h_cnt == 8'd6 && hsync) pixel_h_cnt <= 8'b0;
    else if (hsync) pixel_h_cnt <= pixel_h_cnt + 1'd1;
    else pixel_h_cnt <= pixel_h_cnt;
  end
  reg pixel_hsync, pixel_de;
  always @(posedge pixel_clk, negedge rst_n) begin
    if (!rst_n) begin
      pixel_hsync <= 1'b0;
      pixel_de    <= 1'b0;
    end else if (pixel_h_cnt == 8'd3) begin
      pixel_hsync <= video_hs;
      pixel_de    <= video_de;
    end else begin
      pixel_hsync <= 1'b0;
      pixel_de    <= 1'b0;
    end
  end
  reg fifo_rst;
  always @(posedge pixel_clk, negedge rst_n) begin
    if (!rst_n) fifo_rst <= 1'b0;
    else if (pixel_h_cnt == 8'd2) fifo_rst <= video_hs;
    else fifo_rst <= 1'b0;

  end
  reg        clk;
  reg [15:0] clk_cnt;
  always @(posedge lcd_clk, negedge rst_n) begin
    if (!rst_n) clk_cnt <= 8'b0;
    else if (pixel_h_cnt == 8'd2) clk_cnt <= 8'b0;
    else clk_cnt <= clk_cnt + 1'd1;
  end
  always @(posedge lcd_clk, negedge rst_n) begin
    if (!rst_n) clk <= 1'b0;
    else if (pixel_h_cnt == 8'd1) clk <= !clk;
    else clk <= clk;
  end
  SSD1289_Module #(
      .size_x(size_x),
      .size_y(size_y)
  ) u_SSD1289_Module (
      .pixel_clk  (lcd_clk),
      .rst_n      (rst_n),
      .pixel_de   (fifo_valid),
      .pixel_vsync(video_vs),
      .pixel_hsync(pixel_hsync),
      .pixel_din  (show_dout[15:0]),

      .bus_CS       (bus_CS),
      .bus_DC       (bus_DC),
      .bus_WR       (bus_WR),
      .bus_RD       (bus_RD),
      .bus_DATA     (bus_DATA[15:0]),
      .bus_RST      (bus_RST),
      .sys_init_done(sys_init_done),
      .sys_plot_done(sys_plot_done)
  );

  ila_0 ila_0 (
      .clk   (clk_600m),       // input wire clk
      .probe0(pixel_clk),      // input wire [0:0]  probe0  
      .probe1(video_hs),       // input wire [0:0]  probe1 
      .probe2(video_vs),       // input wire [0:0]  probe2 
      .probe3(video_de),       // input wire [0:0]  probe3 
      .probe4(sys_init_done),  // input wire [0:0]  probe4 
      .probe5(sys_plot_done),  // input wire [0:0]  probe5
      .probe6(pixel_hsync),
      .probe7(pixel_de)
  );


  /*****************************************************/
  fifo_generator_0 fifo_generator_0 (
      .wr_clk(pixel_clk),        // input wire wr_clk
      .rd_clk(lcd_clk),          // input wire rd_clk
      .rst   (video_vs),
      .din   (video_show_dout),  // input wire [15 : 0] din
      .wr_en (pixel_de),         // input wire wr_en
      .rd_en (fifo_valid),       // input wire rd_en
      .dout  (show_dout),        // output wire [15 : 0] dout
      .valid (fifo_valid)        // output wire valid
  );

  reg [15:0] data_cnt;
  always @(posedge pixel_clk, negedge rst_n) begin
    if (!rst_n) data_cnt <= 1'd0;
    else if (video_de) data_cnt <= data_cnt + 1'd1;
    else data_cnt <= 1'd0;
  end
  //��edidģ��    
  i2c_edid u_i2c_edid (
      .clk(clk_10m),
      .rst(~rst_n),
      .scl(hdmi_ddc_scl_io),
      .sda(hdmi_ddc_sda_io)
  );

  //hdmi����ģ��    
  hdmi_rx u_hdmi_rx (
      .clk_10m    (clk_10m),
      .clk_200m   (clk_200m),
      //input
      .tmdsclk_p  (clk_hdmi_in_p),
      .tmdsclk_n  (clk_hdmi_in_n),
      .blue_p     (data_hdmi_in_p[0]),
      .green_p    (data_hdmi_in_p[1]),
      .red_p      (data_hdmi_in_p[2]),
      .blue_n     (data_hdmi_in_n[0]),
      .green_n    (data_hdmi_in_n[1]),
      .red_n      (data_hdmi_in_n[2]),
      .rst_n      (rst_n),
      //output       
      .reset      (rx_rst),
      .pclk       (pixel_clk),
      .pclkx5     (pixel_clk_5x),
      .hsync      (video_hs),
      .vsync      (video_vs),
      .de         (video_de),
      .rgb_data   (video_rgb),
      .hdmi_in_en (hdmi_in_oen),
      .hdmi_in_hpd(hdmi_in_hpd)
  );

  // HDMI�����װ��ģ��      
  dvi_transmitter_top u_rgb2dvi_0 (
      .pclk   (pixel_clk),
      .pclk_x5(pixel_clk_5x),
      .reset_n(~rx_rst),

      .video_din  (video_rgb),
      .video_hsync(video_hs),
      .video_vsync(video_vs),
      .video_de   (video_de),

      .tmds_clk_p (clk_hdmi_out_p),
      .tmds_clk_n (clk_hdmi_out_n),
      .tmds_data_p(data_hdmi_out_p),
      .tmds_data_n(data_hdmi_out_n),
      .tmds_oen   (hdmi_out_oen)
  );
endmodule
