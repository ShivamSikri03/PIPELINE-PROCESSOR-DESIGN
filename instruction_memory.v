module instr_mem (
    input [3:0] pc,
    output reg [15:0] instr
);
    reg [15:0] mem [0:15];

    initial begin
        
        mem[0] = 16'b0000001000110001; 
        mem[1] = 16'b0100001000110010; 
        mem[2] = 16'b1000010001010011;   
        mem[3] = 16'b0000000000000000;
       
    end

    always @(*) begin
        instr = mem[pc];
    end
endmodule
