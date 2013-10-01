`timescale 100us/1us

//消抖电路
module debounce (input sig_in, //按键低表示按下
                 input clk_1khz,
                 output  sig_out_n);//消抖后且正负逻辑转换后按键高表示按下

reg [7:0] register;
reg sig_out;
//reg: wait for stable
always @ (posedge clk_1khz) begin
    register <= {register[6:0],sig_in}; //shift register
    if(register[7:0] == 8'b00000000)
        sig_out <= 1'b0;
    else if(register[7:0] == 8'b11111111)
        sig_out <= 1'b1;
    else sig_out <= sig_out;
    end
    
assign sig_out_n = ~sig_out;
endmodule
