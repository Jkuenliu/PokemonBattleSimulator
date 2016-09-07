module FinalProject(CLOCK_50, 
						  KEY, 
						  SW,
						  VGA_CLK,
						  VGA_HS,
						  VGA_VS, 
						  VGA_BLANK_N,
						  VGA_SYNC_N,
						  VGA_R, 
						  VGA_G,
						  VGA_B);
	
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
	wire enable_draw_meowth_HP;
	wire enable_draw_pikachu_HP;
	wire enable_draw_team_rocket;
	wire enable_draw_trainer;
	
	wire done_draw_pikachu;
	wire done_animate_sprite;
	wire done_qa;
	wire done_meowth_HP;
	wire done_pikachu_HP;
	wire done_team_rocket;
	wire done_trainer;
	
	wire [3:0]pick_colour;
	wire [3:0]pick_x_state;
	wire [3:0]pick_y_state;
	
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
								  .quick_attack(~KEY[1]),
								  .reset(resetn), 
								  .reset_all(reset_data),
								  .done_pikachu_qa(done_draw_pikachu),
								  .done_animate_qa(done_animate_sprite),
								  .done_qa(done_qa),
								  .done_meowth_HP(done_meowth_HP),
								  .done_pikachu_HP(done_pikachu_HP),
								  .done_team_rocket(done_team_rocket),
								  .done_trainer(done_trainer),
								  .enable_draw_pika(enable_draw_pikachu),
								  .enable_animate(enable_animate_sprite),
								  .enable_p_qa(enable_pika_qa),
								  .enable_draw_meowth_HP(enable_draw_meowth_HP),
								  .enable_draw_pikachu_HP(enable_draw_pikachu_HP),
								  .enable_draw_team_rocket(enable_draw_team_rocket),
								  .enable_draw_trainer(enable_draw_trainer), 
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
						  .enable_draw_meowth_HP(enable_draw_meowth_HP),
						  .enable_draw_pikachu_HP(enable_draw_pikachu_HP),
						  .enable_draw_team_rocket(enable_draw_team_rocket),
						  .enable_draw_trainer(enable_draw_trainer),
						  .choose_colour(pick_colour),
						  .choose_x_mode(pick_x_state),
						  .choose_y_mode(pick_y_state),
						  .done_pikachu_qa(done_draw_pikachu),
						  .done_animate_qa(done_animate_sprite),
						  .done_qa(done_qa),
						  .done_meowth_HP(done_meowth_HP),
						  .done_pikachu_HP(done_pikachu_HP),
						  .done_team_rocket(done_team_rocket),
						  .done_trainer(done_trainer),
						  .out_x(x),
						  .out_y(y),
						  .out_colour(colour_in));
						  //clock, reset_all, enable_draw_pika, enable_animate, enable_p_qa, choose_colour, choose_x_mode, 
						  //choose_y_mode, done_pikachu, done_animate, out_x, out_y, out_colour
endmodule

