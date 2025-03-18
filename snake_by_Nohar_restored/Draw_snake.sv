module Draw_snake(
	input					clk,
	input					resetN,
	input		[31:0]	pxl_x,
	input		[31:0]	pxl_y,
	input		[31:0]	topLeft_x,
	input		[31:0]	topLeft_y,
	input		[31:0]	width,
	input		[31:0]	hight,
	input		[3:0]		snake_direction,
	output	[3:0]		Red_level,
	output	[3:0]		Green_level,
	output	[3:0]		Blue_level,
	output				Drawing
	
	);

localparam TANSPERENT = 12'hFFF;// RGB value in the bitmap representing a transparent pixel
	
	wire	[31:0]	in_rectangle; 
	wire	[31:0]	offset_x;
	wire	[31:0]	offset_y;
	
	reg [0:31][0:31][11:0] Bitmap = {
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h251 , 12'h4a3 , 12'h4a3 , 12'h251 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h382 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h372 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h382 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h372 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h251 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h251 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h251 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h251 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h372 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h382 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h372 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h4a3 , 12'h372 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h251 , 12'h4a3 , 12'h4a3 , 12'h251 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
};
	assign in_rectangle = (pxl_x >= topLeft_x) && (pxl_x <= topLeft_x+width ) && (pxl_y >= topLeft_y) && (pxl_y <= topLeft_y+hight);
	assign offset_x = pxl_x - topLeft_x;
	assign offset_y = pxl_y - topLeft_y;
		
	always @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			Drawing <= 0;
			Red_level <= 4'hF;
			Green_level <= 4'hF;
			Blue_level <= 4'hF;
		end
		else begin
			Drawing <= 0;
			if (in_rectangle) begin
				case(snake_direction)	
					4'b1000: begin
						if(Bitmap[offset_y][offset_x] != TANSPERENT) begin
							Drawing <= 1;
							Red_level <= Bitmap[offset_y][offset_x] [11:8];
							Green_level <= Bitmap[offset_y][offset_x] [7:4];
							Blue_level <= Bitmap[offset_y][offset_x] [3:0];
						end	
					end
					
					4'b0100: begin
						if(Bitmap[hight-offset_y +1][offset_x] != TANSPERENT) begin
							Drawing <= 1;
							Red_level <= Bitmap[offset_y][offset_x] [11:8];
							Green_level <= Bitmap[offset_y][offset_x] [7:4];
							Blue_level <= Bitmap[offset_y][offset_x] [3:0];
						end
					end
					
					4'b0010: begin
						if(Bitmap[hight-offset_y +1][offset_x] != TANSPERENT) begin
							Drawing <= 1;
							Red_level <= Bitmap[hight-offset_y +1][offset_x] [11:8];
							Green_level <= Bitmap[hight-offset_y +1][offset_x] [7:4];
							Blue_level <= Bitmap[hight-offset_y +1][offset_x] [3:0];
						end
					end
					
					4'b0001: begin
						if(Bitmap[offset_y][offset_x] != TANSPERENT) begin
							Drawing <= 1;
							Red_level <= Bitmap[offset_y][offset_x] [11:8];
							Green_level <= Bitmap[offset_y][offset_x] [7:4];
							Blue_level <= Bitmap[offset_y][offset_x] [3:0];
						end
					end
					
					4'b0000: begin
						if(Bitmap[offset_y][offset_x] != TANSPERENT) begin
							Drawing <= 1;
							Red_level <= Bitmap[offset_y][offset_x] [11:8];
							Green_level <= Bitmap[offset_y][offset_x] [7:4];
							Blue_level <= Bitmap[offset_y][offset_x] [3:0];
						end	
					end
				endcase
			end
		end
	end
endmodule	