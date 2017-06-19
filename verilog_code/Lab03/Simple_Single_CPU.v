`ifndef SIMPLE_SINGLE_CPU
`define SIMPLE_SINGLE_CPU
`include "ProgramCounter.v"
`include "Sign_Extend.v"
`include "Decoder.v"
`include "Adder.v"
`include "ALU_Ctrl.v"
`include "ALU.v"
`include "Instruction_Memory.v"
`include "MUX_2to1.v"
`include "Reg_File.v"
`include "Shift_Left_Two_32.v"
`include "MUX_4to1.v"
`include "Data_Memory.v"

module Simple_Single_CPU(
		clk_i,
		rst_i
		);
/*
Vars delcares: (pre_pc) => [PC] => (pc)
except some other good names
 */


    //I/O port
    input         clk_i;
    input         rst_i;

    //Internal Signles
    wire [32-1:0] mux_pc_source_old, mux_pc_source, pc; // ProgramCounter
    wire [32-1:0] adder1;
    wire [32-1:0] se;                // sign extended
    wire [32-1:0] shifter;
    wire [32-1:0] adder2;
    wire [32-1:0] instruction;
    wire [32-1:0] alu_result;
    wire [32-1:0] read_data_1, read_data_2;
    wire [32-1:0] mux_alusrc, write_reg, mem_read_data;

    wire [1:0]reg_dst;
    wire zero;
    wire [2:0] alu_op;
    wire [3:0] alu_ctrl;
    wire ALU_jr_ctrl;
    wire [4:0] mux_write_reg;
    wire [32-1:0] alu;
    wire branch_type_result;
    wire branch_result = branch & branch_type_result;

    wire [27:0] jump_shift;

    wire jump, mem_read, mem_write;
    wire [1:0] mem_to_reg, branch_type;
    wire [32-1:0]PC_to_NPC;

    //Greate componentes
    ProgramCounter PC(
            .clk_i   (clk_i),
    	    .rst_i   (rst_i),
    	    .pc_in_i (mux_pc_source),
    	    .pc_out_o(pc)
    	    );


    Adder Adder1(
            .src1_i(32'd4),
    	    .src2_i(pc),
    	    .sum_o (adder1)
    	    );

    Instruction_Memory IM(
            .addr_i(pc),
    	    .instr_o  (instruction)
    	    );

    MUX_4to1 #(.size(5)) Mux_Write_Reg(
            .data0_i (instruction[20:16]),
            .data1_i (instruction[15:11]),
            .data2_i (5'd31),
            .data3_i (5'bxxxxx),
            .select_i(reg_dst),
            .data_o  (mux_write_reg)
            );

    Reg_File RF(
            .clk_i     (clk_i),
    	    .rst_i     (rst_i),
            .RSaddr_i  (instruction[25:21]) ,
            .RTaddr_i  (instruction[20:16]) ,
            .RDaddr_i  (mux_write_reg) ,
            .RDdata_i  (write_reg),
            .RegWrite_i(reg_write),
            .RSdata_o  (read_data_1),
            .RTdata_o  (read_data_2)
            );

    Decoder Decoder(
            .instr_op_i(instruction[31:26]),
    	    .RegWrite_o(reg_write),
    	    .ALU_op_o(alu_op),
    	    .ALUSrc_o(alu_src),
    	    .RegDst_o(reg_dst),
    		.Branch_o(branch),
        .Jump_o(jump),
        .MemToReg_o(mem_to_reg),
        .BranchType_o(branch_type),
        .MemRead_o(mem_read),
        .MemWrite_o(mem_write)
    	    );

    ALU_Ctrl AC(
            .funct_i  (instruction[5:0]),
            .ALUOp_i  (alu_op),
            .ALUCtrl_o(alu_ctrl),
            .ALUJrCtrl_o(ALU_jr_ctrl)
            );

    Sign_Extend SE(
            .data_i(instruction[15:0]),
            .data_o(se)
            );

    MUX_2to1 #(.size(32)) Mux_ALUSrc(
            .data0_i (read_data_2),
            .data1_i (se),
            .select_i(alu_src),
            .data_o  (mux_alusrc)
            );

    ALU ALU(
            .src1_i  (read_data_1),
    	    .src2_i  (mux_alusrc),
    	    .ctrl_i  (alu_ctrl),
			 .shamt_i (instruction[10:6]),
    	    .result_o(alu),
    		.zero_o  (zero)
    	    );

    Adder Adder2(
            .src1_i(adder1),
    	    .src2_i(shifter),
    	    .sum_o (adder2)
    	    );

    Shift_Left_Two_32 Shifter(
            .data_i(se),
            .data_o(shifter)
            );

    MUX_2to1 #(.size(32)) Mux_PC_Source_old(
            .data0_i (adder1),
            .data1_i (adder2),
            .select_i(branch_result),
            .data_o  (mux_pc_source_old)
            );

    Shift_Left_Two_32 Jump_shift(
            .data_i(instruction[25:0]),
            .data_o(jump_shift)
            );

    MUX_2to1 #(.size(32)) Mux_PC_Source(
            .data0_i({adder1[31:28], jump_shift}),
            .data1_i(mux_pc_source_old),
            .select_i(jump),
            .data_o (PC_to_NPC)
            );



    MUX_2to1 #(.size(32)) Mux_NPC_Source(
            .data0_i(PC_to_NPC),
            .data1_i(read_data_1),
            .select_i(ALU_jr_ctrl),
            .data_o (mux_pc_source)
            );

    MUX_4to1 #(.size(32)) MUX_Mem_Reg_Write(
            .data0_i(alu),
            .data1_i(mem_read_data),
            .data2_i(se),
            .data3_i(adder1),
            .select_i(mem_to_reg),
            .data_o(write_reg)
            );

    Data_Memory Data_Memory(
            	.clk_i(clk_i),
            	.addr_i(alu),
            	.data_i(read_data_2),
            	.MemRead_i(mem_read),
            	.MemWrite_i(mem_write),
            	.data_o(mem_read_data)
            );

    wire ble_o = ~(zero | alu[31]);
    wire blt_o = ~alu[31];
    wire bne_o = ~zero;
    MUX_4to1 #(.size(1)) MUX_Branch(
            .data0_i(zero),
            .data1_i(ble_o),
            .data2_i(blt_o),
            .data3_i(bne_o),
            .select_i(branch_type),
            .data_o(branch_type_result)
            );

endmodule
`endif//SIMPLE_SINGLE_CPU
