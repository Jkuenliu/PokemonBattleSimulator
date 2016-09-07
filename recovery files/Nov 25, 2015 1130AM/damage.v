module damage(in,
				  clock,
				  reset,
				  enable_HP_calc,
				  enable_DMG_reg, 
				  enable_DMG_calc,
				  enable_draw_decrease,
				  enable_decrement_control,
				  done_damage,
				  done_decrement,
				  game_over,
				  out_x,
				  out_y);
	
	input [2:0]in;
	input clock;
	input reset;
	
	input enable_DMG_calc;
	input enable_DMG_reg;
	input enable_HP_calc;
	input enable_draw_decrease;
	input enable_decrement_control;
	
	output done_damage;
	output done_decrement;
	output game_over;
	
	output [8:0]out_x;
	output [7:0]out_y;
	
	//the DMG wires are here just to transfer the DMG information between the different modules
	wire [8:0]DMG_dealing;
	wire [8:0]HP_left;
	wire [8:0]HP_input;
	wire [8:0]x_decrement;
	
	out_DMG DMG(.in(in), 
					.enable_DMG_reg(enable_DMG_reg), 
					.clock(clock), 
					.DMG_dealing(DMG_dealing));
					
	HP_calc HP(.in(HP_left), 
				  .enable(enable_HP_calc),
				  .reset(reset),
				  .clock(clock),
				  .out(HP_input));
				  
	DMG_calculator d_calc(.current_HP(HP_input),
								 .DMG(DMG_dealing), // takes the dmg dealing and checks if end game
								 .enable(enable_DMG_calc),
								 .reset(reset),
								 .clock(clock),
								 .game_over(game_over),
								 .DMG_dealt(HP_left)); // HP_left will help us determine how many white spaces to print
	
	decrement_control d_control(.in(HP_left), 
										 .x_position(x_decrement),
										 .clock(clock),
										 .reset(reset),
										 .enable(enable_decrement_control),
										 .done_decrement(done_decrement),
										 .out_x(x_decrement));				 
					 
	drawWhite white(.x_(x_decrement), 
						 .y_(8'b00000000),
						 .clock_all(clock), 
						 .enable_all(enable_draw_decrease),
						 .reset_all(reset),
						 .done(done_damage),
						 .out_x(out_x),
						 .out_y(out_y));	 
endmodule

//DECREMENT CONTROL
module decrement_control(in, x_position, clock, reset, enable, done_decrement, out_x);
	input [8:0]in;
	input [8:0]x_position;
	input clock;
	input reset;
	input enable;
	
	reg [8:0]default_x_position = 9'b001111011;
	
	output reg done_decrement;
	output reg [8:0]out_x;
	
	always @(posedge clock)
	begin
		if(reset == 0)
		begin
			out_x <= default_x_position; //123 - 9'b001111011
			done_decrement <= 0;
		end
		else if(enable == 1)
			begin
				if(x_position > in + 9'b000101010) // 42
					out_x = out_x - 9'b000000001;
				else if(x_position == in + 9'b000101010)
					done_decrement = 1;
			end
		else if(enable == 0)
			begin
				done_decrement = 0;
			end
	end
	
endmodule

//DMG_CALC
module DMG_calculator(current_HP, DMG, enable, reset, clock, game_over, DMG_dealt);
	input [8:0]current_HP;
	input [8:0]DMG;
	input clock;
	input enable;
	input reset;
	
	output reg game_over;
	output reg [8:0]DMG_dealt;
	
	always @(posedge clock)
	begin
		if(reset == 0)
			begin
				game_over <= 0;
				DMG_dealt <= 9'b001010010; //82;
			end
		else if(enable == 1 && DMG >= current_HP)
			begin
				game_over <= 1;
				DMG_dealt <= 9'b000000000;
			end
		else if(enable == 1 && DMG < current_HP)
			begin
				game_over <= 0;
				DMG_dealt <= current_HP - DMG;
			end
		else if(enable == 0)
			begin
				DMG_dealt <= DMG_dealt;
			end
	end
endmodule

//remember that in any damage loop your enable for your DMG_reg must be high at some point or else you'll have timing problems
module out_DMG(in, enable_DMG_reg, clock, DMG_dealing);
	
	input [2:0]in; // 000 - nothing, 001 - qa, 010 - thunderbolt, 100 - volt tackle
	input clock;
	input enable_DMG_reg;
	
	output [8:0]DMG_dealing;
	
	wire [8:0]DMG_to_deal;
	wire [1:0]choose_DMG_amount;

	DMG_chooser choose_DMG(.in(in),
								  .out(choose_DMG_amount));

	DMG_reg DMG(.in(DMG_to_deal), 
					.enable(enable_DMG_reg),
					.clock(clock),
					.out(DMG_dealing));
					
	DMG_LUT lut(.choose(choose_DMG_amount), 
					.out(DMG_to_deal));
endmodule

//HP_CALC
module HP_calc(in, enable, reset, clock, out);
	input clock;
	input [8:0]in;
	input enable;
	input reset;
	
	output [8:0]out;
	
	reg [8:0]current_HP;
	
	//this will store a 7 bit number 82 - 01010010
	
	assign out = current_HP;
	
	always @(posedge clock)
	begin
		if(reset == 0)
			current_HP <= 9'b001010010; // change back to 9'b001010010
		else if(reset == 1 && enable == 1)
			current_HP <= in;
		else if(reset == 1 && enable == 0)
			current_HP <= current_HP;
	end
endmodule

//DMG_REG
module DMG_reg(in, enable, clock, out);
	input [8:0]in;
	input enable;
	input clock;
	
	output reg [8:0]out;
	
	always @(posedge clock)
	begin
		if(enable == 1)
			out <= in;
		else
			out <= out;
	end
endmodule

//DMG_LUT
module DMG_LUT(choose, out);
	input [1:0]choose;
	output reg [8:0]out; // although we are only dealing with numbers that are less than 7 bits we want to pad
	
	always @(*)
		case(choose)
			2'b00: out = 9'b000000000;
			2'b01: out = 9'b000001010; // 10 - 0001010 quick attack
			2'b10: out = 9'b000001111; // 15 - 0001111 thunderbolt
			2'b11: out = 9'b000010100; // 20 - 0010100 volt tackle
			default out = 9'b000000000;
		endcase
endmodule

//DMG_CHOOSER
module DMG_chooser(in, out); //qa - quick attack, vt - volt tackle, tb - thunderbolt
	input [2:0]in;
	
	output reg [1:0]out;
	
	always @(*)
		case(in)
			3'b000: out = 2'b00; // nothing
			3'b001: out = 2'b01; // quick attack
			3'b010: out = 2'b10; // thunderbolt
			3'b100: out = 2'b11; // volt tackle
			default out = 2'b00;
		endcase
endmodule