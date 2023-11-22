module KEY
#(parameter CNT_20ms = 20 )(
    input clk1k,clr,
    input [3:0] key_in,
    output reg [3:0] key_out
);
reg [5:0] count;
wire end_cnt;
wire flag_fall;
reg timing;
reg [3:0] key_before;
reg [3:0] key_now;

/*===========================================*/
/*=============20ms count================*/
always @(posedge clk1k , negedge clr)
begin
    if(!clr) count<=6'b0;
    else if(timing)
    begin
    if(count ==6'b010100)
        count <= 6'b0; 
    else
        count <= count + 6'b1; 
    end
	 else count<=6'b0;
end
/*key now upd*/
always @(posedge clk1k,negedge clr)
begin if(!clr) key_now<=4'b1111;
else key_now<=key_in;
end 

/*key before upd*/
always @(posedge clk1k , negedge clr)
begin
    if(!clr) key_before<=4'b1111;
    else key_before<=key_now;
end

/*doudong start*/
assign flag_fall=((key_before&(~key_now))!=0);

/*===========================================*/
/*===========timing control=================*/
/*===========================================*/
always @(posedge clk1k,negedge clr)
begin
    if(!clr) timing<=1'b0;
    else if(flag_fall) timing<=1'b1;
    else if(end_cnt) timing<=1'b0;
    else timing<=timing;
end

/*===========================================*/
/*=============end cnt flag====================*/
assign end_cnt=((count==CNT_20ms)&&timing);
/*===========================================*/
/*==============output logic===================*/
/*==============high valid==================*/
always @(posedge clk1k , negedge clr)
begin
    if(!clr) key_out<=4'b0000;
    else if(end_cnt) key_out<=(~key_now);
    else key_out<=4'b0000;
end

endmodule