module damage_meowth(clock,
						   reset,
						   enable_HP_calc,
						   enable_DMG_calc,
						   enable_draw_decrease,
						   enable_decrement_control,
						   done_damage,
						   done_decrement,
						   game_over,
						   out_x,
						   out_y);
							
	input clock;
	input reset;
	input enable_HP_calc;
	input enable_DMG_calc;
	input enable_draw_decrease;
	input enable_decrement_control;
	
	output done_damage;
	output done_decrement;
	output game_over;
	output [8:0]out_x;
	output [7:0]out_y;
	
	wire [8:0]HP_left;
	wire [8:0]HP_input;
	wire [8:0]x_decrement;
	
	HP_calc HP(.in(HP_left), 
				  .enable(enable_HP_calc),
				  .reset(reset),
				  .clock(clock),
				  .out(HP_input));
	
	DMG_calculator d_calc(.current_HP(HP_input),
								 .DMG(9'b000001100), // will be a constant 12
								 .enable(enable_DMG_calc),
								 .reset(reset),
								 .clock(clock),
								 .game_over(game_over),
								 .DMG_dealt(HP_left)); // HP_left will help us determine how many white spaces to print
	
	decrement_control d_control(.in(HP_left), 
										 .default_x_position(9'b100101111),	//default x position
										 .x_position(x_decrement),
										 .clock(clock),
										 .reset(reset),
										 .enable(enable_decrement_control),
										 .done_decrement(done_decrement),
										 .out_x(x_decrement));	
	
	drawWhite white(.x_(x_decrement), 
						 .y_(8'b01110111), // default y position
						 .clock_all(clock), 
						 .enable_all(enable_draw_decrease),
						 .reset_all(reset),
						 .done(done_damage),
						 .out_x(out_x),
						 .out_y(out_y));	
	
endmodule

