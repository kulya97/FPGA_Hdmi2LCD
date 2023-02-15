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
// File name:           dvi_decoder
// Descriptions:        HDMI����ģ��
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2020/5/8 9:30:00
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module dvi_decoder (
  input  wire clk_200m, 
  input  wire tmdsclk_p,      // tmds clock
  input  wire tmdsclk_n,      // tmds clock
  input  wire blue_p,         // Blue data in
  input  wire green_p,        // Green data in
  input  wire red_p,          // Red data in
  input  wire blue_n,         // Blue data in
  input  wire green_n,        // Green data in
  input  wire red_n,          // Red data in
  input  wire exrst_n,        // external reset input, e.g. reset button

  output reg  reset,          // rx reset
  output wire pclk,           // regenerated pixel clock
  output wire pclkx5,         // 5x pixel as IOCLK  
  output wire hsync,          // hsync data
  output wire vsync,          // vsync data
  output wire de,             // data enable  
  output wire [7:0] red,      // pixel data out
  output wire [7:0] green,    // pixel data out
  output wire [7:0] blue      // pixel data out  
  
  );    

//parameter define    
parameter kCtlTknCount = 128; //��⵽�����ַ�����ͳ�������
parameter kTimeoutMs = 50;    //δ��⵽�����ַ������ʱ����

//wire define       
wire de_b, de_g, de_r;
wire blue_rdy, green_rdy, red_rdy;  //����׼�����ź�
wire blue_vld, green_vld, red_vld;  //������Ч�ź�

//*****************************************************
//**                    main code
//*****************************************************  

assign de = de_b;

//RX�˵ĸ�λ�ź�
always @(posedge pclk ) begin
    if (!exrst_n )
        reset <= 1'b1;
    else         
        reset <= ~pll_lckd;       
end

//HDMIʱ��ģ��
 tmds_clock u_tmds_clock(

     .tmds_clk_p (tmdsclk_p),
     .tmds_clk_n (tmdsclk_n),

     .pixelclk   (pclk),
     .serialclk  (pclkx5),
     .alocked    (pll_lckd) 
    );
 
//HDMI��ɫ���ݽ���ģ�� 
tmds_decoder #(
  .kCtlTknCount (kCtlTknCount),  //��⵽�����ַ�����ͳ�������
  .kTimeoutMs (kTimeoutMs),      //δ��⵽�����ַ������ʱ����
  .kRefClkFrqMHz (200)           //�ο�ʱ��Ƶ��
) u_tmds_decoder_0(

    .arst           (reset),
    .pixelclk       (pclk),
    .serialclk      (pclkx5),
    .refclk         (clk_200m),
    .prst           (~exrst_n),
    .sdatain_p      (red_p),
    .sdatain_n      (red_n),    
    .potherchrdy    ({blue_rdy,green_rdy}), 
    .potherchvld    ({blue_vld,green_vld}),    
    .palignerr      (),
    .pc0            (),
    .pc1            (),    
    .pmerdy         (red_rdy),
    .pmevld         (red_vld),   
    .pvde           (de_r),
    .pdatain        (red),       
    .peyesize       ()    
);

//HDMI��ɫ���ݽ���ģ�� 
tmds_decoder #(
  .kCtlTknCount (kCtlTknCount),  //��⵽�����ַ�����ͳ�������
  .kTimeoutMs (kTimeoutMs),      //δ��⵽�����ַ������ʱ����
  .kRefClkFrqMHz (200)           //�ο�ʱ��Ƶ��
) u_tmds_decoder_1(

    .arst           (reset),
    .pixelclk       (pclk),
    .serialclk      (pclkx5),
    .refclk         (clk_200m),
    .prst           (~exrst_n),
    .sdatain_p      (blue_p),
    .sdatain_n      (blue_n),    
    .potherchrdy    ({red_rdy,green_rdy}),
    .potherchvld    ({red_vld,green_vld}),    
    .palignerr      (),
    .pc0            (hsync),
    .pc1            (vsync),    
    .pmerdy         (blue_rdy),
    .pmevld         (blue_vld),   
    .pvde           (de_b),
    .pdatain        (blue),        
    .peyesize       ()    
);

//HDMI��ɫ���ݽ���ģ�� 
tmds_decoder #(
  .kCtlTknCount (kCtlTknCount),     //��⵽�����ַ�����ͳ�������
  .kTimeoutMs (kTimeoutMs),         //δ��⵽�����ַ������ʱ����
  .kRefClkFrqMHz (200)              //�ο�ʱ��Ƶ��
) u_tmds_decoder_2(

    .arst           (reset),
    .pixelclk       (pclk),
    .serialclk      (pclkx5),
    .refclk         (clk_200m),
    .prst           (~exrst_n),
    .sdatain_p      (green_p),
    .sdatain_n      (green_n),    
    .potherchrdy    ({red_rdy,blue_rdy}),
    .potherchvld    ({red_vld,blue_vld}),    
    .palignerr      (),
    .pc0            (),
    .pc1            (),    
    .pmerdy         (green_rdy),
    .pmevld         (green_vld),   
    .pvde           (de_g),
    .pdatain        (green),       
    .peyesize       ()    
);

endmodule
