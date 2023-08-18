/**
 *
 * @author : 409410120劉哲嘉, 409410121吳年茵
 * @latest changed : 2022/5/15 20:21
 */

`define length 6
module lab8(input clk,
            input reset,
            input give_valid,
            input [7:0]dataX,
            input [7:0]dataY,
            output reg [7:0]ansX,
            output reg [7:0]ansY,
            output reg out_valid);

integer i;
integer j;

reg [7:0]count[0:`length-1];
reg [7:0]inX[0:`length-1];
reg [7:0]inY[0:`length-1];
reg signed [7:0]tempX[0:`length-1];
reg signed [7:0]tempY[0:`length-1];
reg [7:0]out;
reg [7:0]ix;
reg [3:0]state;

reg [7:0]t;
reg [7:0]tmp;
reg [7:0]tX;
reg [7:0]tY;

initial begin
    $dumpfile("Lab.vcd");
    $dumpvars(0, lab8_tb);
    for(i = 0; i < `length; i = i+1)
        $dumpvars(1, inX[i], inY[i], tempX[i], tempY[i], count[i]);
end

always@(posedge clk or posedge reset)
begin
	
	if(reset)
	begin
		state<=1;
		out <= 8'd0;
		ix <= 8'd0;
		out_valid <= 0;
		for (i = 0; i < `length; i = i + 1)
		begin
			inX[i] <= 0;
			inY[i] <= 0;
			tempX[i] <= 0;
			tempY[i] <= 0;
			count[i] <= i;
		end
	end
	else if(state == 0)
	begin
		state<=1;
		out <= 8'd0;
		ix <= 8'd0;
		out_valid <= 0;
		for (i = 0; i < `length; i = i + 1)
		begin
			inX[i] <= 0;
			inY[i] <= 0;
			tempX[i] <= 0;
			tempY[i] <= 0;
			count[i] <= i;
		end
	end
	else if( state == 1)
	begin
		if( ix==`length) state<= 2;
		else if(give_valid)
		begin
			inX[ix] <= dataX;
			inY[ix] <= dataY;
			ix <= ix + 1;
		end
	end
	else if( state == 2 )
	begin
		for(i = 0; i < `length; i = i + 1)
		begin 
			tempX[i] <= inX[i] - inX[0];
			tempY[i] <= inY[i] - inY[0];	
		end
		state <= 3;
	end
	else if( state == 3)
	begin
		for( j = `length-1; j > 0; j = j -1)
		begin
			for( i = 0; i < j; i = i + 1)
			begin 
				t = inX[i];
				tmp = inY[i];
				tX = tempX[i];
				tY = tempY[i];
				if( tempX[i]*tempY[i+1] - tempX[i+1]*tempY[i] < 0 )
				begin 
					inX[i] = inX[i+1];
					inY[i] = inY[i+1];
					inX[i+1] = t;
					inY[i+1] = tmp; 
					tempX[i] = tempX[i+1];
					tempY[i] = tempY[i+1];
					tempX[i+1] = tX;
					tempY[i+1] = tY; 
				end
			end
		end
		state<= 4;
	end
	else if( state == 4)
	begin
		out_valid <= 1;
		ansX = inX[out];
		ansY = inY[out];
		out <= out + 1'b1;
		if( out == `length ) 
		begin 
			state<= 0;
			out_valid <= 0;
		end		
	end

end
endmodule