module controlpath(clock,
						 quick_attack, 
						 reset,
						 reset_all,
						 done_pikachu_qa,
						 done_animate_qa,
						 done_qa, 
						 done_meowth_HP,
						 done_pikachu_HP,
						 done_team_rocket,
						 done_trainer,
						 enable_draw_pika, 
						 enable_animate, 
						 enable_p_qa,
						 enable_draw_meowth_HP,
						 enable_draw_pikachu_HP,
						 enable_draw_team_rocket,
						 enable_draw_trainer,
						 choose_colour,
						 choose_x_mode,
						 choose_y_mode, 
						 plot);
	input clock;
	input reset; //user input signal to reset
	
	//input done_pikachu;
	input done_pikachu_qa;
	input done_animate_qa;
	input done_qa;
	input done_meowth_HP;
	input done_pikachu_HP;
	input done_team_rocket;
	input done_trainer;
	
	input quick_attack;
	
	output reg enable_draw_pika;
	output reg enable_animate;
	output reg enable_p_qa;
	output reg enable_draw_meowth_HP;
	output reg enable_draw_pikachu_HP;
	output reg enable_draw_team_rocket;
	output reg enable_draw_trainer;
	
	output reg [3:0]choose_colour;
	output reg [3:0]choose_x_mode;
	output reg [3:0]choose_y_mode;
	
	output reg reset_all; //tells datapath to reset all
	output reg plot;
	
	reg [4:0] presentstate;
	reg [4:0] nextstate;
	
	//p_qa = pikachu quick attack
	parameter [4:0] reset_state = 5'b00000,
						 draw_pikachu = 5'b00001, 
						 draw_hp_meowth = 5'b00010, 
						 draw_hp_pikachu = 5'b00011,
						 draw_team_rocket = 5'b00100,
						 draw_trainer = 5'b00101,
						 draw_pikachu_qa = 5'b00110,
						 idle_p_qa = 5'b00111,
						 erase_pikachu_qa = 5'b01000,
						 p_qa = 5'b01001,
						 idle = 5'b01010;
	
	always @(*)
	case(presentstate)
		reset_state:
			begin
				nextstate <= draw_pikachu;
			end
		//DRAW BATTLE SCENE
		draw_pikachu:
			begin
				if(done_pikachu_qa == 1)
					nextstate <= draw_hp_meowth;
				else
					nextstate <= draw_pikachu;
			end
		draw_hp_meowth:
			begin
				if(done_meowth_HP == 1)
					nextstate <= draw_hp_pikachu;
				else
					nextstate <= draw_hp_meowth;
			end
		draw_hp_pikachu:
			begin
				if(done_pikachu_HP == 1) //done_pikachu_HP == 1
					nextstate <= draw_team_rocket;
				else
					nextstate <= draw_hp_pikachu;
			end
		draw_team_rocket:
			begin
				if(done_team_rocket == 1)
					nextstate <= draw_trainer;
				else
					nextstate <= draw_team_rocket;
			end
		draw_trainer:
			begin
				if(done_trainer == 1)
					nextstate = idle;
				else
					nextstate = draw_trainer;
			end
		//QUICK ATTACK LOOP##################################################################
		draw_pikachu_qa:
			begin
				if(done_pikachu_qa == 1)
					nextstate <= idle_p_qa;
				else
					nextstate <= draw_pikachu_qa;
			end
		idle_p_qa: 
			begin
				if(done_qa == 1)
					nextstate <= idle;
				else if(done_animate_qa == 1)
					nextstate <= erase_pikachu_qa;
				else
					nextstate <= idle_p_qa;
			end
		erase_pikachu_qa:
			begin
				if(done_pikachu_qa == 1)
					nextstate <= p_qa;
				else
					nextstate <= erase_pikachu_qa;
			end
		p_qa:
			begin
				nextstate <= draw_pikachu_qa; //idle_p_qa
			end
		idle: // waits for something to happen
			begin
			if(quick_attack == 1)
				nextstate <= draw_pikachu_qa;
			else
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
				enable_draw_meowth_HP = 0;
				enable_draw_pikachu_HP = 0;
				enable_draw_team_rocket = 0;
				enable_draw_trainer = 0;
				choose_colour = 4'b0000;
				choose_x_mode = 4'b0000;
				choose_y_mode = 4'b0000;
				plot = 0;
			end
		//DRAWS THE BEGINNING####################################################
		draw_pikachu:
			begin
				reset_all = 1;
				enable_draw_pika = 1;
				enable_animate = 0;
				enable_p_qa = 0;
				enable_draw_meowth_HP = 0;
				enable_draw_pikachu_HP = 0;
				enable_draw_team_rocket = 0;
				enable_draw_trainer = 0;
				choose_colour = 4'b0000;
				choose_x_mode = 4'b0000;
				choose_y_mode = 4'b0000;
				plot = 1;
			end
		draw_hp_meowth:
			begin
				reset_all = 1;
				enable_draw_pika = 0;
				enable_animate = 0;
				enable_p_qa = 0;
				enable_draw_meowth_HP = 1;
				enable_draw_pikachu_HP = 0;
				enable_draw_team_rocket = 0;
				enable_draw_trainer = 0;
				choose_colour = 4'b0010;
				choose_x_mode = 4'b0001;
				choose_y_mode = 4'b0001;
				plot = 1;
			end
		draw_hp_pikachu:
			begin
				reset_all = 1;
				enable_draw_pika = 0;
				enable_animate = 0;
				enable_p_qa = 0;
				enable_draw_meowth_HP = 0;
				enable_draw_pikachu_HP = 1;
				enable_draw_team_rocket = 0;
				enable_draw_trainer = 0;
				choose_colour = 4'b0011;
				choose_x_mode = 4'b0010;
				choose_y_mode = 4'b0010;
				plot = 1;
			end
		draw_team_rocket:
			begin
				reset_all = 1;
				enable_draw_pika = 0;
				enable_animate = 0;
				enable_p_qa = 0;
				enable_draw_meowth_HP = 0;
				enable_draw_pikachu_HP = 0;
				enable_draw_team_rocket = 1;
				enable_draw_trainer = 0;
				choose_colour = 4'b0100;
				choose_x_mode = 4'b0011;
				choose_y_mode = 4'b0011;
				plot = 1;
			end
		draw_trainer:
			begin
				reset_all = 1;
				enable_draw_pika = 0;
				enable_animate = 0;
				enable_p_qa = 0;
				enable_draw_meowth_HP = 0;
				enable_draw_pikachu_HP = 0;
				enable_draw_team_rocket = 0;
				enable_draw_trainer = 1;
				choose_colour = 4'b0101;
				choose_x_mode = 4'b0100;
				choose_y_mode = 4'b0100;
				plot = 1;
			end
		//QUICK ATTACK LOOP##################################################################
		draw_pikachu_qa:
			begin
				reset_all = 1;
				enable_draw_pika = 1;
				enable_animate = 0;
				enable_p_qa = 0;
				enable_draw_meowth_HP = 0;
				enable_draw_pikachu_HP = 0;
				enable_draw_team_rocket = 0;
				enable_draw_trainer = 0;
				choose_colour = 4'b0000;
				choose_x_mode = 4'b0000;
				choose_y_mode = 4'b0000;
				plot = 1;
			end
		idle_p_qa: 
			begin
				reset_all = 1;
				enable_draw_pika = 0;
				enable_animate = 1;
				enable_p_qa = 0;
				enable_draw_meowth_HP = 0;
				enable_draw_pikachu_HP = 0;
				enable_draw_team_rocket = 0;
				enable_draw_trainer = 0;
				choose_colour = 4'b0000;
				choose_x_mode = 4'b0000;
				choose_y_mode = 4'b0000;
				plot = 0;
			end
		erase_pikachu_qa:
			begin
				reset_all = 1;
				enable_draw_pika = 1;
				enable_animate = 0;
				enable_p_qa = 0;
				enable_draw_meowth_HP = 0;
				enable_draw_pikachu_HP = 0;
				enable_draw_team_rocket = 0;
				enable_draw_trainer = 0;
				choose_colour = 4'b0001;
				choose_x_mode = 4'b0000;
				choose_y_mode = 4'b0000;
				plot = 1;
			end
		p_qa:
			begin
				reset_all = 1;
				enable_draw_pika = 0;
				enable_animate = 0;
				enable_p_qa = 1;
				enable_draw_meowth_HP = 0;
				enable_draw_pikachu_HP = 0;
				enable_draw_team_rocket = 0;
				enable_draw_trainer = 0;
				choose_colour = 4'b0000;
				choose_x_mode = 4'b0000;
				choose_y_mode = 4'b0000;
				plot = 0;
			end
		idle:
			begin
				reset_all = 1;
				enable_draw_pika = 0;
				enable_animate = 0;
				enable_p_qa = 0;
				enable_draw_meowth_HP = 0;
				enable_draw_pikachu_HP = 0;
				enable_draw_team_rocket = 0;
				enable_draw_trainer = 0;
				choose_colour = 4'b0000;
				choose_x_mode = 4'b0000;
				choose_y_mode = 4'b0000;
				plot = 0;
			end
	endcase
	
