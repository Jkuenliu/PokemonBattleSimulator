module FinalProject(CLOCK_50, KEY, SW, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B);
	
	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour_in;
	wire [8:0] x;
	wire [7:0] y;
	wire writeEn;
	
	wire reset_data;
	
	wire enable_draw_pikachu;
	wire enable_animate_sprite;
	wire enable_pika_qa;
	
	wire done_draw_pikachu;
	wire done_animate_sprite;
	wire done_qa;
	
	wire pick_colour;
	wire pick_x_state;
	wire pick_y_state;
	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour_in),
			.x(x),
			.y(y), 
			.plot(writeEn),
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "white.mif";
		
		controlpath control(.clock(CLOCK_50), 
								  .reset(resetn), 
								  .reset_all(reset_data),
								  .done_pikachu(done_draw_pikachu),
								  .done_animate(done_animate_sprite),
								  .done_qa(done_qa),
								  .enable_draw_pika(enable_draw_pikachu),
								  .enable_animate(enable_animate_sprite),
								  .enable_p_qa(enable_pika_qa),
								  .choose_colour(pick_colour),
								  .choose_x_mode(pick_x_state),
								  .choose_y_mode(pick_y_state),
								  .plot(writeEn));
								  //clock, reset, reset_all, done_pikachu, enable_pc_xy, enable_pac, plot
		datapath data(.clock(CLOCK_50),
						  .reset_all(reset_data), 
						  .enable_draw_pika(enable_draw_pikachu),
						  .enable_animate(enable_animate_sprite),
						  .enable_p_qa(enable_pika_qa),
						  .choose_colour(pick_colour),
						  .choose_x_mode(pick_x_state),
						  .choose_y_mode(pick_y_state),
						  .done_pikachu(done_draw_pikachu),
						  .done_animate(done_animate_sprite),
						  .done_qa(done_qa),
						  .out_x(x),
						  .out_y(y),
						  .out_colour(colour_in));
						  //clock, reset_all, enable_draw_pika, enable_animate, enable_p_qa, choose_colour, choose_x_mode, 
						  //choose_y_mode, done_pikachu, done_animate, out_x, out_y, out_colour
endmodule

