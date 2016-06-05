// University of Oregon
// Computer Architecture & Embedded Systems Laboratory 
// Complex Digital System Design, Spring 2016
// SoC Laboratory

module LED_7seg(
	input[3:0] BCD,
	output segA,segB,segC,segD,segE,segF,segG,segDP
	);

	reg[7:0] SevenSeg;
	always@(*)
		case (BCD)
			4'h0:SevenSeg=8'b11000000;//8'b00111111;//8'b11111100;
			4'h1:SevenSeg=8'b11111001;//8'b00000110;//8'b01100000;
			4'h2:SevenSeg=8'b10100100;//8'b01011011;//8'b11011010;
			4'h3:SevenSeg=8'b10110000;//8'b01001111;//8'b11110010;
			4'h4:SevenSeg=8'b10011001;//8'b01100110;//8'b01100110;
			4'h5:SevenSeg=8'b10010010;//8'b01101101;//8'b10110110;
			4'h6:SevenSeg=8'b10000010;//8'b01111101;//8'b10111110;
			4'h7:SevenSeg=8'b11111000;//8'b00000111;//8'b11100000;
			4'h8:SevenSeg=8'b10000000;//8'b01111111;//8'b11111110;
			4'h9:SevenSeg=8'b10010000;//8'b01101111;//8'b11110110;
			4'hA:SevenSeg=8'b10001000;
			4'hB:SevenSeg=8'b10000011;
			4'hC:SevenSeg=8'b11000110;
			4'hD:SevenSeg=8'b10100001;
			4'hE:SevenSeg=8'b10000110;
			4'hF:SevenSeg=8'b10001110;
			default:SevenSeg=8'b00000000;
		endcase
	//assign {segA,segB,segC,segD,segE,segF,segG,segDP}=SevenSeg;
	assign {segDP,segG,segF,segE,segD,segC,segB,segA}=SevenSeg;
endmodule
