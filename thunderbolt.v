module thunderbolt(clock, 
						 reset, 
						 enable_draw_tb_pika,
						 enable_draw_L_tb,
						 enable_draw_M_tb,
						 enable_draw_S_tb,
						 enable_animate,
						 done_tb_pika,
						 done_L_tb,
						 done_M_tb,
						 done_S_tb,
						 done_animate,
						 done_tb,
						 out_x,
						 out_y,
						 out_colour);
						 
	input clock;
	input reset;
	
	input enable_draw_tb_pika;
	input enable_draw_L_tb;
	input enable_draw_M_tb;
	input enable_draw_S_tb;
	input enable_animate;
	
	output done_tb_pika;
	output done_L_tb;
	output done_M_tb;
	output done_S_tb;
	output done_animate;
	output done_tb;
	
	output [8:0]out_x;
	output [7:0]out_y;
	output [2:0]out_colour;
	
	wire [8:0]in1_x;
	wire [8:0]in2_x;
	wire [8:0]in3_x;
	wire [8:0]in4_x;
	
	wire [7:0]in1_y;
	wire [7:0]in2_y;
	wire [7:0]in3_y;
	wire [7:0]in4_y;
	
	wire [2:0]in1_c;
	wire [2:0]in2_c;
	wire [2:0]in3_c;
	wire [2:0]in4_c;
	
	wire [3:0]tb_input;
	assign tb_input[0] = enable_draw_tb_pika;
	assign tb_input[1] = enable_draw_L_tb;
	assign tb_input[2] = enable_draw_M_tb;
	assign tb_input[3] = enable_draw_S_tb;
	
	done_tb_counter done(.clock(clock), 
								.reset(reset), 
								.enable(enable_animate),
								.pulse(done_animate),
								.out(done_tb));
	
	animation_frame animate(.clock(clock), 
									.reset(reset),
									.enable(enable_animate),
									.out_pulse(done_animate));
	
	drawThunderPikachu tb_pika(.x_(9'b001000001), // x = 65
										.y_(8'b01011101),  // y = 93
										.clock_all(clock), 
										.enable_all(enable_draw_tb_pika), 
										.reset_all(reset), 
										.done(done_tb_pika), 
										.out_x(in1_x), 
										.out_y(in1_y), 
										.out_colour(in1_c));
	
	drawLargeThunder L_tb(.x_(9'b010111100), 
								 .y_(8'b00000000), 
								 .clock_all(clock), 
								 .enable_all(enable_draw_L_tb), 
								 .reset_all(reset), 
								 .done(done_L_tb), 
								 .out_x(in2_x), 
								 .out_y(in2_y), 
								 .out_colour(in2_c));
	
	drawMediumThunder M_tb(.x_(9'b010111100), 
								  .y_(8'b00000000), 
								  .clock_all(clock), 
								  .enable_all(enable_draw_M_tb), 
								  .reset_all(reset), 
								  .done(done_M_tb), 
								  .out_x(in3_x), 
								  .out_y(in3_y), 
								  .out_colour(in3_c));
	
	drawSmallThunder S_tb(.x_(9'b010111100), 
								 .y_(8'b00000000), 
								 .clock_all(clock), 
								 .enable_all(enable_draw_S_tb), 
								 .reset_all(reset), 
								 .done(done_S_tb), 
								 .out_x(in4_x), 
								 .out_y(in4_y), 
								 .out_colour(in4_c));
								 
	tb_chooser_x x(.in1(in1_x), 
					   .in2(in2_x), 
					   .in3(in3_x),
					   .in4(in4_x),
					   .choose(tb_input),
					   .out_x(out_x));
	
	tb_chooser_y y(.in1(in1_y), 
					   .in2(in2_y), 
					   .in3(in3_y),
					   .in4(in4_y),
					   .choose(tb_input),
					   .out_y(out_y));
	
	tb_chooser_colour c(.in1(in1_c), 
					        .in2(in2_c), 
					        .in3(in3_c),
					        .in4(in4_c),
					        .choose(tb_input),
					        .out_c(out_colour));
endmodule

module done_tb_counter(clock, reset, enable, pulse, out);
	input clock;
	input reset;
	input enable;
	input pulse;
	
	output out;
	
	assign out = (counter == 3'b101)?1:0;
	
	reg [2:0] counter;
	
	always @(posedge clock)
		begin
			if(reset == 1 && enable == 1)
				begin
					if(counter == 3'b101)
						counter = 0;
					else if(pulse == 1)
						counter = counter + 1;
				end
			else if(reset == 0)
				counter = 0;
		end
endmodule

module tb_chooser_x(in1, in2, in3, in4, choose, out_x);
	input [8:0]in1;
	input [8:0]in2;
	input [8:0]in3;
	input [8:0]in4;
	input [3:0]choose;
	
	output reg [8:0]out_x;
	
	always @(*)
		case(choose)
			4'b0001: out_x = in1;
			4'b0010: out_x = in2;
			4'b0100: out_x = in3;
			4'b1000: out_x = in4;
			default out_x = 0;
		endcase
	
endmodule

module tb_chooser_y(in1, in2, in3, in4, choose, out_y);
	input [7:0]in1;
	input [7:0]in2;
	input [7:0]in3;
	input [7:0]in4;
	input [3:0]choose;
	
	output reg [7:0]out_y;
	
	always @(*)
		case(choose)
			4'b0001: out_y = in1;
			4'b0010: out_y = in2;
			4'b0100: out_y = in3;
			4'b1000: out_y = in4;
			default out_y = 0;
		endcase
	
endmodule

module tb_chooser_colour(in1, in2, in3, in4, choose, out_c);
	input [2:0]in1;
	input [2:0]in2;
	input [2:0]in3;
	input [2:0]in4;
	input [3:0]choose;
	
	output reg [2:0]out_c;
	
	always @(*)
		case(choose)
			4'b0001: out_c = in1;
			4'b0010: out_c = in2;
			4'b0100: out_c = in3;
			4'b1000: out_c = in4;
			default out_c = 0;
		endcase
	
endmodule	
