module final_project(
input clk, start
);

parameter max_time=64;
parameter max_score=20;

reg time_count, score;
reg [0:3] graph_num, position;
reg is_start;
reg sound_type;

divfreq f(.clk(clk), .clk_div(clk_div));
play_sound play(.sound_type(sound_type));
show_LED led(.clk(clk), .graph_num(graph_num[(time_count/2)%4]), .position(position[(time_count/2)%4]));
show_time_and_score shw(.clk(clk), .time_count(time_count), .score(score));
keyboard_input key(.key_num(key_num));

assign is_end=(score>=max_score||time_count>=max_time);

//initial
always @(negedge start, posedge is_end) begin
	if(is_end)
		is_start<=1'b0;
	else begin
		is_start<=1'b1;
		score <= 2'd0;
	end
	end
//count time
always @(posedge clk_div) begin
	if(is_start)
		time_count <= time_count+1'b1;
	else
		time_count <= 16'b0;
	end
//show graph
always @(posedge clk_div) begin
	if(time_count%2==0) begin
		if(time_count==0)	graph_num[(time_count/2)%4]<=((time_count/2)+5)%9;
		else graph_num[(time_count/2)%4]<=(time_count*graph_num[((time_count/2)-1)%4]+5)%9;
		position[(time_count/2)%4]<=((time_count/2)%4);
	end
end
//detect input and play sound
always @(key_num,is_end) begin
	if(is_end)
		sound_type<=3;
	else if(key_num==0 && ((graph_num[(time_count/2-3)%4]==3 && position[(time_count/2-3)%4]==1) || (graph_num[(time_count/2-3)%4]==4 && position[(time_count/2-3)%4]==3) || (graph_num[(time_count/2-3)%4]==5 && position[(time_count/2-3)%4]==3) || (graph_num[(time_count/2-3)%4]==6 && position[(time_count/2-3)%4]==1)))
		sound_type<=1;
	else if(key_num==1 && ((graph_num[(time_count/2-3)%4]==0 && position[(time_count/2-3)%4]==3) || (graph_num[(time_count/2-3)%4]==1 && position[(time_count/2-3)%4]==2) || (graph_num[(time_count/2-3)%4]==2 && position[(time_count/2-3)%4]==1) || (graph_num[(time_count/2-3)%4]==7 && position[(time_count/2-3)%4]==0)))
		sound_type<=1;
	else if(key_num==2 && ((graph_num[(time_count/2-3)%4]==1 && position[(time_count/2-3)%4]==3) || (graph_num[(time_count/2-3)%4]==4 && position[(time_count/2-3)%4]==1) || (graph_num[(time_count/2-3)%4]==6 && position[(time_count/2-3)%4]==3) || (graph_num[(time_count/2-3)%4]==7 && position[(time_count/2-3)%4]==2) || (graph_num[(time_count/2-3)%4]==8 && position[(time_count/2-3)%4]==3)))
		sound_type<=1;
	else if(key_num==3 && ((graph_num[(time_count/2-3)%4]==0 && position[(time_count/2-3)%4]==0) || (graph_num[(time_count/2-3)%4]==3 && position[(time_count/2-3)%4]==2) || (graph_num[(time_count/2-3)%4]==5 && position[(time_count/2-3)%4]==0) || (graph_num[(time_count/2-3)%4]==5 && position[(time_count/2-3)%4]==1) || (graph_num[(time_count/2-3)%4]==7 && position[(time_count/2-3)%4]==3)))
		sound_type<=1;
	else if(key_num==4 && ((graph_num[(time_count/2-3)%4]==0 && position[(time_count/2-3)%4]==1) || (graph_num[(time_count/2-3)%4]==1 && position[(time_count/2-3)%4]==0) || (graph_num[(time_count/2-3)%4]==2 && position[(time_count/2-3)%4]==2) || (graph_num[(time_count/2-3)%4]==2 && position[(time_count/2-3)%4]==3) || (graph_num[(time_count/2-3)%4]==8 && position[(time_count/2-3)%4]==2)))
		sound_type<=1;
	else if(key_num==5 && ((graph_num[(time_count/2-3)%4]==1 && position[(time_count/2-3)%4]==1) || (graph_num[(time_count/2-3)%4]==3 && position[(time_count/2-3)%4]==3) || (graph_num[(time_count/2-3)%4]==4 && position[(time_count/2-3)%4]==2) || (graph_num[(time_count/2-3)%4]==6 && position[(time_count/2-3)%4]==0) || (graph_num[(time_count/2-3)%4]==7 && position[(time_count/2-3)%4]==1) || (graph_num[(time_count/2-3)%4]==8 && position[(time_count/2-3)%4]==1)))
		sound_type<=1;
	else if(key_num==6 && ((graph_num[(time_count/2-3)%4]==0 && position[(time_count/2-3)%4]==2) || (graph_num[(time_count/2-3)%4]==3 && position[(time_count/2-3)%4]==0) || (graph_num[(time_count/2-3)%4]==4 && position[(time_count/2-3)%4]==0) || (graph_num[(time_count/2-3)%4]==5 && position[(time_count/2-3)%4]==2) || (graph_num[(time_count/2-3)%4]==8 && position[(time_count/2-3)%4]==0)))
		sound_type<=1;
	else if(key_num==7 && ((graph_num[(time_count/2-3)%4]==2 && position[(time_count/2-3)%4]==0) || (graph_num[(time_count/2-3)%4]==6 && position[(time_count/2-3)%4]==2)))
		sound_type<=1;
	else
		sound_type<=2;
end

endmodule

module show_LED(
input clk, graph_num, position,
output [0:7] LED_R [0:7], LED_G [0:7], LED_B [0:7]);

