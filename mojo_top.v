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
   output mpu_rst       // reset
	 );

wire rst = ~rst_n;

assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

assign data_bus = 8'hEA; // puts NOP instruction to the 6502 data bus
assign bus_en = 1'b0;	// for now hold the 6502 bus enable low
assign mpu_reset = 1'b0; // reset held low
	 
assign led[7:2] = 6'b0;
assign led[0] = clk_en;
assign led[1] = step_btn_status;

mpu_clock_div mpu_clock_divider (
   .clk(clk),
   .rst(rst),
   .clk_en(clk_en),
   .step_press(step_press),
   .mpu_clk(mpu_clk)
   );

debounce reset_switch_debounce (
   .clk(clk),
   .PB(clk_switch),	
   .PB_state(clk_en),
   .PB_down(clk_en_down),
   .PB_up(clk_en_up)
   );

debounce step_btn_debounce (
   .clk(clk),
   .PB(step_btn),
   .PB_state(step_btn_status),
   .PB_down(step_press),
   .PB_up(step_up)
   );

endmodule