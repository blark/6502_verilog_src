`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// This module generates a 1Mhz clock for the 6502 MPU. 
//
//////////////////////////////////////////////////////////////////////////////////

module mpu_clock_div(
    input clk,
	 input rst,
	 input clk_en,
	 input step_press,
	 output reg mpu_clk
	 );

localparam PERIOD = 24; // 1Mhz with 50% duty cycle.

reg [4:0] countvalue = 5'b0; 

always @(posedge clk) begin
  if(rst) begin
    countvalue <= 5'b0;
    mpu_clk <= 1'b0;
    end
  else begin
    if(countvalue == PERIOD) begin
      countvalue <= 5'b0;	// reset counter to 00000
      mpu_clk <= ~mpu_clk; // toggle mpu clock signal
      end
	 if (clk_en && mpu_clk) begin
		//clock stops high when clk_en is true. 
	   end
    else countvalue <= countvalue + 5'b1;
    end
end
  
endmodule
