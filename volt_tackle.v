module volt_tackle(clock, 
						 reset_all,
						 enable_animate,
						 enable_p_vt,
						 enable_draw_pika_vt,
						 enable_draw_hurt_meowth,
						 choose,
						 done_animate_vt,
						 done_pikachu_vt,
						 out_x,
						 out_y,
						 out_colour,
						 done_shift,
						 done_vt,
						 done_hurt_meowth);
	
	input clock;
	input reset_all;
	input enable_animate;
	input enable_p_vt;
	input enable_draw_pika_vt;
	input enable_draw_hurt_meowth;
	input choose;
	
	output done_animate_vt;
	output done_pikachu_vt;
	output done_shift;
	output done_vt;
	output done_hurt_meowth;
	
	output [8:0]out_x;
	output [7:0]out_y;
	output [2:0]out_colour;
	
	wire [7:0]pika_position_y;
	wire [8:0]pika_position_x;
	wire [8:0]pika_vt_position_x;
	wire p_vt_right;
	
	wire [8:0]pika_x;
	wire [7:0]pika_y;
	wire [2:0]pika_c;
	
	wire [8:0]meowth_x;
	wire [7:0]meowth_y;
	wire [2:0]meowth_c;
	
	done_vt_counter done_vt_c(.clock(clock), 
								     .reset(reset_all), 
								     .enable(enable_animate),
								     .pulse(done_animate_vt),
									  .out1(done_shift),
								     .out(done_vt));
	
	animation_frame animate(.clock(clock), 
									.reset(reset_all),
									.enable(enable_animate),
									.out_pulse(done_animate_vt));
					  
	pika_quick_attack_control p_qa_control(.clock(clock), 
														.in_x(pika_position_x),
														.goRight(p_vt_right));
	pika_quick_attack p_qa(.clock(clock), 
								  .enable(enable_p_vt),
								  .reset(reset_all), 
								  .goRight(p_vt_right),
								  .out_x(pika_vt_position_x));
	
	adder_y add_y(.in1_y(8'b01011101), // starting position y = 93
				     .in2_y(8'b00000000),
				     .out_y(pika_position_y));
	adder_x add_x(.in1_x(9'b001000001), // starting position x = 65
				     .in2_x(pika_vt_position_x),
				     .out_x(pika_position_x));
	
	drawThunderPikachu draw_t_pika(.x_(pika_position_x), 
											 .y_(pika_position_y), 
											 .clock_all(clock), 
											 .enable_all(enable_draw_pika_vt), 
											 .reset_all(reset_all), 
											 .done(done_pikachu_vt), 
											 .out_x(pika_x), 
											 .out_y(pika_y), 
											 .out_colour(pika_c));
	
	drawVTMeowth draw_hurt_meowth(.x_(9'b010110100), 
											.y_(8'b00110010), 
											.clock_all(clock), 
											.enable_all(enable_draw_hurt_meowth), 
											.reset_all(reset_all), 
											.done(done_hurt_meowth), 
											.out_x(meowth_x), 
											.out_y(meowth_y), 
											.out_colour(meowth_c));
											
	vt_chooser_x x(.in1(pika_x),
					   .in2(meowth_x), 
						.choose(choose), 
						.out_x(out_x));
	
	vt_chooser_y y(.in1(pika_y), 
						.in2(meowth_y), 
						.choose(choose), 
						.out_y(out_y));
	
	vt_chooser_colour colour(.in1(pika_c), 
									 .in2(meowth_c), 
									 .choose(choose), 
									 .out_c(out_colour));					
endmodule

module vt_chooser_x(in1, in2, choose, out_x);
	input [8:0]in1;
	input [8:0]in2;
	input choose;
	
	output reg [8:0]out_x;
	
	always @(*)
		case(choose)
			1'b0: out_x = in1;
			1'b1: out_x = in2;
			default out_x = in1;
		endcase
endmodule 

module vt_chooser_y(in1, in2, choose, out_y);
	input [7:0]in1;
	input [7:0]in2;
	input choose;
	
	output reg [7:0]out_y;
	
	always @(*)
		case(choose)
			1'b0: out_y = in1;
			1'b1: out_y = in2;
			default out_y = in1;
		endcase
endmodule

module vt_chooser_colour(in1, in2, choose, out_c);
	input [2:0]in1;
	input [2:0]in2;
	input choose;
	
	output reg [2:0]out_c;
	
	always @(*)
		case(choose)
			1'b0: out_c = in1;
			1'b1: out_c = in2;
			default out_c = in1;
		endcase
endmodule

// change the values of these
module done_vt_counter(clock, reset, enable, pulse, out1, out);
	input clock;
	input reset;
	input enable;
	input pulse;
	
	output out;
	output out1;
	
	assign out = (counter == 6'b111100)?1:0; //counts to 60
	assign out1 = (counter == 6'b110010)?1:0;
	
	reg [5:0] counter;
	
	always @(posedge clock)
		begin
			if(reset == 1 && enable == 1)
				begin
					if(counter == 6'b111100)
						counter = 0;
					else if(pulse == 1)
						counter = counter + 1;
				end
			else if(reset == 0)
				counter = 0;
		end
endmodule