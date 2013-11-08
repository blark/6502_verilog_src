module message_printer (
    input clk,
    input rst,
    input [7:0] data_bus,
    input [15:0] addr_bus,
    output [7:0] tx_data,
    output reg new_tx_data,
    input tx_busy,
    input [7:0] rx_data,
    input new_rx_data
    );
 
localparam STATE_SIZE = 2; // don't forget to change this when you add a STATE
localparam IDLE = 0,
           PRINT_BUS_DEBUG = 1,
           INPUT_DATA_BUS = 2;
 
localparam MESSAGE_LEN = 23;
 
reg [STATE_SIZE-1:0] state_d, state_q;
 
reg [4:0] addr_d, addr_q;
reg [15:0] addr_bus_d, addr_bus_q;

message_rom message_rom (
    .clk(clk),
    .addr(addr_q),
    .data(tx_data),
    .data_bus(data_bus),
    .addr_bus(addr_bus)
);
 
always @(*) begin
    state_d = state_q; // default values
    addr_d = addr_q;   // needed to prevent latches
    addr_bus_d = addr_bus; // assign address on bus to input of address bus flipflop
    new_tx_data = 1'b0;
 
    case (state_q)
        IDLE: begin
            instr_cnt = 2'b0;
            addr_d = 5'd0;
            if ((new_rx_data && rx_data == "h") || (addr_bus_q != addr_bus_d)) begin //compare flipflop values to see if they have changed
                state_d = PRINT_BUS_DEBUG;
                end
            else if (new_rx_data && rx_data == "a") begin
                state_d = INPUT_DATA_BUS;
                end
        end
        PRINT_BUS_DEBUG: begin
            if (!tx_busy) begin
                new_tx_data = 1'b1;
                addr_d = addr_q + 1'b1;
                if (addr_q == MESSAGE_LEN-1)
                    state_d = IDLE;
            end
        end
        INPUT_DATA_BUS: begin
        end // input_data_bus
      default: state_d = IDLE;
    endcase
end
 
always @(posedge clk) begin
    if (rst) begin
        state_q <= IDLE;  // from reset go to IDLEa
    end else begin
        state_q <= state_d;
    end

    addr_bus_q <= addr_bus_d; // move address on addr_bus over to output side of flipflop
    
    addr_q <= addr_d;
end
 
endmodule