module controlpath(clock, reset, reset_all, done_pikachu, done_animate, done_qa, enable_draw_pika, enable_animate, enable_p_qa, choose_colour, 
						 choose_x_mode, choose_y_mode, plot);
	input clock;
	input reset; //user input signal to reset
	
	input done_pikachu;
	input done_animate;
	input done_qa;
	
	output reg enable_draw_pika;
	output reg enable_animate;
	output reg enable_p_qa;
	
	output reg choose_colour;
	output reg choose_x_mode;
	output reg choose_y_mode;
	
	output reg reset_all; //tells datapath to reset all
	output reg plot;
	
	reg [2:0] presentstate;
	reg [2:0] nextstate;
	
	//p_qa = pikachu quick attack
	parameter[2:0] reset_state = 3'b000, draw_pikachu = 3'b001, idle_p_qa = 3'b010, erase_pikachu = 3'b011, p_qa = 3'b100, idle = 3'b101;
	
	always @(*)
	case(presentstate)
		reset_state:
			begin
				nextstate <= draw_pikachu;
			end
		//QUICK ATTACK LOOP##################################################################
		draw_pikachu:
			begin
				if(done_pikachu == 1)
					nextstate <= idle_p_qa;
				else
					nextstate <= draw_pikachu;
			end
		idle_p_qa: 
			begin
				if(done_qa == 1)
					nextstate <= idle;
				else if(done_animate == 1)
					nextstate <= erase_pikachu;
				else
					nextstate <= idle_p_qa;
			end
		erase_pikachu:
			begin
				if(done_pikachu == 1)
					nextstate <= p_qa;
				else
					nextstate <= erase_pikachu;
			end
		p_qa:
			begin
				nextstate <= draw_pikachu; //idle_p_qa
			end
		idle:
			begin
				nextstate <= idle;
			end
	endcase
	
	always @(posedge clock)
	begin
		if(reset == 0)
			presentstate <= reset_state;
		else
			presentstate <= nextstate;
	end
	
	always @(*)
	case(presentstate)
		reset_state:
			begin
				reset_all = 0;
				enable_draw_pika = 0;
	         enable_animate = 0;
				enable_p_qa = 0;
				choose_colour = 0;
				choose_x_mode = 0;
				choose_y_mode = 0;
				plot = 0;
			end
		//QUICK ATTACK LOOP##################################################################
		draw_pikachu:
			begin
				reset_all = 1;
				enable_draw_pika = 1;
				enable_animate = 0;
				enable_p_qa = 0;
				choose_colour = 0;
				choose_x_mode = 0;
				choose_y_mode = 0;
				plot = 1;
			end
		idle_p_qa: 
			begin
				reset_all = 1;
				enable_draw_pika = 0;
				enable_animate = 1;
				enable_p_qa = 0;
				choose_colour = 0;
				choose_x_mode = 0;
				choose_y_mode = 0;
				plot = 0;
			end
		erase_pikachu:
			begin
				reset_all = 1;
				enable_draw_pika = 1;
				enable_animate = 0;
				enable_p_qa = 0;
				choose_colour = 1;
				choose_x_mode = 0;
				choose_y_mode = 0;
				plot = 1;
			end
		p_qa:
			begin
				reset_all = 1;
				enable_draw_pika = 0;
				enable_animate = 0;
				enable_p_qa = 1;
				choose_colour = 0;
				choose_x_mode = 0;
				choose_y_mode = 0;
				plot = 0;
			end
		idle:
			begin
				reset_all = 1;
				enable_draw_pika = 0;
				enable_animate = 0;
				enable_p_qa = 0;
				choose_colour = 0;
				choose_x_mode = 0;
				choose_y_mode = 0;
				plot = 0;
			end
	endcase
	
endmodule

