module ROM (
    input [2:0] ROM_addr,
    output reg [3:0] ROM_data
);

//ROM assignment
always @(ROM_addr) begin
    case(ROM_addr)
        3'b000: ROM_data = 4'b0000; //0
        3'b001: ROM_data = 4'b1100; //12
        3'b010: ROM_data = 4'b0110; //6
        3'b011: ROM_data = 4'b0111; //7
        3'b100: ROM_data = 4'b1000; //8
        3'b101: ROM_data = 4'b0001; //1
        3'b110: ROM_data = 4'b1101; //13
        3'b111: ROM_data = 4'b1110; //14
        default: ROM_data = 4'b0000;
    endcase
end

endmodule