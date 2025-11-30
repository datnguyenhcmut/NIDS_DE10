// FPGA Test Controller with Button Control
// Use buttons to navigate through test cases stored in memory
// Display test number on LEDs and results on 7-segment

`timescale 1ns/1ps

module fpga_test_controller (
    input  logic        clk,           // 50 MHz clock
    input  logic        rst_n,         // Reset button (active low)
    input  logic        btn_next,      // Button to next test case
    input  logic        btn_prev,      // Button to previous test case
    output logic [9:0]  led,           // LED[3:0]=test_id, LED[4]=attack, LED[9:5]=score
    output logic [6:0]  hex0,          // 7-seg: test number (ones)
    output logic [6:0]  hex1           // 7-seg: test number (tens)
);

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter N_FEATURES = 28;
    parameter N_TESTS = 10;
    
    // Test vector memory (initialized from .mif file in Quartus)
    logic [DATA_WIDTH-1:0] test_memory [0:N_TESTS*N_FEATURES-1];
    
    // Initialize memory from file
    initial begin
        $readmemh("test_vectors.mem", test_memory);
    end
    
    // Test control signals
    logic [3:0] current_test;          // Current test ID (0-9)
    logic [9:0] memory_addr;           // Memory address = test_id * 28
    
    // Button debouncing
    logic btn_next_sync, btn_next_prev, btn_next_pulse;
    logic btn_prev_sync, btn_prev_prev, btn_prev_pulse;
    logic [15:0] debounce_counter;
    
    // DUT signals
    logic [DATA_WIDTH-1:0] pkt_features [N_FEATURES-1:0];
    logic pkt_valid;
    logic attack_detected;
    logic [31:0] major_score;
    logic [31:0] minor_score;
    logic valid_out;
    
    // FSM for test execution
    typedef enum logic [2:0] {
        IDLE,
        LOAD_FEATURES,
        START_DETECTION,
        WAIT_RESULT,
        DISPLAY
    } state_t;
    
    state_t state;
    logic [4:0] feature_index;
    logic [15:0] wait_counter;
    
    //=================================================================
    // Button Debouncing and Edge Detection
    //=================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            btn_next_sync <= 1'b0;
            btn_next_prev <= 1'b0;
            btn_prev_sync <= 1'b0;
            btn_prev_prev <= 1'b0;
            debounce_counter <= 16'h0;
        end else begin
            // Synchronize buttons
            btn_next_sync <= ~btn_next;  // Active low buttons
            btn_next_prev <= btn_next_sync;
            
            btn_prev_sync <= ~btn_prev;
            btn_prev_prev <= btn_prev_sync;
            
            debounce_counter <= debounce_counter + 1;
        end
    end
    
    // Edge detection (rising edge = button press)
    assign btn_next_pulse = btn_next_sync && !btn_next_prev && (debounce_counter == 16'hFFFF);
    assign btn_prev_pulse = btn_prev_sync && !btn_prev_prev && (debounce_counter == 16'hFFFF);
    
    //=================================================================
    // Test Case Selection
    //=================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_test <= 4'h0;
        end else begin
            if (state == IDLE || state == DISPLAY) begin
                if (btn_next_pulse) begin
                    if (current_test < N_TESTS - 1)
                        current_test <= current_test + 1;
                    else
                        current_test <= 4'h0;  // Wrap around
                end else if (btn_prev_pulse) begin
                    if (current_test > 0)
                        current_test <= current_test - 1;
                    else
                        current_test <= N_TESTS - 1;  // Wrap around
                end
            end
        end
    end
    
    // Calculate memory base address for current test
    assign memory_addr = current_test * N_FEATURES;
    
    //=================================================================
    // Feature Loading FSM
    //=================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            feature_index <= 5'h0;
            pkt_valid <= 1'b0;
            wait_counter <= 16'h0;
        end else begin
            case (state)
                IDLE: begin
                    pkt_valid <= 1'b0;
                    feature_index <= 5'h0;
                    wait_counter <= 16'h0;
                    
                    // Auto-start when test changes or on button press
                    if (btn_next_pulse || btn_prev_pulse) begin
                        state <= LOAD_FEATURES;
                    end
                end
                
                LOAD_FEATURES: begin
                    // Load all 28 features from memory
                    if (feature_index < N_FEATURES) begin
                        pkt_features[feature_index] <= test_memory[memory_addr + feature_index];
                        feature_index <= feature_index + 1;
                    end else begin
                        state <= START_DETECTION;
                        feature_index <= 5'h0;
                    end
                end
                
                START_DETECTION: begin
                    pkt_valid <= 1'b1;
                    state <= WAIT_RESULT;
                end
                
                WAIT_RESULT: begin
                    pkt_valid <= 1'b0;
                    if (valid_out) begin
                        state <= DISPLAY;
                    end else if (wait_counter > 16'd5000) begin
                        state <= IDLE;  // Timeout
                    end else begin
                        wait_counter <= wait_counter + 1;
                    end
                end
                
                DISPLAY: begin
                    // Stay here, showing results
                    // Can change test with buttons
                    if (btn_next_pulse || btn_prev_pulse) begin
                        state <= LOAD_FEATURES;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end
    
    //=================================================================
    // Instantiate PCA Detector
    //=================================================================
    top_pipeline dut (
        .clk(clk),
        .rst_n(rst_n),
        .pkt_features(pkt_features),
        .pkt_valid(pkt_valid),
        .attack_detected(attack_detected),
        .major_score(major_score),
        .minor_score(minor_score),
        .valid_out(valid_out)
    );
    
    //=================================================================
    // LED Output Mapping
    //=================================================================
    always_comb begin
        // LED[3:0]: Current test ID (0-9)
        led[3:0] = current_test;
        
        // LED[4]: Attack detected flag
        led[4] = attack_detected && (state == DISPLAY);
        
        // LED[9:5]: Major score MSBs (for visual indication)
        led[9:5] = major_score[31:27];
    end
    
    //=================================================================
    // 7-Segment Display Decoder
    //=================================================================
    logic [3:0] digit_ones, digit_tens;
    
    // Split test number into digits
    always_comb begin
        digit_ones = current_test % 10;
        digit_tens = current_test / 10;
    end
    
    // Instantiate 7-segment decoders
    seven_seg_decoder seg0 (
        .digit(digit_ones),
        .segments(hex0)
    );
    
    seven_seg_decoder seg1 (
        .digit(digit_tens),
        .segments(hex1)
    );

endmodule

//=================================================================
// 7-Segment Display Decoder Module
//=================================================================
module seven_seg_decoder (
    input  logic [3:0] digit,
    output logic [6:0] segments  // Active low: {g,f,e,d,c,b,a}
);
    always_comb begin
        case (digit)
            4'h0: segments = 7'b1000000; // 0
            4'h1: segments = 7'b1111001; // 1
            4'h2: segments = 7'b0100100; // 2
            4'h3: segments = 7'b0110000; // 3
            4'h4: segments = 7'b0011001; // 4
            4'h5: segments = 7'b0010010; // 5
            4'h6: segments = 7'b0000010; // 6
            4'h7: segments = 7'b1111000; // 7
            4'h8: segments = 7'b0000000; // 8
            4'h9: segments = 7'b0010000; // 9
            default: segments = 7'b1111111; // Blank
        endcase
    end
endmodule
