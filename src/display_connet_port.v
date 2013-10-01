`timescale 1ns / 1ps



module display_connet_port(
    input scancnt_reset, //异步复位，高有效
    input clk_scan, //数码管扫描时钟
    input [3:0] in_bcd_7,
    input [3:0] in_bcd_6,
    input [3:0] in_bcd_5,
    input [3:0] in_bcd_4,
    input [3:0] in_bcd_3,
    input [3:0] in_bcd_2,
    input [3:0] in_bcd_1,
    input [3:0] in_bcd_0,
    output [7:0]display_dig_sel, //低有效，低电平的位选中对应数码管
    output [7:0] seg7cod_out); //七段码，低有效，低电平对应的段亮
     
     wire [2:0] discntnum_out;
     wire [3:0] bcd_out;
     
     
     

     //例化扫描计数器，异步上升沿复位
     display_cnt_3bit display_cnt_3bit_instan(reset(scancnt_reset),
                                           .display_clk(clk_scan),
                                        .display_cnt_3bit_num(discntnum_out));
                                                
     //例化38译码器，输出低有效
     decod38 decod38_instan(.decod_38_in(discntnum_out),
                            .decod_38_out(display_dig_sel));
     
     //
     mux_8path_4b mux_instan(
                    .mux_sel(discntnum_out),
                    .mux_in7(in_bcd_7),
                    .mux_in6(in_bcd_6),
                    .mux_in5(in_bcd_5),
                    .mux_in4(in_bcd_4),
                    .mux_in3(in_bcd_3),
                    .mux_in2(in_bcd_2),
                    .mux_in1(in_bcd_1),
                    .mux_in0(in_bcd_0),
                    .mux_out(bcd_out));
    
    SEG7_LUT   seg7_instan(.iBCD_(bcd_out),    .oSEG_(seg7cod_out)); //例化7段显示译码器
endmodule

