module Apple_unit (

	input clk,
	input resetN,
	input collision,
	input		[31:0]	pxl_x,
	input		[31:0]	pxl_y,
	output	[3:0]		Red,
	output	[3:0]		Green,
	output	[3:0]		Blue,
	output   [15:0] score,
	output	Draw);
	
	wire [31:0]	topLeft_x_apple;
	wire [31:0]	topLeft_y_apple;
	
	
	Place_Apple apple_placer_inst1(
	.clk(clk),
	.resetN(resetN),
	.collision(collision),
	.top_left_x(topLeft_x_apple),
	.top_left_y(topLeft_y_apple),
	.score(score)
	);
	
	
	draw_apple apple_drawer_inst1(
	.clk(clk),
	.resetN(resetN),
	.pxl_x(pxl_x),
	.pxl_y(pxl_y),
	.topLeft_x(topLeft_x_apple),
	.topLeft_y(topLeft_y_apple),
	.width(32'd32),
	.hight(32'd32),
	.Red_level(Red),
	.Green_level(Green),
	.Blue_level(Blue),
	.Drawing(Draw)
	);

endmodule	