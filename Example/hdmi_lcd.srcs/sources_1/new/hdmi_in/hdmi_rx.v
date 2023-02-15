`timescale 1ns / 1ps
//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com 
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX����
//��Ȩ���У�����ؾ�
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           hdmi_rx
// Descriptions:        HDMI�����װ��ģ��
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2020/5/8 9:30:00
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module hdmi_rx(
  input  wire        clk_10m,          // 10Mʱ��     
  input  wire        clk_200m,         // 200M�ο�ʱ��                                  
  input  wire        tmdsclk_p,        // HDMI������ʱ��
  input  wire        tmdsclk_n,        // HDMI������ʱ��
  input  wire        blue_p,           // HDMI������ɫ�������
  input  wire        green_p,          // HDMI������ɫ�������
  input  wire        red_p,            // HDMI�����ɫ�������
  input  wire        blue_n,           // HDMI������ɫ�������
  input  wire        green_n,          // HDMI������ɫ�������
  input  wire        red_n,            // HDMI�����ɫ�������
  input  wire        rst_n,            // ��λ�źţ�����Ч
                                       
  output wire        reset,            // RX�˸�λ�ź�
  output wire        pclk,             // ���ص����ʱ��
  output wire        pclkx5,           // ���ص�5������ʱ��
  output wire        hsync,            // ���ź�
  output wire        vsync,            // ���ź�
  output wire        de,               // ����ʹ��
  output wire [23:0] rgb_data,         // ��������
  output wire        hdmi_in_en,       // �������ʹ���źţ�0�������룬1�������
  output reg         hdmi_in_hpd       // �Ȳ���ź�
    );
  
  
//wire define  
wire [7:0] red;         //��ɫ��������
wire [7:0] green;       //��ɫ��������
wire [7:0] blue;        //��ɫ��������
  
//*****************************************************
//**                    main code
//*****************************************************  

assign rgb_data = {red,green,blue};       
assign hdmi_in_en = 1'b0;

//�Ȳ���ź�
always@(posedge clk_10m or negedge rst_n)begin
    if( rst_n == 1'b0)
        hdmi_in_hpd <= 1'b0;
    else
        hdmi_in_hpd <= 1'b1;
end

//hdmi����ģ�� 
dvi_decoder u_dvi_decoder(
    //input
    .clk_200m      (clk_200m),
    .tmdsclk_p     (tmdsclk_p),      // tmds clock
    .tmdsclk_n     (tmdsclk_n),      // tmds clock
    .blue_p        (blue_p),         // Blue data in
    .green_p       (green_p),        // Green data in
    .red_p         (red_p    ),      // Red data in
    .blue_n        (blue_n   ),      // Blue data in
    .green_n       (green_n  ),      // Green data in
    .red_n         (red_n    ),      // Red data in
    .exrst_n       (rst_n),          // external reset input, e.g. reset button
    //output       
    .reset         (reset),          // rx reset
    .pclk          (pclk),           // double rate pixel clock
    .pclkx5        (pclkx5),         // 10x pixel as IOCLK
    .hsync         (hsync),          // hsync data
    .vsync         (vsync),          // vsync data
    .de            (de),             // data enable
    .red           (red),            // pixel data out
    .green         (green),          // pixel data out
    .blue          (blue)            // pixel data out 

  );    // pixel data out       
       
endmodule
