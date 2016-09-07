module drawSmallThunder(x_, y_, clock_all, enable_all, reset_all, done, out_x, out_y, out_colour);
	input clock_all;
	input enable_all;
	input reset_all;
	input [8:0]x_;
	input [7:0]y_;
	
	output done;
	output [8:0]out_x;
	output [7:0]out_y;
	output [2:0]out_colour;
	
	wire [9:0]smallthunder_address;
	wire [7:0]smallthunder_y;
	wire [8:0]smallthunder_x;
	
	assign done = (smallthunder_y == 8'b00011011 && smallthunder_x == 9'b000100011)?1:0;
	assign out_x = x_ + smallthunder_x;
	assign out_y = y_ + smallthunder_y;

	smallthunder_address_counter testCount(.clock(clock_all),
											 .enable(enable_all), // enable
											 .reset_c(reset_all),
											 .out(smallthunder_address));
													
	smallthunder_counter_x_y testCountX_Y(.clock(clock_all),
										   .reset_c(reset_all),
											.enable(enable_all), // enable
										   .out_x(smallthunder_x), 
										   .out_y(smallthunder_y));
													
	smallthunder36x28x3 smallthunder(.address(smallthunder_address),
							 .clock(clock_all), 
							 .data(3'b000), 
							 .wren(1'b0),
							 .q(out_colour));
							 
endmodule

module smallthunder_counter_x_y(clock, reset_c, enable, out_x, out_y); //pc_xy
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
		else if(out_y == 8'b00011011 && out_x == 9'b000100011) //change it back to 8'b00111000 && change it back to 9'b000110100/ 2'b11
			begin
				out_y <= 0;
				out_x <= 0;
			end
		else if(out_x == 9'b000100011) //change it back to 9'b000110101/2'b11
			begin
				out_y <= out_y + 1'b1;
				out_x <= 0;
			end
		else if(enable == 1)
			begin
				out_x <= out_x + 1'b1;
			end
		else 
			begin
				out_x = 0;
				out_y = 0;
			end
	end
endmodule

module smallthunder_address_counter(clock, reset_c, enable, out); //pa
	input reset_c;
	input clock;
	input enable;
	output reg [9:0]out; // change back to 11:0/4:0
	
	always @(posedge clock)
		begin
			if(reset_c == 0)
				out <= 0;
			else if(out == 10'b1110110000) // change back to 12'b101111001100/4'b1111
				out <= 0; 
			else if(enable == 1)
				out = out + 1;
			else
				out = 0;
		end
endmodule