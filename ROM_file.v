module ROM_file(
    input [2:0] ROM_addr,
    output reg [3:0] ROM_data
);

//8 4-bit wide memory locations
reg [3:0] ROM_mem [0:7];

//Read/load data from txt into ROM_mem array
initial begin
    $readmemb("ROMdata.txt", ROM_mem);
end

//When ROM_addr updates, ROM_data nor reflects data held at new address
always @(*) begin
    ROM_data = ROM_mem[ROM_addr];
end

endmodule