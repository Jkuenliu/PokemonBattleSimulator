module drawWhite(x_, y_, clock_all, enable_all, reset_all, done, out_x, out_y);
	input clock_all;
	input enable_all;
	input reset_all;
	input [8:0]x_;
	input [7:0]y_;
	
	output done;
	output [8:0]out_x;
	output [7:0]out_y;
	//output [2:0]out_colour;
	//assign out_colour = 3'b101; // change this back to white later
	
	wire [7:0]white_y;
	wire [8:0]white_x;
	
	assign done = (white_y == 8'b00001100 && white_x == 9'b000000000)?1:0;
	assign out_x = x_ + white_x;
	assign out_y = y_ + white_y;

													
	white_counter_x_y testCountX_Y(.clock(clock_all),
										   .reset_c(reset_all),
											.enable(enable_all), // enable
										   .out_x(white_x), 
										   .out_y(white_y));			 
endmodule

module white_counter_x_y(clock, reset_c, enable, out_x, out_y); //pc_xy
	input clock;
	input reset_c;
	input enable;
	output reg [8:0]out_x; // change back to 8:0/1:0
	output reg [7:0]out_y; // change back to 7:0/1:0
	
	always @(posedge clock)
	begin
		if(reset_c == 0)
			begin
				out_x <= 0;
				out_y <= 0;
			end
		else if(enable == 1)
			begin
				if(out_y == 8'b00001100)
					out_y <= 0;
				else
					out_y <= out_y + 8'b00000001;
			end
		else if(enable == 0)
			begin
				out_y <= 0;
			end
	end
endmodule