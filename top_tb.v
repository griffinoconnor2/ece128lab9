`timescale 1ns/1ps

module top_tb;
    reg clk, rst;
    reg [2:0] rom_adr1, rom_adr2, ram_adr;

    wire [6:0] cat;
    wire [3:0] an;
    wire rdy;

    top uut(
        .clk(clk),
        .rst(rst),
        .rom_adr1(rom_adr1),
        .rom_adr2(rom_adr2),
        .ram_adr(ram_adr),
        .cat(cat),
        .an(an),
        .rdy(rdy)
    );

    always #5 clk = ~clk;

    initial begin
        //Initialize
        clk = 1'b0; rst = 1'b1;
        rom_adr1 = 3'b000;
        rom_adr2 = 3'b000;
        ram_adr = 3'b000;

        #20;
        rst = 1'b0; //Reslease reset after two clock cyles
        #10;

        //Test case 1: ROM[1] * ROM[2] = RAM[0] (12 * 6 = 72 stored in address 0 of ram)
        rom_adr1 = 3'b001;
        rom_adr2 = 3'b010;
        ram_adr = 3'b000;
        #100;

        //Test case 2: ROM[3] * ROM[4] = RAM[1] (7 * 8 = 56 stored in address 1 of ram)
        rom_adr1 = 3'b011;
        rom_adr2 = 3'b100;
        ram_adr = 3'b001;
        #100;

        //Test case 3: ROM[5] * ROM[6] = RAM[2] (1 * 13 = 13 stored in address 2 of ram)
        rom_adr1 = 3'b101;
        rom_adr2 = 3'b110;
        ram_adr = 3'b010;
        #100;

        //Test case 4: ROM[7] * ROM[0] = RAM[3] (14 * 0 = 0 stored in address 3 of ram)
        rom_adr1 = 3'b111;
        rom_adr2 = 3'b000;
        ram_adr = 3'b011;
        #100;

        //Test Case 5: Read back each result in ram
        ram_adr = 3'b000;
        #50;
        ram_adr = 3'b001;
        #50;
        ram_adr = 3'b010;
        #50;
        ram_adr = 3'b011;
        #50;
        ram_adr = 3'b100;
        #50;
        ram_adr = 3'b101;
        #50;
        ram_adr = 3'b110;
        #50;
        ram_adr = 3'b111;
        #50;

        $finish;
    end
endmodule