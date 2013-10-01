`timescale 1ns / 1ps



module clock_get_all(input clk_origin, //需输入50MHz时钟，
                   input clkcnt_reset, //异步复位，低有效用于仿真
                    output out_clk_1khz, //对输入50k分频后输出时钟
                   output out_clk_100hz); //对输入时钟500k分频后输出
    
    wire clk_1ms; //千分之一秒
    wire clk_1cs; //百分之一秒
    
    assign out_clk_1khz = clk_1ms;
    assign out_clk_100hz = clk_1cs;
    
     clock_div_50k instan_div_50k (.clk(clk_origin),
                                   .clkcnt_reset(clkcnt_reset),
                                   .div_50k(clk_1ms)); //得毫秒时钟
     
     clock_div_500k instan_div_500k(.clk(clk_origin),
                                    .clkcnt_reset(clkcnt_reset),
                                    .div_500k(clk_1cs)); //得百分之一秒时钟
     
endmodule


//50k分频器，异步复位低有效
module clock_div_50k(clk, clkcnt_reset,  div_50k);
     input clk;
     input clkcnt_reset;
    output div_50k;
     
      reg div_50k;
     reg [19:0] cnt;

  always @(negedge clkcnt_reset or posedge clk)begin
  if(~clkcnt_reset) cnt <= 0;
  else if (cnt >= 50000) begin
          div_50k <= 0;
          cnt <= 0; end
      else if (cnt < 25000) begin
          div_50k <= 0;
          cnt <= cnt + 1; end
      else if ((cnt >= 25000) && (cnt < 50000)) begin   
            div_50k <= 1;
            cnt <= cnt + 1; end
  end // always 
endmodule


//500k分频器，异步复位低电平有效
module clock_div_500k(clk, clkcnt_reset,  div_500k);
     input clk;
     input clkcnt_reset;     
    output div_500k;
     
      reg div_500k;
     reg [19:0] cnt;

  always @(negedge clkcnt_reset or posedge clk)begin
  if(~clkcnt_reset) cnt <= 0;
  else if (cnt >= 500000) begin
          div_500k <= 0;
          cnt <= 0; end
      else if (cnt < 250000) begin
          div_500k <= 0;
          cnt <= cnt + 1; end
      else if ((cnt >= 250000) && (cnt < 500000)) begin 
            div_500k <= 1;
            cnt <= cnt + 1; end
  end // always 
endmodule


