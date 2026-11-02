module ControlUnit(
    input clk, rst,
    input [2:0] rom_adr1, rom_adr2,
    output reg [2:0] rom_adr,
    output reg W, DA, SA1, SA2, W_R
);

//Define states and Next/Present State variables
parameter S0_idle = 0, S1_read_rom1 = 1, S2_read_rom2 = 2, S3_write_ram = 3, S4_read_ram = 4;
reg [2:0] NS, PS;

//Combinational State Transtion logic
always @(*) begin
    case(PS)
        S0_idle: NS = S1_read_rom1;
        S1_read_rom1: NS = S2_read_rom2;
        S2_read_rom2: NS = S3_write_ram;
        S3_write_ram: NS = S4_read_ram;
        S4_read_ram: NS = S0_idle;
        default: NS = S0_idle;
    endcase
end

//Sequential State Transition Logic
always @(posedge clk) begin
    if (rst == 1)
        PS <= S0_idle;
    else
        PS <= NS;
end

//Control Unit Logic
always @(*) begin
    if (rst == 1'b1) begin
        rom_adr = 3'b000;
        W = 1'b0;
        DA = 1'b0;
        SA1 = 1'b0;
        SA2 = 1'b0;
        W_R = 1'b0;
    end
    else begin
        case(PS)
            S0_idle: begin
                rom_adr = 3'b000;
                W = 1'b0; //Enable for reg file (1 allows data to be overwritten)
                DA = 1'b0; //Selector for register in reg file (0 = reg 0, 1 = reg 1)
                SA1 = 1'b0; //Selector to decide which reg goes to output data 1 in reg file (0 = reg 0, 1 = reg 1)
                SA2 = 1'b0; //Selector to decide which reg goes to output data 2 in reg file (0 = reg 0, 1 = reg 1))
                W_R = 1'b0; //Enable for read read/write (1 allows writeing, 0 allows reading)
            end
            S1_read_rom1: begin //read line from rom and write to reg file slot 0 (DA = 0)
                rom_adr = rom_adr1;
                W = 1'b1;
                DA = 1'b0;
                SA1 = 1'b0; //Currently, SA1 and SA2 always 0 and 1 as register file only holds two registers (for multiplicand and multiplier)
                SA2 = 1'b1; //If the system was scaled to require more operands, more complex selector logic would be put to use 
                W_R = 1'b0;
            end
            S2_read_rom2: begin //read line from rom and write to reg file slot 1 (DA = 1)
                rom_adr = rom_adr2;
                W = 1'b1;
                DA = 1'b1;
                SA1 = 1'b0;
                SA2 = 1'b1;
                W_R = 1'b0;
            end
            S3_write_ram: begin //write product to ram
                rom_adr = 3'b000;
                W = 1'b0;
                DA = 1'b0;
                SA1 = 1'b0;
                SA2 = 1'b1;
                W_R = 1'b1;
            end
            S4_read_ram: begin //read product from ram to illuminate 7SD
                rom_adr = 3'b000; 
                W = 1'b0;
                DA = 1'b0;
                SA1 = 1'b0;
                SA2 = 1'b1;
                W_R = 1'b0;
            end
            default: begin
                rom_adr = 3'b000;
                W = 1'b0;
                DA = 1'b0;
                SA1 = 1'b0;
                SA2 = 1'b0;
                W_R = 1'b0;
            end
        endcase
    end
end

endmodule