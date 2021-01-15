module final_project(
input clk, start,
output reg [0:7] OUT_R, OUT_G, OUT_B,
output reg [3:0] COMM,
output reg [1:16] time_out, 
output reg [0:6] score_out, 
output reg [0:1] score_position,
input [0:3] row, column,
output reg sound,
output reg start_i
);

parameter max_time=64;
parameter max_score=20;

int time_count, score;
reg [0:3] graph_num[0:3];
reg [0:3] position[0:1];
reg [0:31] i, j;
reg sound_type;
bit is_start;

divfreq f(.clk(clk), .clk_div(clk_div));
play_sound play(.sound(sound),.sound_type(sound_type));
show_LED led(.COMM(COMM), .OUT_R(OUT_R), .OUT_G(OUT_G), .OUT_B(OUT_B),.clk(clk), .graph_num(graph_num[i]), .position(position[i]));
show_time_and_score shw(.time_out(time_out), .score_out(score_out), .score_position(score_position),.clk(clk_div), .time_count(time_count), .score(score));
keyboard_input key(.row(row), .column(column),.key_num(key_num));

assign is_end=(score>=max_score||time_count>=max_time);
assign start_i=~is_start;
//assign key_num=s1;
//initial
initial begin
is_start<=1'b0;
score<=34;
time_count<=0;
end

always @(start) begin
	if(is_end)
		is_start=1'b0;
	else begin
		is_start=1'b1;
	end
	end
//count time
always @(posedge clk_div) begin
	if(time_count<=max_time && is_start) begin
		time_count <= time_count+1;
		i <= (time_count/2)%4;
		j <= (time_count/2 - 1)%4;
		end
	else
		time_count <= 0;
	end
//show graph
always @(posedge clk_div) begin
	if(time_count%2==0) begin
		if(time_count==0)	graph_num[i]<=((time_count/2)+5)%9;
		else graph_num[i]<=((time_count/2)*graph_num[j]+5)%9;
		//graph_num[i]<=((time_count/2)%9);
		position[i]<= ((time_count/2)%4);
	end
