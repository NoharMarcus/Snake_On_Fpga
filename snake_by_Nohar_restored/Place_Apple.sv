module Place_Apple (
	input clk,
	input resetN,
	input collision,
	output reg [31:0] top_left_x,
	output reg [31:0] top_left_y,
	output reg [15:0] score
	);
	// global parameter
	parameter offSet_y = 0, offset_x = 0 ; // parameter to detrmine theoffsetof the object from edge of screen
	reg [9:0] counter_x;
	reg [9:0] counter_y;
	wire pre_collision;
	// local parameters
	localparam size_x = 32, size_y =32; //  define thr size of the object (in pixels)
	localparam min_x = 0 , max_x = 640 - size_x; //actual drawing limits for the object in horizontal direction
	localparam min_y = 0 , max_y = 480 - size_y; // actual drawing limits for the object in vertical direction
	
	always @(posedge clk or negedge resetN) begin
		if(resetN == 1'b0) begin
			top_left_x <= 32'd120;
			top_left_y <= 32'd100;
			counter_x <= 0;
			counter_y <=0;
			score <= 0;
		end
		else begin
			if(collision == 1'b1 & pre_collision == 1'b0 ) begin
				top_left_x <=  counter_x;
				top_left_y <= counter_y;
				score <= score +1;
			end
			if (counter_x > max_x)
				counter_x <= 0;
			else 
				counter_x <= counter_x + 1;
				
			if (counter_y > max_y)
				counter_y <= 0;				
			else 
				counter_y <= counter_y + 1;
			pre_collision <= collision;
		end
	end
		
endmodule 