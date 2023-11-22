module CLK1kHZ(
    input clk50m,clr,
    output reg clk1k
);
reg [15:0] count;
always@(posedge clk50m,negedge clr)
begin
    if(!clr)
    begin
        count<=16'b0;
        clk1k<=1'b0;
    end
    else
    begin
        if(count==16'd50000-1) begin 
		  clk1k<=~clk1k;
        count<=16'b0;
		  end
        else count<=count+1'b1;
    end
end
endmodule