`timescale 1ns/1ns
module stopwatch(
                  input clock_origin, //输入输入时钟:50Mhz
                  input start_stop, //启动暂停键，低电平有效
                  input spilt, //显示计数分离按键，低电平有效
                  output [7:0] display_dig_sel, //输出数码管扫描选择按键，低有效
                  output [7:0] seg7cod_out); //数码管显示码，低电平的段亮
    
    wire clk_1khz;
    wire clk_100hz;
    
    wire start_stop_aftdb;
    wire spilt_aftdb;
    wire clr;
    wire Time_ce;
    wire enable_lc;
    
    wire [3:0] lc_in7;
    wire [3:0] lc_in6;
    wire [3:0] lc_in5;
    wire [3:0] lc_in4;
    wire [3:0] lc_in3;
    wire [3:0] lc_in2;
    wire [3:0] lc_in1;
    wire [3:0] lc_in0;
    
    wire [3:0] lc_out7;
    wire [3:0] lc_out6;
    wire [3:0] lc_out5;
    wire [3:0] lc_out4;
    wire [3:0] lc_out3;
    wire [3:0] lc_out2;
    wire [3:0] lc_out1;
    wire [3:0] lc_out0;
    
    
    assign lc_in5 = 4'hf; //数码管5显示-，起到分隔作用
    assign lc_in2 = 4'hf; //数码管2显示-
    
    clock_get_all clk_md( .clk_origin(clock_origin),
                   .clkcnt_reset(1), //异步复位低有效,强制一直失效
                   .out_clk_1khz(clk_1khz),
                   .out_clk_100hz(clk_100hz));
                   
     debounce start_stop_db(.sig_in(start_stop), //低按下
                .clk_1khz(clk_1khz),
                .sig_out_n(start_stop_aftdb));
     debounce spilt_db(.sig_in(spilt), //低按下
                .clk_1khz(clk_1khz),
                .sig_out_n(spilt_aftdb));     
                   
    statmath statmachine_md(.statmach_clock(clk_1khz), //控制器输入时钟，
                            .start_stop(start_stop_aftdb), //启动暂停按键
                            .spilt(spilt_aftdb), //显示技术分离按键
                            .clr(clr), //计时计数器清零，高清零
                            .Time_ce(Time_ce), //计时计数器使能，高使能
                            .enable_lc(enable_lc)); //锁存器使能，低电平锁存
                 
    time_cnt timer_md(
                      .ce(Time_ce), //计时计数器使能，高使能
                      .clk_100hz(clk_100hz), //计时计数器输入时钟，
                      .clr(clr), //计时计数器清零，异步，高有效
                      .lit_lsb(lc_in0), //百分之一秒bcd码
                      .lit_msb(lc_in1), //十分之一秒bcd码
                      .sec_lsb(lc_in3), //秒个位bcd码
                      .sec_msb(lc_in4), //
                      .min_lsb(lc_in6), //分个位bcd码
                      .min_msb(lc_in7));
    
    
     latch_8path_4b latch_md(
                              .lc_in7(lc_in7),
                              .lc_in6(lc_in6),
                              .lc_in5(lc_in5),
                              .lc_in4(lc_in4),
                              .lc_in3(lc_in3),
                              .lc_in2(lc_in2),
                              .lc_in1(lc_in1),
                              .lc_in0(lc_in0),
                              .enable_lc(enable_lc), //低电平锁存，高电平直通
                              .lc_out7(lc_out7),
                              .lc_out6(lc_out6),
                              .lc_out5(lc_out5),
                              .lc_out4(lc_out4),
                              .lc_out3(lc_out3),
                              .lc_out2(lc_out2),
                              .lc_out1(lc_out1),
                              .lc_out0(lc_out0));
                   
      display_connet_port display_md (
     .scancnt_reset(0), //异步复位，高有效,此处拉底失效
     .clk_scan(clk_1khz), //数码管扫描时钟
     .in_bcd_7(lc_out7),
     .in_bcd_6(lc_out6),
     .in_bcd_5(lc_out5),
     .in_bcd_4(lc_out4),
     .in_bcd_3(lc_out3),
     .in_bcd_2(lc_out2),
     .in_bcd_1(lc_out1),
     .in_bcd_0(lc_out0),
     .display_dig_sel(display_dig_sel), //低有效，低电平的位选中对应数码管
     .seg7cod_out(seg7cod_out)); //七段码，低有效，低电平对应的段亮
     
endmodule
 
    