`timescale 1ns/1ps
module tb_traffic_light;
    reg clk, reset;
    reg ped_req;
    reg ns_density, ew_density;
    wire [2:0] ns_light;
    wire [2:0] ew_light;
    wire ped_signal;
    // Instantiate DUT (Device Under Test)
    traffic_light_controller dut (
        .clk(clk),
        .reset(reset),
        .ped_req(ped_req),
        .ns_density(ns_density),
        .ew_density(ew_density),
        .ns_light(ns_light),
        .ew_light(ew_light),
        .ped_signal(ped_signal)
    );
    // Clock generation (10ns period = 100MHz)
    always #5 clk = ~clk;
    initial begin
        // Initialize signals
        clk = 0; reset = 1;
        ped_req = 0; ns_density = 0; ew_density = 0;
        // Apply reset
        #20 reset = 0;
        // Case 1: Normal traffic (no density, no pedestrian)
        #200;
        // Case 2: Heavy NS traffic -> should extend NS green
        ns_density = 1;
        #200;
        ns_density = 0;
        // Case 3: Pedestrian request
        ped_req = 1;
        #50 ped_req = 0;
        // Case 4: Heavy EW traffic
        ew_density = 1;
        #200;
        ew_density = 0;
        // End simulation
        #500 $stop;
    end
    // Monitor signals
    initial begin
        $monitor("Time=%0t | State: NS=%b EW=%b Ped=%b | ns_density=%b ew_density=%b ped_req=%b",
                  $time, ns_light, ew_light, ped_signal, ns_density, ew_density, ped_req);
    end
endmodule
