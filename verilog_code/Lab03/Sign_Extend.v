`ifndef SIGN_EXTEND_V
`define SIGN_EXTEND_V
module Sign_Extend(
    data_i,
    data_o
    );

    //I/O ports
    input   [16-1:0] data_i;
    output  [32-1:0] data_o;

    //Internal Signals
    reg     [32-1:0] data_o;

integer i;
    //Sign extended
    always @ ( * ) begin
        for(i = 16; i < 32; i = i + 1) begin
            data_o[i] = data_i[15];
        end
        data_o[15: 0] = data_i[15:0];
    end

endmodule
`endif //SIGN_EXTEND_V
