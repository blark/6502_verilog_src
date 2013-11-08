module message_rom (
    input clk,
    input [4:0] addr,      // location to transmit
    input [7:0] data_bus,  // 6502
    input [15:0] addr_bus, // 6502
    output [7:0] data      // output to tx_data in message_printer
);

wire [7:0] rom_data [23:0];
assign rom_data[0] = "D";
assign rom_data[1] = "a";
assign rom_data[2] = "t";
assign rom_data[3] = "a";
assign rom_data[4] = " ";
assign rom_data[5] = "$";
assign rom_data[6] = "-"; // reserved
assign rom_data[7] = "-"; // reserved
assign rom_data[8] = ""; 
assign rom_data[9] = "\t";
assign rom_data[10] = "A";
assign rom_data[11] = "d";
assign rom_data[12] = "d";
assign rom_data[13] = "r";
assign rom_data[14] = " ";
assign rom_data[15] = "$";
assign rom_data[16] = "-"; // reserved
assign rom_data[17] = "-"; // reserved
assign rom_data[18] = "-"; // reserved
assign rom_data[19] = "-"; // reserved
assign rom_data[20] = ""; 
assign rom_data[21] = "\n";
assign rom_data[22] = "\r";
assign rom_data[23] = "$";
 
// convert nibble to hex value
wire [7:0] hex_lut [15:0];
assign hex_lut[0] = "0";
assign hex_lut[1] = "1";
assign hex_lut[2] = "2";
assign hex_lut[3] = "3";
assign hex_lut[4] = "4";
assign hex_lut[5] = "5";
assign hex_lut[6] = "6";
assign hex_lut[7] = "7";
assign hex_lut[8] = "8";
assign hex_lut[9] = "9";
assign hex_lut[10] = "A";
assign hex_lut[11] = "B";
assign hex_lut[12] = "C";
assign hex_lut[13] = "D";
assign hex_lut[14] = "E";
assign hex_lut[15] = "F";


reg [7:0] data_d, data_q;
 
assign data = data_q; // this outputs data to the message_printer
 
always @(*) begin
    // 1 byte data bus
    if (addr == 6) data_d = hex_lut[data_bus[7:4]];
    else if (addr == 7) data_d = hex_lut[data_bus[3:0]];
    // 2 byte addr bus
    else if (addr == 16) data_d = hex_lut[addr_bus[15:12]];
    else if (addr == 17) data_d = hex_lut[addr_bus[11:8]];
    else if (addr == 18) data_d = hex_lut[addr_bus[7:4]];
    else if (addr == 19) data_d = hex_lut[addr_bus[3:0]];
    else if (addr > 23)
        data_d = " ";
    else
        data_d = rom_data[addr];
end
 
always @(posedge clk) begin
    data_q <= data_d;
end
 
endmodule
