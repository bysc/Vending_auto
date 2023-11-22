module STM
#(localparam S0 =5'b00001,S1=5'b00010,S2=5'b00100,S3=5'b01000,S4=5'b10000)(
    input clk1k,clr,
    input [3:0] key,
    output reg [23:0] seg
);
reg[4:0] state;
reg[3:0] money_input;
reg[3:0] price[3:0];
reg[3:0] numbers[3:0];
/*===========================================*/
/*初始化模块*/
/*===========================================*/
initial begin
price[0]=4'd5;
price[1]=4'd6;
price[2]=4'd7;
price[3]=4'd8;
numbers[0]=4'd9;
numbers[1]=4'd9;
numbers[2]=4'd9;
numbers[3]=4'd1;
state<=S0;
end
reg[1:0] choice;
reg[2:0] index;
/*===========================================*/
/*=状态转移=*/
/*===========================================*/
always @(posedge clk1k,negedge clr) begin
    if(!clr) begin
        state<=S0; end
    else case(state)
    S0: begin
        if(key) begin
        if(key[0]) choice<=1'd0;
        else if(key[1]) choice<=2'd1;
        else if(key[2]) choice<=2'd2;
        else choice<=2'd3;
        if(numbers[choice])
            begin 
            state<=S1;
            money_input<=0;
            end
        else state<=S0;
        end
    end
    S1: begin
        if(key) begin
            
        if(key[0]) money_input<=money_input+1;
        else if(key[1]) money_input<=money_input+5;
		  else if(key[2]) money_input<=money_input+10;//超出F部分不进行数字显示
        else if(key[3]) state<=S4;//3——退钱
        else state<=S1;
        end
        if(money_input>=price[choice]) state<=S2;//钱够自动跳转
    end
    S2: begin
        if(key[0]) begin 
		  state<=S3;//0——出货
		  end
        else if(key[3]) state<=S4;//3——全额退
        else state<=S2;//12不动
    end
    S3: begin
	     if(key) begin //任意键回到S0
        numbers[choice]=numbers[choice]-1;
        state<=S0;end
		  else state<=S3;
    end
	 S4: begin//退钱
	     if(key) state<=S0;
		  else state<=S4;
		  end
	 default:state<=S0;
    endcase
    end
/*===========================================*/
/*输出部分*/
/*===========================================*/
always @(posedge clk1k,negedge clr) begin
    if(!clr) seg<=24'b0;
    else case(state)
    S0: for(index=3'b0;index<=3'b011;index=index+1'b1) begin
        if(numbers[index]) seg[index*4+:4]<=price[index];
        else seg[index*4+:4]<=0;
        seg[23:16]<=0;
    end
    S1: begin
        seg[3:0]<=numbers[choice];
        seg[7:4]<=price[choice];
        seg[23:8]<=money_input;
    end
    S2:
	 begin
	 seg[3:0]<=price[choice];
	 seg[7:4]<=money_input;
	 seg[23:8]<=money_input-price[choice];
	 end
    S3:seg<=24'b0001_0001_0001_0001_0001_0001;
	 S4:begin
	 seg<=money_input;end
    endcase
end


endmodule