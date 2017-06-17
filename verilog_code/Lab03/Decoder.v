module Decoder(
    instr_op_i,
  	RegWrite_o,
  	ALU_op_o,
  	ALUSrc_o,
  	RegDst_o,
  	Branch_o,
    Jump_o,
    MemToReg_o,
    BranchType_o,
    MemRead_o,
    MemWrite_o
  	);

    //I/O ports
    input  [6-1:0] instr_op_i;

    output         RegWrite_o;
    output [3-1:0] ALU_op_o;
    output         ALUSrc_o;
    output [3-1:0] RegDst_o;
    output         Branch_o;

    output         Jump_o;
    output [1:0]   MemToReg_o;
    output [1:0]   BranchType_o;
    output         MemRead_o;
    output         MemWrite_o;

    //Internal Signals
    reg    [3-1:0] ALU_op_o;
    reg            ALUSrc_o;
    reg            RegWrite_o;
    reg    [3-1:0] RegDst_o;
    reg            Branch_o;
	 reg            Jump_o;
	 reg 	  [1:0]   MemToReg_o;
    reg    [1:0]   BranchType_o;
    reg            MemRead_o;
    reg            MemWrite_o;

    //Parameter


    //Main function
    always @ ( * ) begin
        if (instr_op_i == 6'b000000) begin      //r-type, jr
            ALU_op_o    = 3'b010;
            ALUSrc_o    = 0;
            RegWrite_o  = 1;
            RegDst_o    = 2'b01;
            Branch_o    = 0;
            Jump_o      = 1;
            MemToReg_o  = 2'b00;
            BranchType_o= 2'b00;
            MemRead_o   = 0;
            MemWrite_o  = 0;
        end
        else if (instr_op_i == 6'b100011) begin //lw
            ALU_op_o    = 3'b000;
            ALUSrc_o    = 1;
            RegWrite_o  = 1;
            RegDst_o    = 2'b00;
            Branch_o    = 0;
            Jump_o      = 1;
            MemToReg_o  = 2'b01;
            BranchType_o= 2'b00;
            MemRead_o   = 1;
            MemWrite_o  = 0;
        end
        else if(instr_op_i == 6'b101011)begin  //sw
            ALU_op_o    = 3'b000;
            ALUSrc_o    = 1;
            RegWrite_o  = 0;
            RegDst_o    = 2'b00;
            Branch_o    = 0;
            Jump_o      = 1;
            MemToReg_o  = 2'b00;
            BranchType_o= 2'b00;
            MemRead_o   = 0;
            MemWrite_o  = 1;
        end
        else if(instr_op_i == 6'b000100)begin    //beq
            ALU_op_o    = 3'b001;
            ALUSrc_o    = 0;
            RegWrite_o  = 0;
            RegDst_o    = 2'b00;
            Branch_o    = 1;
            Jump_o      = 1;
            MemToReg_o  = 2'b00;
            BranchType_o= 2'b00;
            MemRead_o   = 0;
            MemWrite_o  = 0;
        end
        else if(instr_op_i == 6'b000111)begin    //ble -> make by hand
            ALU_op_o    = 3'b001;
            ALUSrc_o    = 0;
            RegWrite_o  = 0;
            RegDst_o    = 2'b00;
            Branch_o    = 1;
            Jump_o      = 1;
            MemToReg_o  = 2'b00;
            BranchType_o= 2'b01;
            MemRead_o   = 0;
            MemWrite_o  = 0;
        end
        else if(instr_op_i == 6'b000110)begin    //blt -> make by hand
            ALU_op_o    = 3'b001;
            ALUSrc_o    = 0;
            RegWrite_o  = 0;
            RegDst_o    = 2'b00;
            Branch_o    = 1;
            Jump_o      = 1;
            MemToReg_o  = 2'b00;
            BranchType_o= 2'b10;
            MemRead_o   = 0;
            MemWrite_o  = 0;
        end
        else if(instr_op_i == 6'b000101)begin    //bnez -> make by hand
            ALU_op_o    = 3'b001;
            ALUSrc_o    = 0;
            RegWrite_o  = 0;
            RegDst_o    = 2'b00;
            Branch_o    = 1;
            Jump_o      = 1;
            MemToReg_o  = 2'b00;
            BranchType_o= 2'b11;
            MemRead_o   = 0;
            MemWrite_o  = 0;
        end
		  else if(instr_op_i == 6'b001000)begin    //addi -> make by hand
            ALU_op_o    = 3'b000;
            ALUSrc_o    = 1;
            RegWrite_o  = 1;
            RegDst_o    = 2'b00;
            Branch_o    = 0;
            Jump_o      = 1;
            MemToReg_o  = 2'b00;
            BranchType_o= 2'b00;
            MemRead_o   = 0;
            MemWrite_o  = 0;
        end
		  else if(instr_op_i == 6'b001111)begin    //lui -> make by hand
            ALU_op_o    = 3'b011;
            ALUSrc_o    = 1;
            RegWrite_o  = 1;
            RegDst_o    = 2'b00;
            Branch_o    = 0;
            Jump_o      = 1;
            MemToReg_o  = 2'b00;
            BranchType_o= 2'b00;
            MemRead_o   = 0;
            MemWrite_o  = 0;
        end
		  else if(instr_op_i == 6'b001101)begin    //ori -> make by hand
            ALU_op_o    = 3'b100;
            ALUSrc_o    = 1;
            RegWrite_o  = 1;
            RegDst_o    = 2'b00;
            Branch_o    = 0;
            Jump_o      = 1;
            MemToReg_o  = 2'b00;
            BranchType_o= 2'b00;
            MemRead_o   = 0;
            MemWrite_o  = 0;
        end
		  else if(instr_op_i == 6'b000101)begin    //bne -> make by hand
            ALU_op_o    = 3'b101;           
            ALUSrc_o    = 0;
            RegWrite_o  = 0;
            RegDst_o    = 2'b00;
            Branch_o    = 1;
            Jump_o      = 1;
            MemToReg_o  = 2'b00;
            BranchType_o= 2'b00;
            MemRead_o   = 0;
            MemWrite_o  = 0;
        end
      else if(instr_op_i == 6'b000010)begin    //j -> make by hand
            ALU_op_o    = 3'bxxx;
            ALUSrc_o    = 0;
            RegWrite_o  = 0;
            RegDst_o    = 2'b00;
            Branch_o    = 0;
            Jump_o      = 0;
            MemToReg_o  = 2'b00;
            BranchType_o= 2'b00;
            MemRead_o   = 0;
            MemWrite_o  = 0;
        end
      else if(instr_op_i == 6'b000011)begin    //jal -> make by hand
            ALU_op_o    = 3'bxxx;
            ALUSrc_o    = 0;
            RegWrite_o  = 1;
            RegDst_o    = 2'b10;              //reg -> 31
            Branch_o    = 0;
            Jump_o      = 0;
            MemToReg_o  = 2'b11;              //Ÿäå­˜reg[31] = PC+4
            BranchType_o= 2'b00;
            MemRead_o   = 0;
            MemWrite_o  = 0;
        end
      else if(instr_op_i == 6'b001111)begin    //li -> make by hand
              ALU_op_o    = 3'bxxx;
              ALUSrc_o    = 0;
              RegWrite_o  = 1;
              RegDst_o    = 2'b00;
              Branch_o    = 0;
              Jump_o      = 1;
              MemToReg_o  = 2'b10;
              BranchType_o= 2'b00;
              MemRead_o   = 0;
              MemWrite_o  = 0;
          end
        else begin
            ALU_op_o  = 3'bxxx;
            ALUSrc_o  = 1'bx;
            RegWrite_o= 1'bx;
            RegDst_o  = 1'bx;
            Branch_o  = 1'bx;
        end
    end
endmodule
