`timescale 1ns/1ps

module RAM_tb;
    reg i_clk, i_rst, i_write_en;
    reg [2:0] i_addr;
    reg [7:0] i_write_data;
    wire [7:0] o_read_data;


RAM uut(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_write_en(i_write_en),
    .i_addr(i_addr),
    .i_write_data(i_write_data),
    .o_read_data(o_read_data)
);

always #5 i_clk = ~i_clk;

initial begin
    i_clk = 0;
    i_rst = 1;
    i_write_en = 0;
    i_addr = 0;
    i_write_data = 0;

    #10;
    i_rst = 0;

    //Read values in RAM, Should be all zero
    #10 i_addr = 3'b000;
    #10 i_addr = 3'b001;
    #10 i_addr = 3'b010;
    #10 i_addr = 3'b011;
    #10 i_addr = 3'b100;
    #10 i_addr = 3'b101;
    #10 i_addr = 3'b110;
    #10 i_addr = 3'b111;

    //Write new values to RAM, each value corresponds to its address
    #10 i_write_en = 1; i_addr = 3'b000; i_write_data = 8'b00000000;
    #10 i_addr = 3'b001; i_write_data = 8'b00000001;
    #10 i_addr = 3'b010; i_write_data = 8'b00000010;
    #10 i_addr = 3'b011; i_write_data = 8'b00000011;
    #10 i_addr = 3'b100; i_write_data = 8'b00000100;
    #10 i_addr = 3'b101; i_write_data = 8'b00000101;
    #10 i_addr = 3'b110; i_write_data = 8'b00000110;
    #10 i_addr = 3'b111; i_write_data = 8'b00000111;
    #10 i_write_en = 0;

    //Read values in RAM
    #10 i_addr = 3'b000;
    #10 i_addr = 3'b001;
    #10 i_addr = 3'b010;
    #10 i_addr = 3'b011;
    #10 i_addr = 3'b100;
    #10 i_addr = 3'b101;
    #10 i_addr = 3'b110;
    #10 i_addr = 3'b111;

    //Reset
    #10 i_rst = 1;
    #10 i_rst = 0;

    //Read values in RAM, should all be zero 
    #10 i_addr = 3'b000;
    #10 i_addr = 3'b001;
    #10 i_addr = 3'b010;
    #10 i_addr = 3'b011;
    #10 i_addr = 3'b100;
    #10 i_addr = 3'b101;
    #10 i_addr = 3'b110;
    #10 i_addr = 3'b111;

    #10 $finish;

end
endmodule 