always @(graph_num) begin
	case (graph_num)
		1'd0: 
			case (position)
				0: LED_R= {8'b10111111,
							  8'b00011111,
							  8'b10111111,
							  8'b10111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				1: LED_G= {8'b11111101,
							  8'b11111101,
							  8'b11111000,
							  8'b11111101,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				2: LED_B= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b10111111,
							  8'b00001111,
							  8'b10111111};
				3: LED_G= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111101,
							  8'b11110000,
							  8'b11111101};
			endcase
		1'd1:
			case (position)
				0: LED_R= {8'b10111111,
							  8'b10111111,
							  8'b00011111,
							  8'b10111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				1: LED_G= {8'b11111000,
							  8'b11111001,
							  8'b11111010,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				2: LED_B= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11011111,
							  8'b00001111,
							  8'b11011111};
				3: LED_G= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111010,
							  8'b11111100,
							  8'b11111000};
			endcase
		1'd2:
			case (position)
				0: LED_R= {8'b01011111,
							  8'b00111111,
							  8'b00011111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				1: LED_G= {8'b11111101,
							  8'b11110000,
							  8'b11111101,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				2: LED_B= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b10111111,
							  8'b10111111,
							  8'b00011111,
							  8'b10111111};
				3: LED_G= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111101,
							  8'b11111101,
							  8'b11111000,
							  8'b11111101};
			endcase
		1'd3:
			case (position)
				0: LED_R= {8'b10111111,
							  8'b00001111,
							  8'b10111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				1: LED_G= {8'b11111000,
							  8'b11111100,
							  8'b11111010,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				2: LED_B= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b10111111,
							  8'b00011111,
							  8'b10111111,
							  8'b10111111};
				3: LED_G= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111010,
							  8'b11111001,
							  8'b11111000};
			endcase
		1'd4:
			case (position)
				0: LED_R= {8'b10111111,
							  8'b00001111,
							  8'b10111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				1: LED_G= {8'b11111010,
							  8'b11111100,
							  8'b11111000,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				2: LED_B= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b00011111,
							  8'b00111111,
							  8'b01011111};
				3: LED_G= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111000,
							  8'b11111100,
							  8'b11111010};
			endcase
		1'd5:
			case (position)
				0: LED_R= {8'b10111111,
							  8'b00011111,
							  8'b10111111,
							  8'b10111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				1: LED_G= {8'b11111101,
							  8'b11111000,
							  8'b11111101,
							  8'b11111101,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				2: LED_B= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b10111111,
							  8'b00001111,
							  8'b10111111};
				3: LED_G= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111000,
							  8'b11111100,
							  8'b11111010};
			endcase
		1'd6:
			case (position)
				0: LED_R= {8'b00011111,
							  8'b00111111,
							  8'b01011111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				1: LED_G= {8'b11111000,
							  8'b11111100,
							  8'b11111010,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				2: LED_B= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b01011111,
							  8'b00111111,
							  8'b00011111};
				3: LED_G= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111010,
							  8'b11111100,
							  8'b11111000};
			endcase
		1'd7:
			case (position)
				0: LED_R= {8'b11011111,
							  8'b00001111,
							  8'b11011111,
							  8'b10111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				1: LED_G= {8'b11111000,
							  8'b11111001,
							  8'b11111010,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				2: LED_B= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b01011111,
							  8'b10011111,
							  8'b00011111};
				3: LED_G= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111101,
							  8'b11111000,
							  8'b11111101,
							  8'b11111101};
			endcase
		1'd8:
			case (position)
				0: LED_R= {8'b10111111,
							  8'b00001111,
							  8'b10111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				1: LED_G= {8'b11111000,
							  8'b11111001,
							  8'b11111010,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111};
				2: LED_B= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b10111111,
							  8'b10111111,
							  8'b00011111,
							  8'b10111111};
				3: LED_G= {8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111010,
							  8'b11111100,
							  8'b11111000};
			endcase
	endcase
	end

endmodule

module show_time_and_score(
input clk,		//high freq clock
input time_count, score,
output [1:16] time_out, 
output [0:6] score_out
);

always @(clk)
	;

always @(time_count)
	if(time_count==1)
		time_out=16'b1111111111111111;
	else
		if(time_count%4==0)
			time_out=time_out/2;

always @(score)
	;

endmodule

module play_sound(
input sound_type,
output sound
);
always @(sound_type) begin
	sound<=1'b0;
	case(sound_type)
		//right
		1: sound=~sound;
			sound=~sound;
		//wrong
		2: sound=~sound;
			sound=~sound;
			sound=~sound;
			sound=~sound;
		//gameover
		3: sound=~sound;
	endcase	
end

endmodule

module keyboard_input(
input [3:0] row, column,
output key_num
);
always @(posedge clk) begin
	case(row)
		4'b1110:
			case(column)
				4'b1110:
					key_num<=0;//LH
				4'b1101:
					key_num<=1;//H
				4'b1011:
					key_num<=2;//RH
			endcase
		4'b1101:
			case(column)
				4'b1110:
					key_num<=3;//L
				4'b1011:
					key_num<=4;//R
			endcase
		4'b1011:
			case(column)
				4'b1110:
					key_num<=5;//LD
				4'b1101:
					key_num<=6;//D
				4'b1011:
					key_num<=7;//RD
			endcase
	endcase
end

endmodule

module divfreq(input clk, output reg clk_div);
reg [24:0] count;
always@(posedge clk)
begin
	if(count > 25000000)
		begin
		count <= 25'b0;
		clk_div<=~clk_div;
		end
	else
		count <= count + 1'b1;
	end
endmodule
