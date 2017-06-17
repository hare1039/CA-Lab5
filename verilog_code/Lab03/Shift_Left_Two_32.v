`ifndef SHIFT_LEFT_LEFT_32_V
`define SHIFT_LEFT_LEFT_32_V

module Shift_Left_Two_32(
    data_i,
    data_o
    );

//I/O ports
input  [32-1:0] data_i;
output [32-1:0] data_o;

//shift left 2
assign data_o[31:0] = { data_i[29:0], 2'b00 };

endmodule
`endif // SHIFT_LEFT_LEFT_32_V
