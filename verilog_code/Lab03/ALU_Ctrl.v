`ifndef ALU_CTRL_V
`define ALU_CTRL_V
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o,
			 ALUJrCtrl_o
          );

			 /*ALU_ctrl_o
					and						0000
					or, ori					0001
					add, addi, lw, sw 	0010
          mul               0011
					sub, beq					0110
					slt						0111
					sll						1000
					sllv						1001
					lui						1010
					bne						1011
					sltu						1111 */

    //I/O ports
    input      [6-1:0] funct_i;
    input      [3-1:0] ALUOp_i;

    output     [4-1:0] ALUCtrl_o;
    output     ALUJrCtrl_o;

    //Internal Signals
    reg        [4-1:0] ALUCtrl_o;
	 reg        ALUJrCtrl_o;

    //Parameter


    //Select exact operation
    always @ ( * ) begin
        if (funct_i==6'b100000 && ALUOp_i==3'b010) begin  //add
            ALUCtrl_o=4'b0010;
            ALUJrCtrl_o = 0;
        end

		  else if(funct_i==6'b000000 && ALUOp_i==3'b000) begin  //addi
            ALUCtrl_o=4'b0010; // design by hand
            ALUJrCtrl_o = 0;
        end

      else if(funct_i==6'b011000 && ALUOp_i==3'b010) begin  //mul
            ALUCtrl_o=4'b0011; // design by hand
            ALUJrCtrl_o = 0;
        end

      else if(funct_i==6'b001000 && ALUOp_i==3'b010) begin  //jr -> special
            ALUCtrl_o=4'b0011; // design by hand
            ALUJrCtrl_o = 1;
        end

        else if(funct_i==6'b100010 && ALUOp_i==3'b010) begin  //sub
            ALUCtrl_o=4'b0110;
            ALUJrCtrl_o = 0;
        end

        else if(funct_i==6'b100100 && ALUOp_i==3'b010) begin  //and
            ALUCtrl_o=4'b0000;
            ALUJrCtrl_o = 0;
        end

        else if(funct_i==6'b100101 && ALUOp_i==3'b010) begin  //or
            ALUCtrl_o=4'b0001;
            ALUJrCtrl_o = 0;
        end

        else if(funct_i==6'b101010 && ALUOp_i==3'b010) begin  //slt
            ALUCtrl_o=4'b0111;
            ALUJrCtrl_o = 0;
        end

		  else if(funct_i==6'b101011 && ALUOp_i==3'b010) begin  //sltu
            ALUCtrl_o=4'b1111; // design by hand
            ALUJrCtrl_o = 0;
        end

		  else if(funct_i==6'b000000 && ALUOp_i==3'b010) begin  //sll
            ALUCtrl_o=4'b1000; // design by hand
            ALUJrCtrl_o = 0;
        end

		  else if(funct_i==6'b000100 && ALUOp_i==3'b010) begin  //sllv
            ALUCtrl_o=4'b1001; // design by hand
            ALUJrCtrl_o = 0;
        end

		  else if(ALUOp_i==3'b011) begin  //lui
            ALUCtrl_o=4'b1010; // design by hand
            ALUJrCtrl_o = 0;
        end

		  else if(ALUOp_i==3'b100) begin  //ori
            ALUCtrl_o=4'b0001; // design by hand
            ALUJrCtrl_o = 0;
        end

        else if(ALUOp_i==3'b000) begin  //lw, sw
            ALUCtrl_o=4'b0010;
            ALUJrCtrl_o = 0;
        end

        else if(ALUOp_i==3'b001) begin  //beq
            ALUCtrl_o=4'b0110;
            ALUJrCtrl_o = 0;
        end

		  else if(ALUOp_i==3'b101) begin  //bne
            ALUCtrl_o=4'b1011; // design by hand
            ALUJrCtrl_o = 0;
        end

        else begin
            ALUCtrl_o=4'bxxxx;
            ALUJrCtrl_o = 1'b0;
        end
    end
endmodule
`endif//ALU_CTRL_V
