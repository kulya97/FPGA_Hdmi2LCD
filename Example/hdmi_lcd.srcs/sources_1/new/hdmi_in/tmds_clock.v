`timescale 1ns / 1ps
//****************************************Copyright (c)***********************************//
//原子哥在线教学平台：www.yuanzige.com
//抿术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com 
//关注微信公众平台微信号："正点原子"，免费获取ZYNQ & FPGA & STM32 & LINUX资料
//版权承有，盗版必究
//Copyright(C) 正点原子 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           tmds_clock
// Descriptions:        HDMI时钟模块
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2020/5/8 9:30:00
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module tmds_clock(

     input      tmds_clk_p,
     input      tmds_clk_n,


     output     pixelclk,
     output     serialclk,
     output     alocked     
    );

//wire define  
wire        clk_in_hdmi_clk;
wire        pixelclk;     
wire        serialclk; 
wire        alocked;
wire        clkout1b_unused, clkout2_unused, clkout2b_unused;
wire        clkout3_unused, clkout3b_unused, clkout4_unused;
wire        clkout5_unused, clkout6_unused,drdy_unused, psdone_unused;
wire        clkfbstopped_unused, clkinstopped_unused, clkfboutb_unused;
wire        clkout0b_unused, clkout1_unused ;
wire [15:0] do_unused;
wire        clkfbout_hdmi_clk;
wire        clk_out_5x_hdmi_clk;

//*****************************************************
//**                    main code
//***************************************************** 
  
  IBUFDS  # (
    .DIFF_TERM     ("FALSE"),
    .IBUF_LOW_PWR  ("TRUE"),
    .IOSTANDARD    ("TMDS_33")    
  ) u_IBUFDS(
    .O    (clk_in_hdmi_clk),
    .I    (tmds_clk_p),
    .IB   (tmds_clk_n)     
  ); 

     
  MMCME2_ADV                                                                 
  #(.BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT_F      (5.000),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (1.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKOUT1_DIVIDE       (5),
    .CLKOUT1_PHASE        (0.000),
    .CLKOUT1_DUTY_CYCLE   (0.500),
    .CLKOUT1_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (6.667))    
                                      
  mmcm_adv_inst                                                         
    // Output clocks                                                    
   (                                                                    
    .CLKFBOUT            (clkfbout_hdmi_clk),                           
    .CLKFBOUTB           (clkfboutb_unused),                            
    .CLKOUT0             (clk_out_5x_hdmi_clk),                         
    .CLKOUT0B            (clkout0b_unused),                             
    .CLKOUT1             (clk_out_1x_hdmi_clk),                              
    .CLKOUT1B            (clkout1b_unused),                             
    .CLKOUT2             (clkout2_unused),                              
    .CLKOUT2B            (clkout2b_unused),                             
    .CLKOUT3             (clkout3_unused),                              
    .CLKOUT3B            (clkout3b_unused),                             
    .CLKOUT4             (clkout4_unused),                              
    .CLKOUT5             (clkout5_unused),                              
    .CLKOUT6             (clkout6_unused),                              
     // Input clock control                                             
    .CLKFBIN             (clkfbout_hdmi_clk),                           
    .CLKIN1              (clk_in_hdmi_clk),                             
    .CLKIN2              (1'b0),                                        
     // Tied to always select the primary input clock                   
    .CLKINSEL            (1'b1),                                        
    // Ports for dynamic reconfiguration                                
    .DADDR               (7'h0),                                        
    .DCLK                (1'b0),                                        
    .DEN                 (1'b0),                                        
    .DI                  (16'h0),                                       
    .DO                  (do_unused),                                   
    .DRDY                (drdy_unused),                                 
    .DWE                 (1'b0),                                        
    // Ports for dynamic phase shift                                    
    .PSCLK               (1'b0),                                        
    .PSEN                (1'b0),                                        
    .PSINCDEC            (1'b0),                                        
    .PSDONE              (psdone_unused),                               
    // Other control and status signals                                 
    .LOCKED              (alocked),                                
    .CLKINSTOPPED        (clkinstopped_unused),                         
    .CLKFBSTOPPED        (clkfbstopped_unused),                         
    .PWRDWN              (1'b0),                                        
    .RST                 (0));                           
 
// 5x fast serial clock
BUFG u_BUFG(
      .O (serialclk), // 1-bit output: Clock output (connect to I/O clock loads).
      .I (clk_out_5x_hdmi_clk)  // 1-bit input: Clock input (connect to an IBUF or BUFMR).
   );   
   
BUFG u_BUFG_0(
      .O (pixelclk), // 1-bit output: Clock output (connect to I/O clock loads).
      .I (clk_out_1x_hdmi_clk)  // 1-bit input: Clock input (connect to an IBUF or BUFMR).
   );      
 
 
endmodule
