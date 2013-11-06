// ----------------------------------------------------------------------------- 
//
// This module generates a 1Mhz clock for the 6502 MPU (from 50Mhz clock).
// clk_en switch stops the clock high, and the single_step button will pull it
// low for .5us before returning to high.
//
// ----------------------------------------------------------------------------- 

module mpu_clock_div(
	input clk,
	input rst,
	input clk_en,        // debounced clock_en switch
	input single_step,   // debounced single step, high for one clk cycle
	output reg mpu_clk
	);

// 1Mhz with 50% duty cycle. 
localparam PERIOD = 5'd24; 

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
    else if (mpu_clk && clk_en) begin  // stop mpu_clk high for the 6502
      if (single_step) begin  // single_step was pressed
         clk_count <= 5'b0;
         mpu_clk <= 0; // run one cycle 
         end
      end
    else clk_count <= clk_count + 1'b1;
    end
end

endmodule