end
//detect input and play sound
always @(key_num,is_end) begin
	if(is_end)
		begin sound_type<=3; score <= 0; end
	else if(key_num==0 && ((graph_num[(time_count/2-3)%4]==3 && position[(time_count/2-3)%4]==1) || (graph_num[(time_count/2-3)%4]==4 && position[(time_count/2-3)%4]==3) || (graph_num[(time_count/2-3)%4]==5 && position[(time_count/2-3)%4]==3) || (graph_num[(time_count/2-3)%4]==6 && position[(time_count/2-3)%4]==1)))
		begin sound_type<=1; score <= score + 1'd1; end
	else if(key_num==1 && ((graph_num[(time_count/2-3)%4]==0 && position[(time_count/2-3)%4]==3) || (graph_num[(time_count/2-3)%4]==1 && position[(time_count/2-3)%4]==2) || (graph_num[(time_count/2-3)%4]==2 && position[(time_count/2-3)%4]==1) || (graph_num[(time_count/2-3)%4]==7 && position[(time_count/2-3)%4]==0)))
		begin sound_type<=1; score <= score + 1'd1; end
	else if(key_num==2 && ((graph_num[(time_count/2-3)%4]==1 && position[(time_count/2-3)%4]==3) || (graph_num[(time_count/2-3)%4]==4 && position[(time_count/2-3)%4]==1) || (graph_num[(time_count/2-3)%4]==6 && position[(time_count/2-3)%4]==3) || (graph_num[(time_count/2-3)%4]==7 && position[(time_count/2-3)%4]==2) || (graph_num[(time_count/2-3)%4]==8 && position[(time_count/2-3)%4]==3)))
		begin sound_type<=1; score <= score + 1'd1; end
	else if(key_num==3 && ((graph_num[(time_count/2-3)%4]==0 && position[(time_count/2-3)%4]==0) || (graph_num[(time_count/2-3)%4]==3 && position[(time_count/2-3)%4]==2) || (graph_num[(time_count/2-3)%4]==5 && position[(time_count/2-3)%4]==0) || (graph_num[(time_count/2-3)%4]==5 && position[(time_count/2-3)%4]==1) || (graph_num[(time_count/2-3)%4]==7 && position[(time_count/2-3)%4]==3)))
		begin sound_type<=1; score <= score + 1'd1; end
	else if(key_num==4 && ((graph_num[(time_count/2-3)%4]==0 && position[(time_count/2-3)%4]==1) || (graph_num[(time_count/2-3)%4]==1 && position[(time_count/2-3)%4]==0) || (graph_num[(time_count/2-3)%4]==2 && position[(time_count/2-3)%4]==2) || (graph_num[(time_count/2-3)%4]==2 && position[(time_count/2-3)%4]==3) || (graph_num[(time_count/2-3)%4]==8 && position[(time_count/2-3)%4]==2)))
		begin sound_type<=1; score <= score + 1'd1; end
	else if(key_num==5 && ((graph_num[(time_count/2-3)%4]==1 && position[(time_count/2-3)%4]==1) || (graph_num[(time_count/2-3)%4]==3 && position[(time_count/2-3)%4]==3) || (graph_num[(time_count/2-3)%4]==4 && position[(time_count/2-3)%4]==2) || (graph_num[(time_count/2-3)%4]==6 && position[(time_count/2-3)%4]==0) || (graph_num[(time_count/2-3)%4]==7 && position[(time_count/2-3)%4]==1) || (graph_num[(time_count/2-3)%4]==8 && position[(time_count/2-3)%4]==1)))
		begin sound_type<=1; score <= score + 1'd1; end
	else if(key_num==6 && ((graph_num[(time_count/2-3)%4]==0 && position[(time_count/2-3)%4]==2) || (graph_num[(time_count/2-3)%4]==3 && position[(time_count/2-3)%4]==0) || (graph_num[(time_count/2-3)%4]==4 && position[(time_count/2-3)%4]==0) || (graph_num[(time_count/2-3)%4]==5 && position[(time_count/2-3)%4]==2) || (graph_num[(time_count/2-3)%4]==8 && position[(time_count/2-3)%4]==0)))
		begin sound_type<=1; score <= score + 1'd1; end
	else if(key_num==7 && ((graph_num[(time_count/2-3)%4]==2 && position[(time_count/2-3)%4]==0) || (graph_num[(time_count/2-3)%4]==6 && position[(time_count/2-3)%4]==2)))
		begin sound_type<=1; score <= score + 1'd1; end
	else
		begin sound_type<=1; score <= score + 1'd1; end
end

endmodule

