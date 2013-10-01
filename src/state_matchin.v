`timescale 100us / 1us

module statmath( input statmach_clock, //控制器输入时钟，
                 input  start_stop, //启动暂停按键,高有效
                 input spilt, //显示技术分离按键，高有效
                 output reg clr, //计时计数器清零，高清零
                 output reg Time_ce, //计时计数器使能，高使能
                 output reg enable_lc); //锁存器使能，低电平锁存

    localparam [1:0] reset =2'b00, stop =2'b01, normal=2'b10, lock=2'b11;
    
    reg [1:0] p_state; //记住当前状态
    reg [1:0] n_state = reset; //下一状态逻辑
    
    always @ ( start_stop or  spilt or p_state ) begin  //下一状态逻辑
        case(p_state)
            reset:
                case({start_stop,spilt})
                2'b10:n_state <= normal;
                default: n_state <= n_state;
                 endcase
            
            stop:
                case({start_stop,spilt})
                2'b01:n_state <= reset;
                2'b10:n_state <= normal;
                default: n_state <= n_state;
                endcase
                
            normal:
                case({start_stop,spilt})
                2'b01:n_state <= lock;
                2'b10:n_state <= stop;
                default: n_state <= n_state;
                endcase
                
            lock:
                case({start_stop,spilt})
                2'b01:n_state <= normal;
                default: n_state <= n_state;
                endcase
                
            default: n_state <= reset;             
        endcase 
    end
    
    always @ (posedge statmach_clock) begin  //每个时钟上升沿更新当前状状态
        p_state <= n_state;
    end
    
    always@( p_state)   //输出逻辑
         case(p_state)  
               reset: begin
                   clr=1;
                   Time_ce=0;
                   enable_lc=1;
                   end
               stop: begin
                   clr=0;
                   Time_ce=0;
                   enable_lc=1;
                   end
               normal: begin
                   clr=0;
                   Time_ce=1;
                   enable_lc=1;
                   end
               lock: begin
                   clr=0;
                   Time_ce=1;
                   enable_lc=0;
                   end 
           endcase 
endmodule
