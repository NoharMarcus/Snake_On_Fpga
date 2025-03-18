module draw_apple (
	input 				clk,
	input 				resetN,
	input 	[31:0] 	pxl_x,
	input 	[31:0] 	pxl_y,
	input 	[31:0] 	topLeft_x,
	input 	[31:0] 	topLeft_y,
	input		[31:0]	width,
	input		[31:0]	hight,
	output	[3:0]		Red_level,
	output	[3:0]		Green_level,
	output	[3:0]		Blue_level,
	output 				Drawing
	);
	
	localparam TANSPERENT = 12'hFFF;// RGB value in the bitmap representing a transparent pixel
	
	wire	[31:0]	in_rectangle; 
	wire	[31:0]	offset_x;
	wire	[31:0]	offset_y;
	
	reg [0:31][0:31][11:0] Bitmap = {
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'heee , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'heee , 12'heed , 12'h8a1 , 12'h7a2 , 12'h592 , 12'h582 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'heee , 12'h520 , 12'hfff , 12'hfff , 12'hfff , 12'heee , 12'h8a2 , 12'h8a2 , 12'h592 , 12'h582 , 12'h592 , 12'h582 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'heff , 12'hc73 , 12'h521 , 12'heee , 12'hfff , 12'heef , 12'h8a2 , 12'h8a1 , 12'h592 , 12'h352 , 12'h592 , 12'h373 , 12'h383 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hba9 , 12'h631 , 12'h520 , 12'heee , 12'h9b4 , 12'h672 , 12'h593 , 12'h341 , 12'h242 , 12'h252 , 12'h373 , 12'h272 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'h975 , 12'h521 , 12'heee , 12'h8a1 , 12'h592 , 12'h352 , 12'h372 , 12'h383 , 12'h383 , 12'h383 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'heff , 12'h631 , 12'h420 , 12'hddb , 12'h342 , 12'h383 , 12'h383 , 12'h383 , 12'h383 , 12'heee , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'heee , 12'h420 , 12'hddc , 12'h592 , 12'h383 , 12'h272 , 12'heee , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'heff , 12'hfff , 12'heef , 12'h631 , 12'heee , 12'hfff , 12'heff , 12'heff , 12'hfff , 12'hfff , 12'hfef , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hefe , 12'he89 , 12'hd11 , 12'hd23 , 12'hd11 , 12'hd22 , 12'hd11 , 12'hd11 , 12'h631 , 12'hd23 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd12 , 12'hd11 , 12'hd11 , 12'hd88 , 12'heee , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'heee , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd22 , 12'hd11 , 12'hc11 , 12'ha11 , 12'hb11 , 12'hc22 , 12'hd33 , 12'hc22 , 12'hb11 , 12'hb11 , 12'hd11 , 12'hd33 , 12'hd11 , 12'hc11 , 12'ha11 , 12'heed , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hecc , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hb11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'hdcc , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfee , 12'hd11 , 12'hd22 , 12'hd22 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'heee , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hd11 , 12'hd12 , 12'hd44 , 12'hd44 , 12'hd22 , 12'hd12 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hd11 , 12'hd44 , 12'hd44 , 12'hd44 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd12 , 12'hd22 , 12'hd22 , 12'hd11 , 12'hd11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'h811 , 12'ha11 , 12'ha11 , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hd11 , 12'hd44 , 12'hd44 , 12'hd44 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'h711 , 12'h811 , 12'h711 , 12'ha11 , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'heee , 12'hd11 , 12'hd44 , 12'hd44 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'h811 , 12'h811 , 12'h811 , 12'ha11 , 12'heee , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'heee , 12'hd11 , 12'hd44 , 12'hd34 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'h811 , 12'h811 , 12'h811 , 12'ha11 , 12'heee , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'heee , 12'hd11 , 12'hd44 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'h811 , 12'h811 , 12'h811 , 12'h911 , 12'heee , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hd11 , 12'hd44 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'h911 , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hd11 , 12'hd44 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'h911 , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hd11 , 12'hd11 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd11 , 12'hb11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'ha11 , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'heed , 12'hd11 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'heed , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hefe , 12'hd11 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'hefe , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hd11 , 12'hd11 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'heee , 12'hd11 , 12'hd11 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd11 , 12'hb11 , 12'ha11 , 12'ha11 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'heee , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'he88 , 12'hd11 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd11 , 12'hd11 , 12'ha11 , 12'ha11 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'hb88 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'heef , 12'hd11 , 12'hd11 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd22 , 12'hd12 , 12'hd11 , 12'hc11 , 12'ha11 , 12'ha11 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'heee , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'he11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'hd11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'h711 , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'heee , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'ha11 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'h811 , 12'heee , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'heee , 12'h811 , 12'h811 , 12'h811 , 12'hdbb , 12'heee , 12'heee , 12'heef , 12'hfee , 12'hdcb , 12'h811 , 12'h811 , 12'h811 , 12'heee , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	{ 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff , 12'hfff },
	};
	
	assign in_rectangle = (pxl_x >= topLeft_x) && (pxl_x <= topLeft_x+width) && (pxl_y >= topLeft_y) && (pxl_y <= topLeft_y+hight);
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
				if(Bitmap[offset_y][offset_x] != TANSPERENT) begin
						Drawing <= 1;
						Red_level <= Bitmap[offset_y][offset_x] [11:8];
						Green_level <= Bitmap[offset_y][offset_x] [7:4];
						Blue_level <= Bitmap[offset_y][offset_x] [3:0];
				end
			end
		end
	end
endmodule	