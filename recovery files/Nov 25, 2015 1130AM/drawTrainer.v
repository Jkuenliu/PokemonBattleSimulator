module drawTrainer(x_, y_, clock_all, enable_all, reset_all, done, out_x, out_y, out_colour);
	input clock_all;
	input enable_all;
	input reset_all;
	input [8:0]x_;
	input [7:0]y_;
	
	output done;
	output [8:0]out_x;
	output [7:0]out_y;
	output [2:0]out_colour;
	
	wire [11:0]trainer_address;
	wire [7:0]trainer_y;
	wire [8:0]trainer_x;
	
	assign done = (trainer_y == 8'b00111010 && trainer_x == 9'b000111110)?1:0;
	assign out_x = x_ + trainer_x;
	assign out_y = y_ + trainer_y;

	trainer_address_counter testCount(.clock(clock_all),
												 .enable(enable_all), // enable
												 .reset_c(reset_all),
												 .out(trainer_address));
													
	trainer_counter_x_y testCountX_Y(.clock(clock_all),
												.reset_c(reset_all),
												.enable(enable_all), // enable
												.out_x(trainer_x), 
												.out_y(trainer_y));
													
	trainer3717x3 trainer(.address(trainer_address),
								 .clock(clock_all), 
								 .data(3'b000), 
								 .wren(1'b0),
								 .q(out_colour));
							 
endmodule

module trainer_counter_x_y(clock, reset_c, enable, out_x, out_y); //pc_xy
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
		else if(out_y == 8'b00111010 && out_x == 9'b000111110) //change it back to 8'b00111000 && change it back to 9'b000110100/ 2'b11
			begin
				out_y <= 0;
				out_x <= 0;
			end
		else if(out_x == 9'b000111110) //change it back to 9'b000110101/2'b11
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

module trainer_address_counter(clock, reset_c, enable, out); //pa
	input reset_c;
	input clock;
	input enable;
	output reg [11:0]out; // change back to 12:0/4:0
	
	always @(posedge clock)
		begin
			if(reset_c == 0)
				out <= 0;
			else if(out == 12'b111010000100) // change back to 12'b101111001100/4'b1111
				out <= 0; 
			else if(enable == 1)
				out = out + 1;
			else
				out = 0;
		end
endmodule