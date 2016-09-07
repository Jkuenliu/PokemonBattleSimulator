module pika_counter_x_y(clock,  reset_c, out_x, out_y);
	input clock;
	input reset_c;
	output reg [5:0]out_x;
	output reg [5:0]out_y;
	
	always @(posedge clock)
	begin
		if(reset_c == 1)
		begin
			out_x <= 0;
			out_y <= 0;
		end
		else if(out_x == 6'b110101)
		begin
			out_y = out_y + 1'b1;
			out_x = 0;
		end
		else if(out_y == 6'b111001)
			out_y <= 0;
		else
			out_x <= out_x + 1'b1;
	end
endmodule