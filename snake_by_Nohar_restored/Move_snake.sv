module Move_snake(
	input						clk,
	input						resetN,
	input						collision,
	input						up,
	input						down,
	input						right,
	input						left,
	output reg	[31:0]	topLeft_x,
	output reg	[31:0]	topLeft_y,
	output		[3:0]		snake_direction,
	output reg				endgame
	);
	
	localparam [31:0]	x_init = 32'd32;
	localparam [31:0]	y_init = 32'd32;
	localparam [31:0]	divider = 32'd125_000;
	localparam [31:0]	action_divider = 8'd31;
	
	integer y_speed = 1;
	integer x_speed = 1;
	integer x_border = 5;
	integer y_border = 5;
	
	
	reg [31:0] 		y_temp;
	reg [31:0]		x_temp;
	reg [31:0]		counter;
	reg [8:0]		action__counter;
	
	
	assign topLeft_x = x_temp;
	assign topLeft_y = y_temp;

	always @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			x_temp <= x_init;
			y_temp <= y_init;
			endgame <= 0;
			snake_direction <= 4'b0000;
			counter <= 0;
		end
		else begin
			counter <= counter + 1;
			if	(action__counter > action_divider)	begin
				action__counter <= 0;
				if(up && snake_direction != 4'b0100)
					snake_direction <= 4'b1000;
				if(down && snake_direction != 4'b1000)
					snake_direction <= 4'b0100;
				if(right && snake_direction != 4'b0001)
					snake_direction <= 4'b0010;
				if(left && snake_direction != 4'b0010)
					snake_direction <= 4'b0001;
			end
			if	(counter > divider)	begin	
				action__counter <= action__counter+1;
				counter <= 0;
				case(snake_direction)	
					4'b1000: //up
						y_temp <= y_temp - y_speed;
					4'b0100: //down
						y_temp <= y_temp + y_speed;
					4'b0010: //right
						x_temp <= x_temp + x_speed;
					4'b0001: //left
						x_temp <= x_temp - x_speed;
				endcase
			end
			
			if(x_temp <= x_border || x_temp + x_speed >= 640-x_border-32)
				endgame <= 1;
				
			if(y_temp + y_speed <= y_border || y_temp + y_speed >= 480-y_border-32)
				endgame <= 1;	
		end
	end // always
endmodule	