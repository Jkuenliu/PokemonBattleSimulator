module quick_attack(clock, 
						  reset_all,
						  enable_animate,
						  enable_p_qa,
						  enable_draw_pika,
						  done_animate,
						  done_pikachu,
						  p_qa_x, 
						  p_qa_y,
						  p_qa_colour,
						  done_quick_attack);
	input clock;
	input reset_all;
	input enable_animate;
	input enable_p_qa;
	input enable_draw_pika;
	
	output done_animate;
	output done_pikachu;
	output done_quick_attack;
	output [8:0]p_qa_x;
	output [7:0]p_qa_y;
	output [2:0]p_qa_colour;
	
	wire [7:0]pika_position_y;
	wire [8:0]pika_position_x;
	wire [8:0]pika_qa_position_x;
	wire p_qa_right;
	
	done_quick_attack_counter done(.clock(clock), 
											 .reset(reset_all), 
											 .enable(enable_animate),
											 .pulse(done_animate),
											 .out(done_quick_attack));
	
	animation_frame animate(.clock(clock), 
									.reset(reset_all),
									.enable(enable_animate),
									.out_pulse(done_animate));
					  
	pika_quick_attack_control p_qa_control(.clock(clock), 
														.in_x(pika_position_x),
														.goRight(p_qa_right));
	pika_quick_attack p_qa(.clock(clock), 
								  .enable(enable_p_qa),
								  .reset(reset_all), 
								  .goRight(p_qa_right),
								  .out_x(pika_qa_position_x));
	
	adder_y add_y(.in1_y(8'b01011101), // starting position y = 93
				     .in2_y(8'b00000000),
				     .out_y(pika_position_y));
	adder_x add_x(.in1_x(9'b001000001), // starting position x = 65
				     .in2_x(pika_qa_position_x),
				     .out_x(pika_position_x));
	
	drawPikachu draw_pika(.x_(pika_position_x), // starting position x = 65
								 .y_(pika_position_y), // starting position y = 99
								 .clock_all(clock), 
								 .enable_all(enable_draw_pika), 
								 .reset_all(reset_all), 
								 .done(done_pikachu),
								 .out_x(p_qa_x), // output
								 .out_y(p_qa_y), // output 
								 .out_colour(p_qa_colour)); // output
endmodule 

module done_quick_attack_counter(clock, reset, enable, pulse, out);
	input clock;
	input pulse;
	input enable;
	input reset;
	
	output out;
	
	reg [5:0] counter; //change it back to 5:0
	
	assign out = (counter == 6'b110010)?1:0; //change it back to 6'b110010 *or modify it for future purposes depending on how things go
	
	always @(posedge clock)
		begin
			if(reset == 1 && enable == 1)
				begin
					if(counter == 6'b110010) //change it back to 6'b110010
						counter = 0;
					else if(pulse == 1)
						counter = counter + 1;
				end
			else if(reset == 0)
				counter = 0;
		end
endmodule

//QUICK ATTACK CONTROL
module pika_quick_attack_control(clock, in_x, goRight);
	input [8:0]in_x;
	input clock;
	
	output reg goRight;
	
	always @(posedge clock)
	begin
		if(in_x == 9'b001011010) //new position is 90
			goRight = 0;
		else if(in_x == 9'b001000001) // this is the original position
			goRight = 1;
	end
endmodule

//QUICK ATTACK ANIMATION
module pika_quick_attack(clock, enable, reset, goRight, out_x);
	input clock;
	input enable;
	input reset;
	input goRight;
	output reg [8:0]out_x;

	always @(posedge clock)
	begin
		if(enable == 1 && reset == 1)
			begin
				if(goRight == 1)
					out_x = out_x + 1;
				else
					out_x = out_x - 1;
			end
		else if(reset == 0)
			begin
				out_x = 0;
			end
		else if(enable == 0)
			out_x = out_x;
	end
endmodule
