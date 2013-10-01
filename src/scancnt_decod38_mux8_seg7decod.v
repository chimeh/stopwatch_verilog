`timescale 1ns / 1ps


//扫描计数器，异步复位高有效
module display_cnt_3bit(input reset, input display_clk,
                        output  reg [2:0] display_cnt_3bit_num);
    always @(  posedge reset or posedge display_clk) begin
        if ( reset) display_cnt_3bit_num <= 0;
        else  display_cnt_3bit_num <= display_cnt_3bit_num + 1;
    end 
endmodule 


//38译码器，输出低有效，如000译码为11111110
module decod38 (input [2:0] decod_38_in,
                output reg [7:0] decod_38_out); //译码输出低有效
 
    always @(decod_38_in ) begin
        case(decod_38_in)
        3'd0: decod_38_out = ~8'h01;
        3'd1: decod_38_out = ~8'h02;
        3'd2: decod_38_out = ~8'h04;
        3'd3: decod_38_out = ~8'h08;
        3'd4: decod_38_out = ~8'h10;
        3'd5: decod_38_out = ~8'h20;
        3'd6: decod_38_out = ~8'h40;
        3'd7: decod_38_out = ~8'h80;
        default: decod_38_out = ~8'h00;
        endcase 
    end
endmodule



//多路复用器，8路，4位宽
module mux_8path_4b(
            input [2:0] mux_sel, //多路复用器选择信号，111选择mux_in7
            input [3:0] mux_in7,
            input [3:0] mux_in6,
            input [3:0] mux_in5,
            input [3:0] mux_in4,
            input [3:0] mux_in3,
            input [3:0] mux_in2,
            input [3:0] mux_in1,
            input [3:0] mux_in0,
            output reg [3:0] mux_out); 
                

        always @(mux_sel or mux_in7 or
                    mux_in6 or mux_in5 or
                    mux_in4 or mux_in3 or
                    mux_in2 or mux_in1 or mux_in0) 
         begin
            mux_out = 4'd0;
            case(mux_sel)
                3'd0: mux_out = mux_in0;
                3'd1: mux_out = mux_in1;
                3'd2: mux_out = mux_in2;
                3'd3: mux_out = mux_in3;
                3'd4: mux_out = mux_in4;
                3'd5: mux_out = mux_in5;
                3'd6: mux_out = mux_in6;
                3'd7: mux_out = mux_in7;
                default: mux_out = 4'h0;
            endcase
         end 
endmodule 


//七段译码，将bcd转为显示码，低有效，低电平对应的段亮
module SEG7_LUT (iBCD_, oSEG_);

input   [3:0]   iBCD_;
output  [7:0]   oSEG_; //低有效
reg     [7:0]   oSEG_;

always @(iBCD_)  //
begin
        case(iBCD_)
        0:oSEG_=8'hc0;
        1:oSEG_=8'hf9;
        2:oSEG_=8'ha4;
        3:oSEG_=8'hb0;
        4:oSEG_=8'h99;
        5:oSEG_=8'h92;
        6:oSEG_=8'h82;
        7:oSEG_=8'hf8;
        8:oSEG_=8'h80;
        9:oSEG_=8'h90;
        10:oSEG_=8'h88;
        11:oSEG_=8'h83;
        12:oSEG_=8'hc6;
        13:oSEG_=8'ha1;
        14:oSEG_=8'h86;
        //15:oSEG_=8'h8e;
        15:oSEG_=8'hbf;
        default:oSEG_=8'h00;
        endcase
end
endmodule