//DATAPATH
module datapath(clock, reset_all, enable_draw_pika, enable_animate, enable_p_qa, choose_colour, choose_x_mode, 
					 choose_y_mode, done_pikachu, done_animate, out_x, out_y, out_colour, done_qa);
	input clock;
	input reset_all;
	input enable_draw_pika;
	input enable_animate;
	input enable_p_qa;
	
	input choose_colour;//change the size of this as we add more modules
	input choose_x_mode;//change the size of this as we add more modules
	input choose_y_mode;//change the size of this as we add more modules
	
	output done_pikachu;
	output done_animate;
	output done_qa;
	
	output [8:0]out_x;
	output [7:0]out_y;
	output [2:0]out_colour;
	
	wire [8:0]draw_pika_x;
	wire [7:0]draw_pika_y;
	wire [2:0]draw_pika_colour;
	
	wire p_qa_right;
	
	quick_attack attack_one(.clock(clock), 
									.reset_all(reset_all), 
									.enable_animate(enable_animate), 
									.enable_p_qa(enable_p_qa), 
									.enable_draw_pika(enable_draw_pika), 
									.done_animate(done_animate), 
									.done_pikachu(done_pikachu),
									.p_qa_x(draw_pika_x), 
									.p_qa_y(draw_pika_y), 
									.p_qa_colour(draw_pika_colour),
									.done_quick_attack(done_qa));
									
								 
	choose_y y(.in1(draw_pika_y), 
				  .in2(8'b00000000),
				  .choose(choose_x_mode), 
				  .out_y(out_y)); // output y
	choose_x x(.in1(draw_pika_x), 
				  .in2(9'b000000000),
				  .choose(choose_y_mode), 
				  .out_x(out_x)); // output x
	choose_c colour(.in1(draw_pika_colour), 
					    .in2(3'b111), 
					    .choose(choose_colour),
					    .out(out_colour));		 
endmodule

//ANIMATION_TIMER
module animation_frame(clock, reset, enable, out_pulse);
	input clock;
	input reset;
	input enable;
	
	output out_pulse;

	wire count_pulse;
	
	fifteen_hz_counter done_fifteen(.pulse(count_pulse),
											  .clock(clock),
										     .reset(reset), 
											  .enable_fifteen(enable),
											  .out(out_pulse));
											  
	sixty_hz_clock	sixty_hz(.clock(clock), 
									.reset(reset), 
									.enable_sixty(enable),
									.pulse(count_pulse));
endmodule

//FIFTEEN_HZ_COUNTER
module fifteen_hz_counter(pulse, clock, reset, enable_fifteen, out);
	input pulse;
	input reset;
	input enable_fifteen;
	input clock;
	
	output out;
	
	reg [3:0]counter;
	
	assign out = (counter == 4'b1111)?1:0;
	
	always @(posedge clock)
	begin
		if(reset == 1 && enable_fifteen == 1)
			begin
				if(counter == 4'b1111)
					counter = 0;
				else if(pulse == 1)
					counter = counter + 1;
			end
		else if(reset == 0 || enable_fifteen == 0)
			counter = 0;
	end
endmodule

//SIXTY_HZ_CLOCK
module sixty_hz_clock(clock, reset, enable_sixty, pulse);
	input clock;
	input reset;
	input enable_sixty;
	
	output pulse;
	
	reg [14:0]rate; //change this back to 19:0
	
	assign pulse = (rate == 0)?1:0;
	
	always @(posedge clock)
	begin
		if(reset == 1 && enable_sixty == 1)
			begin
				if(rate == 0)
					rate = 15'b110000110101000; // change this value later to 20'b11001011011100110101
				else	
					rate = rate - 1;
			end
		else if(reset == 0 || enable_sixty == 0)
			begin
				rate = 15'b110000110101000;
			end
	end
endmodule

//Y MUX
module choose_y(in1, in2, choose, out_y); //we will add more stuff later
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

//X MUX
module choose_x(in1, in2, choose, out_x); //we will add more stuff later
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

//COLOUR MUX
module choose_c(in1, in2, choose, out);//we will make this bigger as we add more characters
	input [2:0]in1;
	input [2:0]in2;
	input choose;
	
	output reg [2:0]out;
	
	always @(choose)
		case(choose)
			1'b0: out = in1;
			1'b1: out = in2;
			default out = in1;
		endcase
endmodule

//ADDER
module adder_y(in1_y, in2_y, out_y);
	input [7:0]in1_y;
	input [7:0]in2_y; // actually lets just use 8bit and fill it with zeros
	output [7:0]out_y; 
	
	assign out_y = in1_y + in2_y;
endmodule

//ADDER
module adder_x(in1_x, in2_x, out_x);
	input [8:0]in1_x;
	input [8:0]in2_x; // we'll just use 8bit and fill it with zeros
	output [8:0]out_x;
	
	assign out_x = in1_x + in2_x;
endmodule

// we will implement this later
module white_out(enable_wht, reset_wht, clock_wht, done_whtout, colour_wht, wht_x, wht_y);
	input enable_wht;
	input clock_wht;
	input reset_wht;
	
	//wire y_clock;
	
	output [2:0]colour_wht;
	output reg [8:0]wht_x;
	output reg [7:0]wht_y;
	output reg done_whtout;
	
	assign colour_wht = 3'b111;
	
	always @(posedge clock_wht)
	begin
		if(reset_wht == 1)
		begin
			wht_x <= 0;
			wht_y <= 0;
		end
		else if(wht_x == 9'b010100000)
		begin
			wht_x <= 0;
			wht_y <= wht_y + 1;
		end
		else if(enable_wht == 1)
			wht_x <= wht_x + 1;
		if(wht_y == 8'b01111000)
			done_whtout = 1;
	end
endmodule