# Timing constraints for DE10-Standard NIDS
# Clock: 50 MHz (20 ns period)

# Create clock
create_clock -name clk -period 20.0 [get_ports {clk}]

# Clock uncertainty
derive_clock_uncertainty

# Input delays (relative to clock)
set_input_delay -clock clk -max 2.0 [all_inputs]
set_input_delay -clock clk -min 0.5 [all_inputs]

# Output delays
set_output_delay -clock clk -max 2.0 [all_outputs]
set_output_delay -clock clk -min 0.5 [all_outputs]

# False paths
set_false_path -from [get_ports {rst_n}]
set_false_path -to [get_ports {attack_detected}]
