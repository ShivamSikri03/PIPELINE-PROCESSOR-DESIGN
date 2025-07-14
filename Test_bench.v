`timescale 1ns/1ps
module tb_pipelined_cpu;

    reg clk;
    reg reset;

    // Instantiate the CPU
    pipelined_cpu cpu (
        .clk(clk),
        .reset(reset)
    );

    // Clock generator: 10ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("pipline.vcd");
      $dumpvars(0,tb_pipelined_cpu);
        $display("Starting simulation...");
        $monitor("Time=%0t | PC=%0d | WB_RD=%0d | WB_RESULT=%h | WB_WE=%b",
                 $time, cpu.pc, cpu.wb_rd, cpu.wb_result, cpu.wb_we);

        // Initialize signals
        clk = 0;
        reset = 1;

        #10 reset = 0;

        #100;

        $display("Simulation finished.");
        $finish;
    end

endmodule
