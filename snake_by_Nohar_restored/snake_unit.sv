module snake_unit (
	input					clk,
	input					resetN,
	input		[31:0]	pxl_x,
	input		[31:0]	pxl_y,
	input					up,
	input					down,
	input					right,
	input					left,
	output	[3:0]		Red,
	output	[3:0]		Green,
	output	[3:0]		Blue,
	output				endgame,
	output				Draw
);
	
	
	wire	[31:0]	topLeft_x_snake;
	wire	[31:0]	topLeft_y_snake;
	
	Move_snake move_inst(
	.clk(clk),
	.resetN(resetN),
	.up(up),
	.down(down),
	.right(right),
	.left(left),
	.topLeft_x(topLeft_x_snake),
	.topLeft_y(topLeft_y_snake),
	.snake_direction(snake_head_direction),
	.endgame(endgame)
	);
	
	
	Draw_snake snake_drawer_inst(
	.clk(clk),
	.resetN(resetN),
	.pxl_x(pxl_x),
	.pxl_y(pxl_y),
	.topLeft_x(topLeft_x_snake),
	.topLeft_y(topLeft_y_snake),
	.width(32'd32),
	.hight(32'd32),
	.snake_direction(snake_head_direction),
	.Red_level(Red),
	.Green_level(Green),
	.Blue_level(Blue),
	.Drawing(Draw)
	);
	

endmodule	