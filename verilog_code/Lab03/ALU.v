`ifndef ALU_V
`define ALU_V

module full_adder ( in_a, in_b, in_c, out_s, out_c);
    input  in_a, in_b ,in_c;
    output out_c, out_s;
    wire n1, n2, n3;
    xor (n1   , in_a, in_b);
    xor (out_s,   n1, in_c);
    nand(n2   , in_a, in_b);
    nand(n3   ,   n1, in_c);
    nand(out_c,   n3, n2);
endmodule // full_adder

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               set         //1 bit set      (output)
               );
    input         src1;
    input         src2;
    input         less;
    input         A_invert;
    input         B_invert;
    input         cin;
    input [2-1:0] operation;

    output        result;
    output        cout;
    output        set;

    reg           result;

    wire A, B;
    assign A = (A_invert) ? ~src1 : src1;
    assign B = (B_invert) ? ~src2 : src2;

    wire result0, result1, result2, result3;

    assign        result0 = A & B;
    assign        result1 = A | B;
    full_adder FA(A, B, cin, result2, cout);
    assign        result3 = (less); // not desided yet

    assign        set     = result2;

    always @ ( * ) begin
        result <= (operation == 2'b00) ? result0:
                  (operation == 2'b01) ? result1:
                  (operation == 2'b10) ? result2:
                  (operation == 2'b11) ? result3: 2'bxx;
    end
endmodule


module alu_old(
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
		 //bonus_control, // 3 bits bonus control input(input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );
    input           rst_n;
    input  [32-1:0] src1;
    input  [32-1:0] src2;
    input   [4-1:0] ALU_control;
    //input   [3-1:0] bonus_control;

    output [32-1:0] result;
    output          zero;
    output          cout;
    output          overflow;


    reg    [32-1:0] result;
    reg             zero;
    reg             cout;
    reg             overflow;

    wire [31:0] cout_wire, result_wire;

    wire first_cin, slt, MSBset;
    assign first_cin = (~ALU_control[3] & ALU_control[2])? 1 : 0; //sub => ones comp + 1
    assign slt = (ALU_control[1] & ALU_control[0] & MSBset);
    alu_top ALUPART00 (src1[ 0], src2[ 0],  slt, ALU_control[3], ALU_control[2],     first_cin, ALU_control[1:0], result_wire[ 0], cout_wire[ 0], );
    alu_top ALUPART01 (src1[ 1], src2[ 1], 1'b0, ALU_control[3], ALU_control[2], cout_wire[ 0], ALU_control[1:0], result_wire[ 1], cout_wire[ 1], );
    alu_top ALUPART02 (src1[ 2], src2[ 2], 1'b0, ALU_control[3], ALU_control[2], cout_wire[ 1], ALU_control[1:0], result_wire[ 2], cout_wire[ 2], );
    alu_top ALUPART03 (src1[ 3], src2[ 3], 1'b0, ALU_control[3], ALU_control[2], cout_wire[ 2], ALU_control[1:0], result_wire[ 3], cout_wire[ 3], );
    alu_top ALUPART04 (src1[ 4], src2[ 4], 1'b0, ALU_control[3], ALU_control[2], cout_wire[ 3], ALU_control[1:0], result_wire[ 4], cout_wire[ 4], );
    alu_top ALUPART05 (src1[ 5], src2[ 5], 1'b0, ALU_control[3], ALU_control[2], cout_wire[ 4], ALU_control[1:0], result_wire[ 5], cout_wire[ 5], );
    alu_top ALUPART06 (src1[ 6], src2[ 6], 1'b0, ALU_control[3], ALU_control[2], cout_wire[ 5], ALU_control[1:0], result_wire[ 6], cout_wire[ 6], );
    alu_top ALUPART07 (src1[ 7], src2[ 7], 1'b0, ALU_control[3], ALU_control[2], cout_wire[ 6], ALU_control[1:0], result_wire[ 7], cout_wire[ 7], );
    alu_top ALUPART08 (src1[ 8], src2[ 8], 1'b0, ALU_control[3], ALU_control[2], cout_wire[ 7], ALU_control[1:0], result_wire[ 8], cout_wire[ 8], );
    alu_top ALUPART09 (src1[ 9], src2[ 9], 1'b0, ALU_control[3], ALU_control[2], cout_wire[ 8], ALU_control[1:0], result_wire[ 9], cout_wire[ 9], );
    alu_top ALUPART10 (src1[10], src2[10], 1'b0, ALU_control[3], ALU_control[2], cout_wire[ 9], ALU_control[1:0], result_wire[10], cout_wire[10], );
    alu_top ALUPART11 (src1[11], src2[11], 1'b0, ALU_control[3], ALU_control[2], cout_wire[10], ALU_control[1:0], result_wire[11], cout_wire[11], );
    alu_top ALUPART12 (src1[12], src2[12], 1'b0, ALU_control[3], ALU_control[2], cout_wire[11], ALU_control[1:0], result_wire[12], cout_wire[12], );
    alu_top ALUPART13 (src1[13], src2[13], 1'b0, ALU_control[3], ALU_control[2], cout_wire[12], ALU_control[1:0], result_wire[13], cout_wire[13], );
    alu_top ALUPART14 (src1[14], src2[14], 1'b0, ALU_control[3], ALU_control[2], cout_wire[13], ALU_control[1:0], result_wire[14], cout_wire[14], );
    alu_top ALUPART15 (src1[15], src2[15], 1'b0, ALU_control[3], ALU_control[2], cout_wire[14], ALU_control[1:0], result_wire[15], cout_wire[15], );
    alu_top ALUPART16 (src1[16], src2[16], 1'b0, ALU_control[3], ALU_control[2], cout_wire[15], ALU_control[1:0], result_wire[16], cout_wire[16], );
    alu_top ALUPART17 (src1[17], src2[17], 1'b0, ALU_control[3], ALU_control[2], cout_wire[16], ALU_control[1:0], result_wire[17], cout_wire[17], );
    alu_top ALUPART18 (src1[18], src2[18], 1'b0, ALU_control[3], ALU_control[2], cout_wire[17], ALU_control[1:0], result_wire[18], cout_wire[18], );
    alu_top ALUPART19 (src1[19], src2[19], 1'b0, ALU_control[3], ALU_control[2], cout_wire[18], ALU_control[1:0], result_wire[19], cout_wire[19], );
    alu_top ALUPART20 (src1[20], src2[20], 1'b0, ALU_control[3], ALU_control[2], cout_wire[19], ALU_control[1:0], result_wire[20], cout_wire[20], );
    alu_top ALUPART21 (src1[21], src2[21], 1'b0, ALU_control[3], ALU_control[2], cout_wire[20], ALU_control[1:0], result_wire[21], cout_wire[21], );
    alu_top ALUPART22 (src1[22], src2[22], 1'b0, ALU_control[3], ALU_control[2], cout_wire[21], ALU_control[1:0], result_wire[22], cout_wire[22], );
    alu_top ALUPART23 (src1[23], src2[23], 1'b0, ALU_control[3], ALU_control[2], cout_wire[22], ALU_control[1:0], result_wire[23], cout_wire[23], );
    alu_top ALUPART24 (src1[24], src2[24], 1'b0, ALU_control[3], ALU_control[2], cout_wire[23], ALU_control[1:0], result_wire[24], cout_wire[24], );
    alu_top ALUPART25 (src1[25], src2[25], 1'b0, ALU_control[3], ALU_control[2], cout_wire[24], ALU_control[1:0], result_wire[25], cout_wire[25], );
    alu_top ALUPART26 (src1[26], src2[26], 1'b0, ALU_control[3], ALU_control[2], cout_wire[25], ALU_control[1:0], result_wire[26], cout_wire[26], );
    alu_top ALUPART27 (src1[27], src2[27], 1'b0, ALU_control[3], ALU_control[2], cout_wire[26], ALU_control[1:0], result_wire[27], cout_wire[27], );
    alu_top ALUPART28 (src1[28], src2[28], 1'b0, ALU_control[3], ALU_control[2], cout_wire[27], ALU_control[1:0], result_wire[28], cout_wire[28], );
    alu_top ALUPART29 (src1[29], src2[29], 1'b0, ALU_control[3], ALU_control[2], cout_wire[28], ALU_control[1:0], result_wire[29], cout_wire[29], );
    alu_top ALUPART30 (src1[30], src2[30], 1'b0, ALU_control[3], ALU_control[2], cout_wire[29], ALU_control[1:0], result_wire[30], cout_wire[30], );
    alu_top ALUPART31 (src1[31], src2[31], 1'b0, ALU_control[3], ALU_control[2], cout_wire[30], ALU_control[1:0], result_wire[31], cout_wire[31], MSBset);

    integer i;

    always @ ( * ) begin
        result = result_wire;
        cout = cout_wire[31];
        zero = 0;
        for(i = 0; i < 32; i = 1 + i) begin
            zero = zero | result_wire[i];
        end
        zero = ~zero;

        overflow = (ALU_control[3:2] == 2'b00)? (~src1[31] & ~src2[31] & cout_wire[30]) | ( src1[31] & src2[31] & ~cout_wire[30]):
                   (ALU_control[3:2] == 2'b01)? ( src1[31] & ~src2[31] & cout_wire[30]) | (~src1[31] & src2[31] & ~cout_wire[30]): 0;
    end
endmodule



module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	shamt_i,
	result_o,
	zero_o,
	);

    //I/O ports
    input  [32-1:0]  src1_i;
    input  [32-1:0]	src2_i;
    input  [4-1:0]   ctrl_i;
	 input  [5-1:0]   shamt_i;

    output [32-1:0]	 result_o;
    output           zero_o;

    //Internal signals
    reg    [32-1:0]  result_o;
    wire             zero_o;

    wire   [32-1:0]  to_result;
	 wire             to_zero;
	 wire   [4-1:0]   to_ctrl;

	 assign to_ctrl = (ctrl_i == 4'b1011)? 4'b0110 : ctrl_i;
	 assign zero_o  = (ctrl_i == 4'b1011)? ~to_zero : to_zero;

    //Parameter
    alu_old slave(
        .rst_n(1'b1),           // negative reset            (input)
        .src1(src1_i),          // 32 bits source 1          (input)
        .src2(src2_i),          // 32 bits source 2          (input)
        .ALU_control(to_ctrl),   // 4 bits ALU control input  (input)
        .result(to_result),     // 32 bits result            (output)
        .zero(to_zero),          // 1 bit when the output is 0, zero must be set (output)
        .cout(),                // 1 bit carry out           (output)
        .overflow()             // 1 bit overflow            (output)
        );

    integer i;
//Main function
    always @ ( * ) begin
		  if(ctrl_i == 4'b1111) begin
		      if(src1_i[31] & src2_i[31])
				    result_o = ~to_result;
				else if(src1_i[31] & ~src2_i[31])
				    result_o = 32'd0;
            else if(~src1_i[31] & src2_i[31])
                result_o = 32'd1;
            else
                result_o = to_result;
		  end

		  else if(ctrl_i == 4'b1000) begin		//sll

		      result_o = 32'd0;
				for( i = shamt_i; i < 32; i = i + 1 )
		          result_o[i] = src2_i[i - shamt_i];
		  end

		  else if(ctrl_i == 4'b1001) begin		//sllv
		      result_o = 32'd0;
				for( i = src1_i; i < 32; i = i + 1 )
		          result_o[i] = src2_i[i - src1_i];
		  end

		  else if(ctrl_i == 4'b1010) begin		//lui
				result_o = {src2_i[15:0], 16'd0};
		  end

      else if(ctrl_i == 4'b0011) begin    //mul
        result_o = src1_i * src2_i;
      end

		  else
				result_o =  to_result;
    end

endmodule

`endif//ALU_V
