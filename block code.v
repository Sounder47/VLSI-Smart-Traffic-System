// Smart Traffic Light Controller (FSM based) - Pure Verilog version
`timescale 1ns/1ps
module traffic_light_controller(
    input clk, reset,
    input ped_req,              // Pedestrian request button
    input ns_density, ew_density, // Lane density inputs (1 = heavy, 0 = light)
    output reg [2:0] ns_light,  // {Red, Yellow, Green}
    output reg [2:0] ew_light,  // {Red, Yellow, Green}
    output reg ped_signal       // Pedestrian Walk signal
);
    // FSM States (encoded as binary)
    parameter S_NS_GREEN   = 3'b000,
              S_NS_YELLOW  = 3'b001,
              S_ALL_RED1   = 3'b010,
              S_EW_GREEN   = 3'b011,
              S_EW_YELLOW  = 3'b100,
              S_ALL_RED2   = 3'b101,
              S_PED        = 3'b110;
    reg [2:0] state, next_state;
    // Timer
    integer timer;
    parameter GREEN_TIME = 10;
    parameter YELLOW_TIME = 3;
    parameter RED_TIME = 2;
    parameter PED_TIME = 5;
    parameter EXTEND = 5; // extension if density is high
    // FSM Sequential Block
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_NS_GREEN;
            timer <= 0;
        end else begin
            state <= next_state;
            if (state != next_state) timer <= 0;
            else timer <= timer + 1;
        end
    end
    // FSM Combinational Block
    always @(*) begin
        // Default outputs
        ns_light = 3'b100; // Red
        ew_light = 3'b100; // Red
        ped_signal = 1'b0;
        next_state = state;
        case (state)
            S_NS_GREEN: begin
                ns_light = 3'b001; // Green
                if ((timer >= GREEN_TIME && !ns_density) || 
                    (timer >= (GREEN_TIME+EXTEND))) 
                    next_state = S_NS_YELLOW;
            end
            S_NS_YELLOW: begin
                ns_light = 3'b010; // Yellow
                if (timer >= YELLOW_TIME) next_state = S_ALL_RED1;
            end
            S_ALL_RED1: begin
                if (timer >= RED_TIME) begin
                    if (ped_req) next_state = S_PED;
                    else next_state = S_EW_GREEN;
                end
            end
            S_EW_GREEN: begin
                ew_light = 3'b001; // Green
                if ((timer >= GREEN_TIME && !ew_density) || 
                    (timer >= (GREEN_TIME+EXTEND))) 
                    next_state = S_EW_YELLOW;
            end
            S_EW_YELLOW: begin
                ew_light = 3'b010; // Yellow
                if (timer >= YELLOW_TIME) next_state = S_ALL_RED2;
            end
            S_ALL_RED2: begin
                if (timer >= RED_TIME) begin
                    if (ped_req) next_state = S_PED;
                    else next_state = S_NS_GREEN;
                end
            end
            S_PED: begin
                ped_signal = 1'b1;
                if (timer >= PED_TIME) next_state = S_NS_GREEN;
            end
            default: next_state = S_NS_GREEN;
        endcase
    end
endmodule