module show_LED(
input clk,
input [0:8] graph_num,
input [0:1] position,
output reg [0:7] OUT_R, OUT_G, OUT_B,
output reg [3:0] COMM);
bit [2:0] cnt;
reg [0:7] LED_R [0:7];
reg [0:7] LED_G [0:7];
reg [0:7] LED_B [0:7];
reg [24:0] count;
always @(posedge clk) begin
	if(count > 125000) begin
	if(cnt >= 7)
		cnt = 0;
	else
		cnt=cnt+1;
	COMM = {1'b1, cnt};
	OUT_R = LED_R[cnt];
	OUT_G = LED_G[cnt];
	OUT_B = LED_B[cnt];
	count<= 25'b0;
	end
	else
		count <= count + 1'b1;
end
initial begin
	LED_R <= '{8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111};
	LED_G <= '{8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111};
	LED_B <= '{8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111};
	end
always @(graph_num) begin
	case (graph_num)
		0: begin
			case (position)
				0: LED_R<='{8'b10111111,
							   8'b00011111,
							   8'b10111111,
							   8'b10111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				1: LED_G<='{8'b11111101,
							   8'b11111101,
							   8'b11111000,
							   8'b11111101,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				2: LED_B<='{8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b10111111,
							   8'b00001111,
							   8'b10111111};
				3: LED_G<='{8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111101,
							   8'b11110000,
							   8'b11111101};
			endcase
			end
		1:begin
			case (position)
				0: LED_R<='{8'b10111111,
							   8'b10111111,
							   8'b00011111,
							   8'b10111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				1: LED_G<='{8'b11111000,
							   8'b11111001,
							   8'b11111010,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				2: LED_B<='{8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11011111,
							   8'b00001111,
							   8'b11011111};
				3: LED_G<='{8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111010,
							   8'b11111100,
							   8'b11111000};
			endcase
			end
		2:begin
			case (position)
				0: LED_R<='{8'b01011111,
							   8'b00111111,
							   8'b00011111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				1: LED_G<='{8'b11111101,
							   8'b11110000,
							   8'b11111101,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				2: LED_B<='{8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b10111111,
							   8'b10111111,
							   8'b00011111,
							   8'b10111111};
				3: LED_G<='{8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111101,
							   8'b11111101,
							   8'b11111000,
							   8'b11111101};
			endcase
			end
		3:begin
			case (position)
				0: LED_R<='{8'b10111111,
							   8'b00001111,
							   8'b10111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				1: LED_G<='{8'b11111000,
							   8'b11111100,
							   8'b11111010,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				2: LED_B<='{8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b10111111,
							   8'b00011111,
							   8'b10111111,
							   8'b10111111};
				3: LED_G<='{8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111010,
							   8'b11111001,
							   8'b11111000};
			endcase
			end
		4:begin
			case (position)
				0: LED_R<='{8'b10111111,
							   8'b00001111,
							   8'b10111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				1: LED_G<='{8'b11111010,
							   8'b11111100,
							   8'b11111000,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				2: LED_B<='{8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b00011111,
							  8'b00111111,
							  8'b01011111};
				3: LED_G<='{8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111000,
							  8'b11111100,
							  8'b11111010};
			endcase
			end
		5:begin
			case (position)
				0: LED_R<='{8'b10111111,
							   8'b00011111,
							   8'b10111111,
							   8'b10111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				1: LED_G<='{8'b11111101,
							   8'b11111000,
							   8'b11111101,
							   8'b11111101,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				2: LED_B<='{8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b10111111,
							  8'b00001111,
							  8'b10111111};
				3: LED_G<='{8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111000,
							  8'b11111100,
							  8'b11111010};
			endcase
			end
		6:begin
			case (position)
				0: LED_R<='{8'b00011111,
							   8'b00111111,
							   8'b01011111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				1: LED_G<='{8'b11111000,
							   8'b11111100,
							   8'b11111010,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				2: LED_B<='{8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b01011111,
							  8'b00111111,
							  8'b00011111};
				3: LED_G<='{8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111010,
							  8'b11111100,
							  8'b11111000};
			endcase
			end
		7:begin
			case (position)
				0: LED_R<='{8'b11011111,
							   8'b00001111,
							   8'b11011111,
							   8'b11111111,
							   8'b11111111,
						  	   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				1: LED_G<='{8'b11111000,
							   8'b11111001,
							   8'b11111010,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				2: LED_B<='{8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b01011111,
							  8'b10011111,
							  8'b00011111};
				3: LED_G<='{8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111101,
							  8'b11111000,
							  8'b11111101,
							  8'b11111101};
			endcase
			end
		8:begin
			case (position)
				0: LED_R<='{8'b10111111,
							   8'b00001111,
							   8'b10111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				1: LED_G<='{8'b11111000,
							   8'b11111001,
							   8'b11111010,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111};
				2: LED_B<='{8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b11111111,
							   8'b10111111,
							   8'b10111111,
							   8'b00011111,
							   8'b10111111};
				3: LED_G<='{8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111111,
							  8'b11111010,
							  8'b11111100,
							  8'b11111000};
			endcase
			end
	default begin
	LED_R <= '{8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111};
	LED_G <= '{8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111};
	LED_B <= '{8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111,
					8'b11111111};
	end
	endcase
	end

endmodule

module show_time_and_score(
input clk,		//high freq clock
input int time_count, score,
output reg [0:15] time_out, 
output reg [0:6] score_out, 
output reg [0:1] score_position 
);
bit count;
reg [24:0] cnt;
reg [0:6] score_out_10, score_out_1;
always @(clk) begin
if(cnt>250000)
begin
	if(count) begin
		count <= 1'b0;
		score_position <= 2'b10;
		score_out <= score_out_10;
		end
	else
	begin
		count <= 1'b1;
		score_position <= 2'b01;
		score_out <= score_out_1;
		end
	cnt<=25'b0;
end
else
begin
	cnt<=cnt+1'b1;
end
end
always @(time_count)begin
	if(time_count==0)
		time_out<=16'b1111111111111111;
	else if(time_count<4)
		time_out<=16'b0111111111111111;
	else if(time_count<8)
		time_out<=16'b0011111111111111;
	else if(time_count<12)
		time_out<=16'b0001111111111111;
	else if(time_count<16)
		time_out<=16'b0000111111111111;
	else if(time_count<20)
		time_out<=16'b0000011111111111;
	else if(time_count<24)
		time_out<=16'b0000001111111111;
	else if(time_count<28)
		time_out<=16'b0000000111111111;
	else if(time_count<32)
		time_out<=16'b0000000011111111;
	else if(time_count<36)
		time_out<=16'b0000000001111111;
	else if(time_count<40)
		time_out<=16'b0000000000111111;
	else if(time_count<44)
		time_out<=16'b0000000000011111;
	else if(time_count<48)
		time_out<=16'b0000000000001111;
	else if(time_count<52)
		time_out<=16'b0000000000000111;
	else if(time_count<56)
		time_out<=16'b0000000000000011;
	else if(time_count<60)
		time_out<=16'b0000000000000001;
	else if(time_count<64)
		time_out<=16'b0000000000000000;
		end

always @(clk) begin
	case(time_count/10)
		0: score_out_10 <= ~7'b1111110;
		1: score_out_10 <= ~7'b0110000;
		2: score_out_10 <= ~7'b1101101;
		3: score_out_10 <= ~7'b1111001;
		4: score_out_10 <= ~7'b0110011;
		5: score_out_10 <= ~7'b1011011;
		6: score_out_10 <= ~7'b1011111;
		7: score_out_10 <= ~7'b1110000;
		8: score_out_10 <= ~7'b1111111;
		9: score_out_10 <= ~7'b1111011;
	default score_out_10 <= ~7'b0111110;
	endcase
	case(time_count%10)
		0: score_out_1 <= ~7'b1111110;
		1: score_out_1 <= ~7'b0110000;
		2: score_out_1 <= ~7'b1101101;
		3: score_out_1 <= ~7'b1111001;
		4: score_out_1 <= ~7'b0110011;
		5: score_out_1 <= ~7'b1011011;
		6: score_out_1 <= ~7'b1011111;
		7: score_out_1 <= ~7'b1110000;
		8: score_out_1 <= ~7'b1111111;
		9: score_out_1 <= ~7'b1111011;
	default score_out_1 <= ~7'b0111110;
	endcase
end
endmodule

module play_sound(
input sound_type,
output reg sound
);
always @(sound_type) begin
	//sound = 1'b0;
	case(sound_type)
		//right
		1: begin sound=~sound;
			sound=~sound; 
			end
		//wrong
		2: begin sound=~sound;
			sound=~sound;
			sound=~sound;
			sound=~sound; end
		//gameover
		3: sound=0;
	endcase	
end

endmodule

module keyboard_input(
input [0:1] row, column,
output [0:2] key_num
);
always@(*) begin
	case(row)
		4'b1110:begin
			case(column)
				4'b1110:
					key_num<=0;//LH
				4'b1101:
					key_num<=1;//H
				4'b1011:
					key_num<=2;//RH
			endcase
			end
		4'b1101:begin
			case(column)
				4'b1110:
					key_num<=3;//L
				4'b1011:
					key_num<=4;//R
			endcase
			end
		4'b1011:begin
			case(column)
				4'b1110:
					key_num<=5;//LD
				4'b1101:
					key_num<=6;//D
				4'b1011:
					key_num<=7;//RD
			endcase
			end
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
