module pipelined_cpu (
    input clk,
    input reset
);

    reg [3:0] pc;

    // IF stage
    wire [15:0] instr;
    instr_mem imem (.pc(pc), .instr(instr));
    reg [15:0] if_id_instr;

    // ID stage
    wire [3:0] rs1 = if_id_instr[13:10];
    wire [3:0] rs2 = if_id_instr[9:6];
    wire [3:0] rd  = if_id_instr[5:2];
    wire [1:0] opcode = if_id_instr[15:14];

    wire [15:0] rd1, rd2;
    reg_file rf (
        .clk(clk),
        .we(wb_we),
        .ra1(rs1), .ra2(rs2),
        .wa(wb_rd),
        .wd(wb_result),
        .rd1(rd1), .rd2(rd2)
    );

    reg [15:0] id_ex_rd1, id_ex_rd2;
    reg [3:0]  id_ex_rd;
    reg [1:0]  id_ex_opcode;

    
    reg [15:0] ex_result;
    always @(*) begin
        case (id_ex_opcode)
            2'b00: ex_result = id_ex_rd1 + id_ex_rd2; // ADD
            2'b01: ex_result = id_ex_rd1 - id_ex_rd2; // SUB
            2'b10: ex_result = id_ex_rd1 + id_ex_rd2; // LOAD addr calc
            default: ex_result = 0;
        endcase
    end

    // WB stage
    reg [3:0]  wb_rd;
    reg [15:0] wb_result;
    reg        wb_we;

    // Pipeline control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
            if_id_instr <= 0;
            id_ex_rd1 <= 0; id_ex_rd2 <= 0; id_ex_opcode <= 0; id_ex_rd <= 0;
            wb_result <= 0; wb_rd <= 0; wb_we <= 0;
        end else begin
            // Update PC
            pc <= pc + 1;

            // IF/ID pipeline register
            if_id_instr <= instr;

            // ID/EX pipeline register
            id_ex_rd1 <= rd1;
            id_ex_rd2 <= rd2;
            id_ex_opcode <= opcode;
            id_ex_rd <= rd;

            // EX/WB pipeline register
            wb_result <= ex_result;
            wb_rd <= id_ex_rd;
            wb_we <= (id_ex_opcode == 2'b00 || id_ex_opcode == 2'b01);
        end
    end
endmodule
