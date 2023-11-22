module Vending(
    input clk50m,clr,
    input [3:0] key_in,
    output wire [7:0] seg_disp,
    output wire [5:0] seg_sel
);
/*===========================================*/
/*各种实例化*/
/*===========================================*/
wire clk1k;
wire [3:0] key_out;
wire [23:0] seg;
CLK1kHZ U_CLK(.clk50m(clk50m),.clr(clr),.clk1k(clk1k));
KEY U_KEY(.clr(clr),.key_in(key_in),.clk1k(clk1k),.key_out(key_out));
STM U_STM(.clk1k(clk1k),.clr(clr),.key(key_out),.seg(seg));
SEG U_SEG(.clk1k(clk1k),.clr(clr),.seg_in(seg),.seg_disp(seg_disp),.seg_sel(seg_sel));
endmodule