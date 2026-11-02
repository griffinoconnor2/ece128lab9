module RegFile (
    input W, DA, SA1, SA2, clk, rst,
    input [3:0] data_in, //from rom
    output [3:0] data_out1, data_out2
);

//Declare registers
reg [3:0] R0, R1;

//Sequential decoder logic to write registers
always @(posedge clk) begin
    if (rst == 1'b1) begin
        R0 <= 4'b0000;
        R1 <= 4'b0000;
    end
    else if (W == 1'b1) begin //write mode enabled
        case(DA) //decode 1 bit DA to either possible register to overwrite
            1'b0: R0 <= data_in; 
            1'b1: R1 <= data_in;
        endcase
    end
end

//Mux logic using ControlUnit selectors
assign data_out1 = SA1 ? R1 : R0; //Write R1 when SA1 high, R0 when SA1 low (SA1 always low in this design)
assign data_out2 = SA2 ? R1 : R0; //Write R1 when SA2 high, R0 when SA1 low (SA2 always high in this design)

endmodule