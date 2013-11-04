`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// This module generates a 1Mhz clock for the 6502 MPU (from a 50Mhz clock).
//
//////////////////////////////////////////////////////////////////////////////////

module mpu_clock_div(
	input clk,
	input rst,
	input clk_en, // debounced clock_enable switch
	input step_press, // debounced step button
	output reg mpu_clk
	);

// 1Mhz with 50% duty cycle. 
localparam PERIOD = 24; 

reg [4:0] clk_count = 5'b0; 

always @(posedge clk) begin
  if(rst) begin
    clk_count <= 5'b0;
    mpu_clk <= 1'b0;
    end
  else begin
    if(clk_count == PERIOD) begin
      clk_count <= 5'b0;	// reset counter
      mpu_clk <= ~mpu_clk; // toggle mpu clock
      end
    //if (clk_en && mpu_clk) begin
      //clock stops high when clk_en is true. 
      //end
    else clk_count <= clk_count + 5'b1;
    end
end
  
endmodule
