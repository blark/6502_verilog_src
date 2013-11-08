module mojo_top(
   input clk,
   input rst_n,
   input cclk,
   output[7:0]led,
   output spi_miso,
   input spi_ss,
   input spi_mosi,
   input spi_sck,
   output [3:0] spi_channel,
   input avr_tx,
   output avr_rx,
   input avr_rx_busy,
   output mpu_clk,
   input step_btn,      // 6502
   input clk_switch,    // ====
   output[7:0]data_bus, // data bus
   input[15:0]addr_bus, // address buss
   output bus_en,       // bus enable (active high)
   output mpu_rst,      // reset
   input mpureset_btn,       // mpu reset
   output single_step
   );

wire rst = ~rst_n;

assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

assign data_bus = 8'hEA; // puts NOP instruction on the 6502 data bus
assign bus_en = 1'b1;	// for now hold the 6502 bus enable low
assign mpu_rst = ~rst_state;
	 
assign led[7:2] = 6'b0;
assign led[0] = clk_en;
assign led[1] = step_state;

wire [7:0] tx_data;
wire new_tx_data;
wire tx_busy;
wire [7:0] rx_data;
wire new_rx_data;

avr_interface avr_interface (
    .clk(clk),
    .rst(rst),
    .cclk(cclk),
    .spi_miso(spi_miso),
    .spi_mosi(spi_mosi),
    .spi_sck(spi_sck),
    .spi_ss(spi_ss),
    .spi_channel(spi_channel),
    .tx(avr_rx), // FPGA tx goes to AVR rx
    .rx(avr_tx),
    .channel(4'd15), // invalid channel disables the ADC
    .new_sample(),
    .sample(),
    .sample_channel(),
    .tx_data(tx_data),
    .new_tx_data(new_tx_data),
    .tx_busy(tx_busy),
    .tx_block(avr_rx_busy),
    .rx_data(rx_data),
    .new_rx_data(new_rx_data)
);

message_printer debugPrinter (
   .clk(clk),
   .rst(rst),
   .tx_data(tx_data),
   .new_tx_data(new_tx_data),
   .tx_busy(tx_busy),
   .rx_data(rx_data),
   .new_rx_data(new_rx_data),
   .data_bus(data_bus),
   .addr_bus(addr_bus)
   );

mpu_clock_div mpu_clock_divider (
   .clk(clk),
   .rst(rst),
   .clk_en(clk_en),
   .single_step(single_step),
   .mpu_clk(mpu_clk)
   );

debounce clock_switch_debounce (
   .clk(clk),
   .PB(clk_switch),	
   .PB_state(clk_en)
   );

debounce step_btn_debounce (
   .clk(clk),
   .PB(step_btn),
   .PB_state(step_state),
   .PB_down(single_step)
   );

debounce mpu_reset (
   .clk(clk),
   .PB(mpureset_btn),
   .PB_state(rst_state)
   );

endmodule