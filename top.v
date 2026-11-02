module top(
    input clk, rst,
    input [2:0] rom_adr1, rom_adr2, ram_adr,
    output [6:0] cat,
    output [3:0] an,
    output rdy
);
    //Wires for Control unit
    wire W_R, W, DA, SA1, SA2;
    wire [2:0] rom_adr;

    ControlUnit uut0(
        .clk(clk),
        .rst(rst),
        .rom_adr1(rom_adr1),
        .rom_adr2(rom_adr2),
        .W_R(W_R),
        .W(W),
        .DA(DA),
        .SA1(SA1),
        .SA2(SA2),
        .rom_adr(rom_adr)
    );

    //Wires for ROM
    wire [3:0] ROM_data;

    ROM uut1(
        .ROM_addr(rom_adr),
        .ROM_data(ROM_data)
    );

    //Wires for reg file
    wire [3:0] data_out1, data_out2;

    RegFile uut2(
        .clk(clk),
        .rst(rst),
        .W(W),
        .DA(DA),
        .SA1(SA1),
        .SA2(SA2),
        .data_in(ROM_data),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );

    //Wires for multiplier
    wire [7:0] productin;
    reg [7:0] productreg;

    multiplierCombinational uut3(
        .a(data_out1),
        .b(data_out2),
        .p(productin)
    );

    //Makes sure that the product output remains completely static between clock cycles
    always @(posedge clk) begin
        if(rst)
            productreg <= 8'b0;
        else
            productreg <= productin;
    end

    //Wires for RAM
    wire [7:0] o_read_data;

    RAM uut4(
        .i_clk(clk),
        .i_rst(rst),
        .i_write_en(W_R),
        .i_addr(ram_adr),
        .i_write_data(productreg),
        .o_read_data(o_read_data)
    );

    wire rstn = ~rst;
    SevenSegDisplay uut5(
        .clk(clk),
        .rst(rstn),
        .count(o_read_data),
        .cat(cat),
        .an(an),
        .rdy(rdy)
    );

endmodule 