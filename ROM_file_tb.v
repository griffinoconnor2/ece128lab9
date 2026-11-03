`timescale 1ns/1ps
module ROM__file_tb();

//Declare internal signals
reg [2:0] ROM_addr;
wire [3:0] ROM_data;

ROM_file uut (.ROM_addr(ROM_addr), .ROM_data(ROM_data));

//Perform tests
initial begin
    //Test Case 1: Sequential ROM Access
    ROM_addr = 3'b000;     //Expect ROM_data = 4'b1010 = 10
    #10 ROM_addr = 3'b001; //Expect ROM_data = 4'b0101 = 5
    #10 ROM_addr = 3'b010; //Expect ROM_data = 4'b1001 = 9
    #10 ROM_addr = 3'b011; //Expect ROM_data = 4'b0110 = 6
    #10 ROM_addr = 3'b100; //Expect ROM_data = 4'b1111 = 15
    #10 ROM_addr = 3'b101; //Expect ROM_data = 4'b0011 = 3
    #10 ROM_addr = 3'b110; //Expect ROM_data = 4'b1100 = 12
    #10 ROM_addr = 3'b111; //Expect ROM_data = 4'b0001 = 1
    #10;

    //Test Case 2: Random ROM Access
    #10 ROM_addr = 3'b001; //Expect ROM_data = 4'b0101 = 5
    #10 ROM_addr = 3'b100; //Expect ROM_data = 4'b1111 = 15
    #10 ROM_addr = 3'b111; //Expect ROM_data = 4'b0001 = 1
    #10 ROM_addr = 3'b000; //Expect ROM_data = 4'b1010 = 10
    #10 ROM_addr = 3'b010; //Expect ROM_data = 4'b1001 = 9
    #10 ROM_addr = 3'b110; //Expect ROM_data = 4'b1100 = 12
    #10 ROM_addr = 3'b011; //Expect ROM_data = 4'b0110 = 6
    #10 ROM_addr = 3'b101; //Expect ROM_data = 4'b0011 = 3
    #10 $finish;
end

endmodule