endmodule

//DATAPATH
module datapath(clock,
					 reset_all,
					 enable_draw_pika,
					 enable_animate,
					 enable_p_qa,
					 enable_draw_meowth_HP,
					 enable_draw_pikachu_HP,
					 enable_draw_team_rocket,
					 enable_draw_trainer,
					 choose_colour,
					 choose_x_mode, 
					 choose_y_mode, ,
					 done_pikachu_qa,
					 done_animate_qa,
					 done_qa,
					 done_meowth_HP,
					 done_pikachu_HP,
					 done_team_rocket,
					 done_trainer,
					 out_x, 
					 out_y,
					 out_colour);
					 
	input clock;
	input reset_all;
	
	input enable_draw_pika;
	input enable_animate;
	input enable_p_qa;
	input enable_draw_meowth_HP;
	input enable_draw_pikachu_HP;
	input enable_draw_team_rocket;
	input enable_draw_trainer;
	
	input [3:0]choose_colour;//change the size of this as we add more modules
	input [3:0]choose_x_mode;//change the size of this as we add more modules
	input [3:0]choose_y_mode;//change the size of this as we add more modules
	
	output done_pikachu_qa;
	output done_animate_qa;
	output done_qa;
	output done_meowth_HP;
	output done_pikachu_HP;
	output done_team_rocket;
	output done_trainer;
	
	output [8:0]out_x;
	output [7:0]out_y;
	output [2:0]out_colour;
	
	wire [8:0]draw_pika_x;
	wire [7:0]draw_pika_y;
	wire [2:0]draw_pika_colour;
	
	wire [8:0]draw_meowth_HP_x;
	wire [7:0]draw_meowth_HP_y;
	wire [2:0]draw_meowth_HP_colour;
	
	wire [8:0]draw_pikachu_HP_x;
	wire [7:0]draw_pikachu_HP_y;
	wire [2:0]draw_pikachu_HP_colour;
	
	wire [8:0]draw_team_rocket_x;
	wire [7:0]draw_team_rocket_y;
	wire [2:0]draw_team_rocket_colour;
	
	wire [8:0]draw_trainer_x;
	wire [7:0]draw_trainer_y;
	wire [2:0]draw_trainer_colour;
	
	wire p_qa_right;
	
	quick_attack attack_one(.clock(clock), 
									.reset_all(reset_all), 
									.enable_animate(enable_animate), 
									.enable_p_qa(enable_p_qa), 
									.enable_draw_pika(enable_draw_pika), //remember that this module will also draw pikachu from the very beggining
									.done_animate(done_animate_qa), 
									.done_pikachu(done_pikachu_qa),
									.p_qa_x(draw_pika_x), 
									.p_qa_y(draw_pika_y), 
									.p_qa_colour(draw_pika_colour),
									.done_quick_attack(done_qa));
	
	//draws the static pictures									  
	drawHP meowth_HP(.x_(9'b000000000),
						  .y_(8'b00000000),
						  .clock_all(clock), 
						  .enable_all(enable_draw_meowth_HP), 
						  .reset_all(reset_all), 
						  .done(done_meowth_HP),
						  .out_x(draw_meowth_HP_x), 
						  .out_y(draw_meowth_HP_y), 
					     .out_colour(draw_meowth_HP_colour));
						  
	drawHP pikachu_HP(.x_(9'b010110100), // 179 - 010110100
							.y_(8'b01110111), // 115 - 01110111
						   .clock_all(clock), 
						   .enable_all(enable_draw_pikachu_HP), 
						   .reset_all(reset_all), 
						   .done(done_pikachu_HP),
						   .out_x(draw_pikachu_HP_x), 
						   .out_y(draw_pikachu_HP_y), 
					      .out_colour(draw_pikachu_HP_colour));
	
	//70x71
	drawTeamRocket team_rocket(.x_(9'b011111000), // 254 - 011111000
										.y_(8'b00101000), // 45 -  00101000
										.clock_all(clock), 
										.enable_all(enable_draw_team_rocket),
										.reset_all(reset_all),
										.done(done_team_rocket),
										.out_x(draw_team_rocket_x),
										.out_y(draw_team_rocket_y),
										.out_colour(draw_team_rocket_colour));
	
	//63x59
	drawTrainer trainer(.x_(9'b000001010), // 10
							  .y_(8'b10101010), // 170
							  .clock_all(clock), 
							  .enable_all(enable_draw_trainer),
							  .reset_all(reset_all),
							  .done(done_trainer),
							  .out_x(draw_trainer_x),
							  .out_y(draw_trainer_y),
							  .out_colour(draw_trainer_colour));										
	
	choose_y y(.in1(draw_pika_y), // 0000
				  .in2(draw_meowth_HP_y), // 0001
				  .in3(draw_pikachu_HP_y), // 0010
				  .in4(draw_team_rocket_y), // 0011
				  .in5(draw_trainer_y), //0100
				  .choose(choose_y_mode), 
				  .out_y(out_y)); // output y
				  
	choose_x x(.in1(draw_pika_x), // 0000
				  .in2(draw_meowth_HP_x), // 0001
				  .in3(draw_pikachu_HP_x), // 0010
				  .in4(draw_team_rocket_x), // 0011
				  .in5(draw_trainer_x), //0100
				  .choose(choose_x_mode), 
				  .out_x(out_x)); // output x
				  
	choose_c colour(.in1(draw_pika_colour), //colour for drawing pikachu 0000
					    .in2(3'b111), //colour for erasing pikachu 0001
						 .in3(draw_meowth_HP_colour), //colour for meowth_HP 0010 
						 .in4(draw_pikachu_HP_colour), //colour for meowth_HP 0011
						 .in5(draw_team_rocket_colour), //0100
						 .in6(draw_trainer_colour), // 0101
					    .choose(choose_colour),
					    .out(out_colour));	 
endmodule

//ANIMATION_TIMER
module animation_frame(clock,
							  reset,	
							  enable, 
							  out_pulse);
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
module choose_y(in1, in2, in3, in4, in5, choose, out_y); //we will add more stuff later
	input [7:0]in1;
	input [7:0]in2;
	input [7:0]in3;
	input [7:0]in4;
	input [7:0]in5;
	input [3:0]choose;
	
	output reg [7:0]out_y;
	
	always @(*)
		case(choose)
			4'b0000: out_y = in1;
			4'b0001: out_y = in2;
			4'b0010: out_y = in3;
			4'b0011: out_y = in4;
			4'b0100: out_y = in5;
			default out_y = in1;
		endcase
endmodule

//X MUX
module choose_x(in1, in2, in3, in4, in5, choose, out_x); //we will add more stuff later
	input [8:0]in1;
	input [8:0]in2;
	input [8:0]in3;
	input [8:0]in4;
	input [8:0]in5;
	input [3:0]choose;
	
	output reg [8:0]out_x;
	
	always @(*)
		case(choose)
			4'b0000: out_x = in1;
			4'b0001: out_x = in2;
			4'b0010: out_x = in3;
			4'b0011: out_x = in4;
			4'b0100: out_x = in5;
			default out_x = in1;
		endcase
endmodule

//COLOUR MUX
module choose_c(in1, in2, in3, in4, in5, in6, choose, out);//we will make this bigger as we add more characters
	input [2:0]in1;
	input [2:0]in2;
	input [2:0]in3;
	input [2:0]in4;
	input [2:0]in5;
	input [2:0]in6;
	input [3:0]choose;
	
	output reg [2:0]out;
	
	always @(choose)
		case(choose)
			4'b0000: out = in1;
			4'b0001: out = in2;
			4'b0010: out = in3;
			4'b0011: out = in4;
			4'b0100: out = in5;
			4'b0101: out = in6;
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