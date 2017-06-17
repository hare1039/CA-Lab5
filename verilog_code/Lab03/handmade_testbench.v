`define END_COUNT 25

`include "Shift_Left_Two_32.v"
module TestBench;

    //Internal Signals
    reg         CLK = 1;

    //Create tested modle

    wire [32-1:0] x;
    reg  [32-1:0] y, z;
    reg  sel;
    Shift_Left_Two_32 Shifter(
            .data_i(y),
            .data_o(x)
            );
    //Main function

    always #10 CLK = ~CLK;

    initial  begin
        y = 1;
        sel = 1;
        #20;
        y = -1111111;
        sel = 0;
        #20
        y = 1710923;
        #20;
        $finish;
    end

    //Print result to "CO_P2_Result.txt"
    always@(posedge CLK) begin

    end

    initial begin
        $dumpfile("result.vcd");
        $dumpvars;
    end

endmodule
