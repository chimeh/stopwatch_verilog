`timescale 1ns / 1ps

module time_cnt(
   input ce, //计时计数器使能，高使能
   input clk_100hz, //计时计数器输入时钟，
   input clr, //计时计数器清零，异步，高有效
   output [3:0] lit_lsb, //百分之一秒bcd码
   output [3:0] lit_msb, //十分之一秒bcd码
   output [3:0] sec_lsb, //秒个位bcd码
   output [3:0] sec_msb, //
   output [3:0] min_lsb, //分个位bcd码
   output [3:0] min_msb);
   
  reg [3:0] lit_lsb_cnt;
  reg [3:0] lit_msb_cnt;
  reg [3:0] sec_lsb_cnt;
  reg [3:0] sec_msb_cnt;
  reg [3:0] min_lsb_cnt;
  reg [3:0] min_msb_cnt;
  
  wire up; //增计数，高为增，
  
  assign up = 1; //始终为增计数；程序没有指定为0的情况，up不能为0
  wire enable, tc_1up, tc_2up, tc_3up, tc_4up, tc_5up;
  wire tc_1dn, tc_2dn, tc_3dn, tc_4dn, tc_5dn; 
  
// assigning terminal counts
  assign tc_1up = (up && (lit_lsb_cnt == 4'd9));

  assign tc_2up = (up && (lit_msb_cnt == 4'd9));

  assign tc_3up = (up && (sec_lsb_cnt == 4'd9));

  assign tc_4up = (up && (sec_msb_cnt == 4'd5));

  assign tc_5up = (up && (min_lsb_cnt == 4'd9));
  
  assign tc_6up = (up && (min_msb_cnt == 4'd5));

  //每个位都计满了吗?没满且使能enable为1，可以继续计数
  assign enable = ~(tc_1up && tc_2up && tc_3up && tc_4up && tc_5up && tc_6up)&& ce; 

// change psedge to posedge
  always @(posedge clk_100hz or posedge clr)  // lit_lsb of seconds count
  begin
    if (clr)
      lit_lsb_cnt <= 0;
    else if (enable) 
       if (up)  // count up  
          if (lit_lsb_cnt == 4'd9)
                 lit_lsb_cnt <= 4'd0;
             else lit_lsb_cnt <= lit_lsb_cnt + 1;
  end //always 
  
  always @(posedge clk_100hz or posedge clr)  //lit_msb of seconds count
  begin
    if (clr)
      lit_msb_cnt <= 0;
    else if (enable)
       if (tc_1up)// count up and lit_lsb TC
          if (lit_msb_cnt == 4'd9)
                 lit_msb_cnt <= 4'd0;
             else lit_msb_cnt <= lit_msb_cnt + 1;

  end //always  

// change psedge to posedge
  always @(posedge clk_100hz or posedge clr)  // seconds count
  begin
    if (clr)
      sec_lsb_cnt <= 0;
    else if (enable)
       if (tc_1up && tc_2up) // lit_lsb and lit_msb TC up  
          if (sec_lsb_cnt == 4'd9)
                 sec_lsb_cnt <= 4'd0;
             else sec_lsb_cnt <= sec_lsb_cnt + 1;

  end //always  

  always @(posedge clk_100hz or posedge clr)  // tens of seconds count
  begin
    if (clr)
      sec_msb_cnt <= 0;
    else if (enable)
       if (tc_1up && tc_2up && tc_3up) // lit_lsb, lit_msb, and ones TC up  
          if (sec_msb_cnt == 4'd5)
                 sec_msb_cnt <= 4'd0;
             else sec_msb_cnt <= sec_msb_cnt + 1;

  end //always 
  
  always @(posedge clk_100hz or posedge clr)  // min_lsb count
  begin
    if (clr)
      min_lsb_cnt <= 0;
    else if (enable)
       if (tc_1up && tc_2up && tc_3up && tc_4up) // lit_lsb, lit_msb, ones, and tens TC up  
          if (min_lsb_cnt == 4'd9)
                 min_lsb_cnt <= 4'd0;
             else min_lsb_cnt <= min_lsb_cnt + 1;

  end //always 
  
  always @(posedge clk_100hz or posedge clr)  // tens of seconds count
  begin
    if (clr)
      min_msb_cnt <= 0;
    else if (enable)
       if (tc_1up && tc_2up && tc_3up && tc_4up && tc_5up) // lit_lsb, lit_msb,  ones  tens and mins TC up  
          if (min_msb_cnt == 4'd5)
                 min_msb_cnt <= 4'd0;
             else min_msb_cnt <= min_msb_cnt + 1;

  end //always 

  assign lit_lsb = lit_lsb_cnt;
  assign lit_msb = lit_msb_cnt;
  assign sec_lsb = sec_lsb_cnt;
  assign sec_msb = sec_msb_cnt; //{1'b0,sec_msb_cnt};
  assign min_lsb = min_lsb_cnt;
  assign min_msb = min_msb_cnt;

endmodule