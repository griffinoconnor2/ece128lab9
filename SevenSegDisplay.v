//Full 7SD wrapper file containing relevant modules

module SevenSegDisplay(
    input clk, rstn, en,
    input [11:0] count,
    output [6:0] cat,
    output [3:0] an,
    output rdy
);

    wire clk1KHz;
    wire [15:0] bcd;

    ClockDivider u0(.clkin(clk), .rstn(rstn), .clkout1KHz(clk1KHz));
    BintoBCD u1(.clk(clk), .rstn(rstn), .en(en), .count(count), .BCD(bcd), .rdy(rdy));
    MSD u2(.bcd(bcd), .clk(clk1KHz), .rstn(rstn), .cat(cat), .an(an));

endmodule

module BintoBCD(
    input clk, rstn, en, 
    input [11:0] count,
    output reg [15:0] BCD,
    output reg rdy
);

//State encodings
parameter IDLE = 3'b000, SETUP = 3'b001, ADD = 3'b010, SHIFT = 3'b011, DONE = 3'b100; //Ease of reading case statements

reg [2:0] state;
reg [27:0] bcd_data; //16 bits for BCD and 12 for binary
reg [1:0] add_counter; //For each digit
reg  [3:0] sh_counter; //Up to 11
reg busy;

always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        state <= IDLE;
        busy <= 1'b0;
        bcd_data <= 28'b0;
        add_counter <= 2'b0;
        sh_counter <= 4'b0;
        BCD <= 16'b0;
        rdy <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                busy <= 1'b0;
                rdy <= 1'b0;
                if (en) //Enable start setup phase
                    state <= SETUP;
            end

            SETUP: begin //Setup, initialize everything
                busy <= 1'b1;
                rdy <= 1'b0;
                bcd_data <= {16'b0, count};
                add_counter <= 2'b0;
                sh_counter <= 4'b0;
                state <= ADD;
            end

            ADD: begin
                busy <= 1'b1;
                case (add_counter)
                    2'b00: begin
                        if (bcd_data[15:12] > 4)
                            bcd_data[27:12] <= bcd_data[27:12] + 3;
                        add_counter <= add_counter + 1;
                    end

                    2'b01: begin
                        if (bcd_data[19:16] > 4)
                            bcd_data[27:16] <= bcd_data[27:16] + 3;
                        add_counter <= add_counter + 1;
                    end

                    2'b10: begin
                        if (bcd_data[23:20] > 4)
                            bcd_data[27:20] <= bcd_data[27:20] + 3;
                        add_counter <= add_counter + 1;
                    end

                    2'b11: begin
                        if (bcd_data[27:24] > 4)
                            bcd_data[27:24] <= bcd_data[27:24] + 3;
                        add_counter <= 2'b0;
                        state <= SHIFT;
                    end
                endcase
            end

            SHIFT: begin
                busy <= 1'b1;
                sh_counter <= sh_counter + 1;
                bcd_data <= bcd_data << 1;

                if (sh_counter == 4'b1011) //Done shifting
                    state <= DONE;
                else
                    state <= ADD;
            end

            DONE: begin
                busy <= 1'b1;
                rdy <= 1'b1;
                BCD <= bcd_data[27:12];
                state <= IDLE;
            end

            default: state <= IDLE;
        endcase
    end
end 
endmodule

module ClockDivider(
    input clkin, rstn, 
    output clkout1KHz //Self explanatory
    );

    //Intermediate wire to propogate ff0 output to clock of ff1
    wire [16:0] Q;

    //Clock divider for ~1Hz and ~1KHz
    TFF ff0(.clk(clkin), .rstn(rstn), .T(1'b1), .Q(Q[0]));
    TFF ff1(.clk(~Q[0]), .rstn(rstn), .T(1'b1), .Q(Q[1]));
    TFF ff2(.clk(~Q[1]), .rstn(rstn), .T(1'b1), .Q(Q[2]));
    TFF ff3(.clk(~Q[2]), .rstn(rstn), .T(1'b1), .Q(Q[3]));
    TFF ff4(.clk(~Q[3]), .rstn(rstn), .T(1'b1), .Q(Q[4]));
    TFF ff5(.clk(~Q[4]), .rstn(rstn), .T(1'b1), .Q(Q[5]));
    TFF ff6(.clk(~Q[5]), .rstn(rstn), .T(1'b1), .Q(Q[6]));
    TFF ff7(.clk(~Q[6]), .rstn(rstn), .T(1'b1), .Q(Q[7]));
    TFF ff8(.clk(~Q[7]), .rstn(rstn), .T(1'b1), .Q(Q[8]));
    TFF ff9(.clk(~Q[8]), .rstn(rstn), .T(1'b1), .Q(Q[9]));
    TFF ff10(.clk(~Q[9]), .rstn(rstn), .T(1'b1), .Q(Q[10]));
    TFF ff11(.clk(~Q[10]), .rstn(rstn), .T(1'b1), .Q(Q[11]));
    TFF ff12(.clk(~Q[11]), .rstn(rstn), .T(1'b1), .Q(Q[12]));
    TFF ff13(.clk(~Q[12]), .rstn(rstn), .T(1'b1), .Q(Q[13]));
    TFF ff14(.clk(~Q[13]), .rstn(rstn), .T(1'b1), .Q(Q[14]));
    TFF ff15(.clk(~Q[14]), .rstn(rstn), .T(1'b1), .Q(Q[15]));
    TFF ff16(.clk(~Q[15]), .rstn(rstn), .T(1'b1), .Q(clkout1KHz));

endmodule

module TFF(
    input clk, rstn, T,
    output reg Q
);

//TFF Logic 
always @ (posedge clk or negedge rstn) begin
    if (!rstn) //rstn --> active low reset signal (reset when rstn == 0)
        Q <= 1'b0;
    else if (T)
        Q <= ~Q;
    else
        Q <= Q;
end

endmodule

module MSD (
    input [15:0] bcd,
    input clk, rstn,
    output [6:0] cat,
    output [3:0] an
);

//Declare intermediate signals
wire [1:0] ancounter; //To be used as selector for both mux and decoder (numerical digit and place value respectively)
wire [3:0] digit; //To be used to forward selected numerica digit to BCDto7SD

//Instantiate misc. modules to generate anode and cathode signals 
AnodeCounter uut0(.clk(clk), .rstn(rstn), .sel(ancounter));

Mux4to1 uut1(.bcd(bcd), .S(ancounter), .digit(digit));

Decoder2to4 uut2(.S(ancounter), .an(an));

BCDto7SD uut3(.in(digit), .Seg(cat));

endmodule

module BCDto7SD (
    input [3:0] in,
    output reg [6:0] Seg
);

always @(*) begin
    case(in)
        //Input cases 0-9, assign corresponding 7SD output (represented a-g)
        4'b0000: Seg = 7'b0000001; //0
        4'b0001: Seg = 7'b1001111; //1
        4'b0010: Seg = 7'b0010010; //2
        4'b0011: Seg = 7'b0000110; //3
        4'b0100: Seg = 7'b1001100; //4
        4'b0101: Seg = 7'b0100100; //5
        4'b0110: Seg = 7'b0100000; //6
        4'b0111: Seg = 7'b0001111; //7
        4'b1000: Seg = 7'b0000000; //8
        4'b1001: Seg = 7'b0000100; //9
        default: Seg = 7'b1111111; //off

    endcase
end

endmodule

module Mux4to1 (
    input [15:0] bcd, //From BintoBCD
    input [1:0] S, //From anode counter
    output reg [3:0] digit
);

//Selection logic for numerical digit (S = 0, pick ones, S = 1, pick tens, S = 2, pick hundreds, S = 3, pick thousands)
always @(*) begin
    case (S)
        2'b00: digit = bcd[3:0];
        2'b01: digit = bcd[7:4];
        2'b10: digit = bcd[11:8];
        2'b11: digit = bcd[15:12];
        default: digit = 4'b0000;
    endcase
end

endmodule

module Decoder2to4(
    input [1:0] S, //from an counter
    output reg [3:0] an
);

//Selection logic for anode/digit displayed (S = 0, pick ones, S = 1, pick tens, S = 2, pick hundreds, S = 3, pick thousands)
always @(*) begin
    case(S)
        2'b00: an = 4'b1110;
        2'b01: an = 4'b1101;
        2'b10: an = 4'b1011;
        2'b11: an = 4'b0111;
        default: an = 4'b1111;
    endcase

end

endmodule

module AnodeCounter(
    input clk, rstn,
    output reg [1:0] sel
);

//Anode Counting logic (cycle 0-3 quickly to display each digit simultaneously (to human eye))
always @(posedge clk or negedge rstn)
    begin
        if (!rstn)
            sel <= 2'b00;
        else
            sel <= sel + 2'b01;
    end

endmodule