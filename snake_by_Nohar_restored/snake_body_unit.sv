module snake_body_unit (
	input					clk,
	input					resetN,
	input					apple_eaten,
	input		[31:0]	pxl_x,
	input		[31:0]	pxl_y,
	input					Draw_snake,
	output reg			gameover,	
	output reg			Draw
);

localparam [31:0]	x_init = 32'd32;
localparam [31:0]	y_init = 32'd32;

reg [19:0][14:0][7:0] Bitmap ;
byte						 tail_length;

	always @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			Bitmap <= 0;
			Draw <= 1'b0;
			tail_length <= 0;
			gameover <= 0;
		end
		else begin	
			if (Draw_snake == 1'b1 && Bitmap[pxl_x[31:5]][pxl_y[31:5]][7:0] == 8'h00) begin
				Bitmap[pxl_x[31:5]][pxl_y[31:5]][7:0] <= tail_length;
				Draw <= 1'b0;
				for(int x = 0 ;x <= 19 ; x++)
					for(int y = 0; y<= 14; y++)
						if(Bitmap[x][y] > 0)
							Bitmap[x][y] <= Bitmap[x][y] - 1;
			end
			
			else begin
				if( Bitmap[pxl_x[31:5]][pxl_y[31:5]][7:0] > 0 && Bitmap[pxl_x[31:5]][pxl_y[31:5]][7:0] < tail_length) begin
					Draw <= 1'b1;
					if(Draw_snake == 1'b1)
						gameover <= 0; // logic to indicate snake head colided with body part 
						
				end
				else begin
					Draw <= 1'b0;
				end
			end
			
			if(apple_eaten == 1) begin
				tail_length <= tail_length +1;
			end
		end
	end
endmodule	