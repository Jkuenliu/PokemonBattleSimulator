module meowth_attack(clock, 
						   reset_all,
						   enable_animate,
						   enable_m_qa,
						   enable_draw_meowth,
						   done_animate,
						   done_meowth,
						   m_qa_x, 
						   m_qa_y,
						   m_qa_colour,
						   done_quick_attack);
							
	input clock;
	input reset_all;
	input enable_animate;
	input enable_m_qa;
	input enable_draw_meowth;
	
	output done_animate;
	output done_meowth;
	output done_quick_attack;
	output [8:0]m_qa_x;
	output [7:0]m_qa_y;
	output [2:0]m_qa_colour;
	
	wire [7:0]meowth_position_y;
	wire [8:0]meowth_position_x;
	wire [8:0]meowth_qa_position_x;
	wire m_qa_left;
	
	done_quick_attack_counter done(.clock(clock), 
											 .reset(reset_all), 
											 .enable(enable_animate),
											 .pulse(done_animate),
											 .out(done_quick_attack));
	
	animation_frame animate(.clock(clock), 
									.reset(reset_all),
									.enable(enable_animate),
									.out_pulse(done_animate));
									
	meowth_quick_attack_control m_qa_control(.clock(clock),
														  .in_x(meowth_position_x),
														  .goLeft(m_qa_left));
	
	meowth_quick_attack m_qa(.clock(clock), 
								    .enable(enable_m_qa),
								    .reset(reset_all), 
								    .goLeft(m_qa_left),
								    .out_x(meowth_qa_position_x));
										 
	adder_y add_y(.in1_y(8'b00110110), // starting position y = 54
				     .in2_y(8'b00000000),
				     .out_y(meowth_position_y));
	adder_x add_x(.in1_x(9'b010111100), // starting position x = 188
				     .in2_x(meowth_qa_position_x),
				     .out_x(meowth_position_x));
							
	drawMeowth draw_meowth(.x_(meowth_position_x), // starting position x = 188
								  .y_(meowth_position_y), // starting position y = 54
								  .clock_all(clock), 
								  .enable_all(enable_draw_meowth), 
								  .reset_all(reset_all), 
								  .done(done_meowth),
								  .out_x(m_qa_x), // output
								  .out_y(m_qa_y), // output 
								  .out_colour(m_qa_colour)); // output
							
endmodule
//x: 250 - 225
//y: 54 - 54 (110110)
//QUICK ATTACK CONTROL
module meowth_quick_attack_control(clock, in_x, goLeft);
	input [8:0]in_x;
	input clock;
	
	output reg goLeft;
	
	always @(posedge clock)
	begin
		if(in_x == 9'b010100011) //original position was 188 new position is 163
			goLeft = 0;
		else if(in_x == 9'b010111100) // this is the original position - 188
			goLeft = 1;
	end
endmodule

//QUICK ATTACK ANIMATION
module meowth_quick_attack(clock, enable, reset, goLeft, out_x);
	input clock;
	input enable;
	input reset;
	input goLeft;
	output reg [8:0]out_x;

	always @(posedge clock)
	begin
		if(enable == 1 && reset == 1)
			begin
				if(goLeft == 1)
					out_x = out_x - 1;
				else
					out_x = out_x + 1;
			end
		else if(reset == 0)
			begin
				out_x = 0;
			end
		else if(enable == 0)
			out_x = out_x;
	end
endmodule