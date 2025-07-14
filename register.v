module reg_file (
    input clk,
    input we,
    input [3:0] ra1, ra2, wa,
    input [15:0] wd,
    output [15:0] rd1, rd2
);
    reg [15:0] regs [0:15];

    assign rd1 = regs[ra1];
    assign rd2 = regs[ra2];

    always @(posedge clk) begin
        if (we)
            regs[wa] <= wd;
    end
endmodule
