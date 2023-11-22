module SEG(
    input clk1k,clr,
    input [23:0] seg_in,
    output reg [7:0] seg_disp,
    output reg [5:0] seg_sel
);
reg [3:0] seg_BCD;
/*===========================================*/
/*段选，根据BCD码进行译码*/
/*===========================================*/
always@(posedge clk1k,negedge clr)
begin
    if(!clr) seg_disp<=8'b1111_1111;
    else 
        case(seg_BCD)
            8'd0:seg_disp<=8'hc0;
            8'd1:seg_disp<=8'hf9;
            8'd2:seg_disp<=8'ha4;
            8'd3:seg_disp<=8'hb0;
            8'd4:seg_disp<=8'h99;
            8'd5:seg_disp<=8'h92;
            8'd6:seg_disp<=8'h82;
            8'd7:seg_disp<=8'hf8;
            8'd8:seg_disp<=8'h80;
            8'd9:seg_disp<=8'h90;
				8'd10:seg_disp<=8'h88;
				8'd11:seg_disp<=8'h83;
				8'd12:seg_disp<=8'hc6;
				8'd13:seg_disp<=8'ha1;
				8'd14:seg_disp<=8'h86;
				8'd15:seg_disp<=8'h8e;
            default:seg_disp<=8'hff;        
        endcase
end
/*===========================================*/
/*位选以及1ms时钟进行切换*/
/*===========================================*/
always@(posedge clk1k,negedge clr)
begin
    if(!clr) begin
        seg_sel<=6'b111111;
        seg_BCD<=1'd0;
    end
    else case(seg_sel)
    6'b011111:begin 
        seg_sel<=6'b101111;
        seg_BCD<=seg_in[19:16];end
    6'b101111:begin 
        seg_sel<=6'b110111;
        seg_BCD<=seg_in[15:12];end
    6'b110111:begin 
        seg_sel<=6'b111011;
        seg_BCD<=seg_in[11:8];end
    6'b111011:begin 
        seg_sel<=6'b111101;
        seg_BCD<=seg_in[7:4];end
    6'b111101:begin 
        seg_sel<=6'b111110;
        seg_BCD<=seg_in[3:0];end
    6'b111110:begin 
        seg_sel<=6'b011111;
        seg_BCD<=seg_in[19:16];end
    default:begin
        seg_sel<=6'b011111;
        seg_BCD<=4'b0;
        end
    endcase
end
endmodule