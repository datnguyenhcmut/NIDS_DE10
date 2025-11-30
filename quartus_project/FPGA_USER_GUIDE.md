# FPGA Test Controller - User Guide

## Hardware Interface

### Inputs
- **CLK**: 50 MHz system clock (CLOCK_50 on DE10-Standard)
- **RST_N**: Reset button (KEY[0], active low)
- **BTN_NEXT**: Next test button (KEY[1], active low)
- **BTN_PREV**: Previous test button (KEY[2], active low)

### Outputs
- **LED[3:0]**: Current test case number (0-9)
- **LED[4]**: Attack detected (1=Attack, 0=Normal)
- **LED[9:5]**: Major score bits [31:27] (visual indicator)
- **HEX0**: Test number ones digit
- **HEX1**: Test number tens digit

## Pin Assignment for DE10-Standard

```tcl
# Clock and Reset
set_location_assignment PIN_AF14 -to clk
set_location_assignment PIN_AA14 -to rst_n

# Buttons (KEYs are active low)
set_location_assignment PIN_AA15 -to btn_next  # KEY[1]
set_location_assignment PIN_W15  -to btn_prev  # KEY[2]

# LEDs
set_location_assignment PIN_AA24 -to led[0]
set_location_assignment PIN_AB23 -to led[1]
set_location_assignment PIN_AC23 -to led[2]
set_location_assignment PIN_AD24 -to led[3]
set_location_assignment PIN_AG25 -to led[4]
set_location_assignment PIN_AF25 -to led[5]
set_location_assignment PIN_AE24 -to led[6]
set_location_assignment PIN_AF24 -to led[7]
set_location_assignment PIN_AB22 -to led[8]
set_location_assignment PIN_AC22 -to led[9]

# 7-Segment HEX0 (ones)
set_location_assignment PIN_AE26 -to hex0[0]
set_location_assignment PIN_AE27 -to hex0[1]
set_location_assignment PIN_AE28 -to hex0[2]
set_location_assignment PIN_AG27 -to hex0[3]
set_location_assignment PIN_AF28 -to hex0[4]
set_location_assignment PIN_AG28 -to hex0[5]
set_location_assignment PIN_AH28 -to hex0[6]

# 7-Segment HEX1 (tens)
set_location_assignment PIN_AJ29 -to hex1[0]
set_location_assignment PIN_AH29 -to hex1[1]
set_location_assignment PIN_AH30 -to hex1[2]
set_location_assignment PIN_AG30 -to hex1[3]
set_location_assignment PIN_AF29 -to hex1[4]
set_location_assignment PIN_AF30 -to hex1[5]
set_location_assignment PIN_AD27 -to hex1[6]
```

## Operation Instructions

### 1. Initial Setup
1. Load test_vectors.mif into project (Quartus will initialize Block RAM)
2. Compile and program FPGA
3. Press KEY[0] (RST_N) to reset

### 2. Running Tests
1. **View current test**: Check HEX1:HEX0 for test number (00-09)
2. **Next test**: Press KEY[1] (BTN_NEXT)
3. **Previous test**: Press KEY[2] (BTN_PREV)
4. **Reset**: Press KEY[0] to restart from test 0

### 3. Reading Results

#### LEDs
```
LED[3:0] - Test ID (binary)
   0000 = Test 0
   0001 = Test 1
   ...
   1001 = Test 9

LED[4] - Attack Status
   OFF = Normal traffic detected
   ON  = Attack detected

LED[9:5] - Major Score bits (higher = more anomalous)
```

#### 7-Segment Display
```
HEX1 HEX0
 [T]  [U]    T=Tens, U=Ones
 
Examples:
  0   0  = Test 0
  0   5  = Test 5
  0   9  = Test 9
```

## Test Cases Reference

| Test | Name | Expected | Description |
|------|------|----------|-------------|
| 0 | All zeros | Normal | Baseline test |
| 1 | Small values | Normal | Low traffic |
| 2 | Large src_bytes | Attack | Large data transfer |
| 3 | High connection rate | Attack | DoS pattern |
| 4 | Failed logins | Attack | Brute force |
| 5 | Boundary value | Normal | Near threshold |
| 6 | Random normal | Normal | Random low values |
| 7 | Random attack | Attack | Random high values |
| 8 | Max positive | Attack | Maximum values |
| 9 | Very small | Normal | Minimal traffic |

## Expected Behavior

### Normal Traffic (Tests 0, 1, 6, 9)
- LED[4] = OFF
- LED[9:5] = Low values (00000-00010)

### Attack Traffic (Tests 2, 3, 4, 7, 8)
- LED[4] = ON
- LED[9:5] = High values (variable)

## Troubleshooting

### No response when pressing buttons
- Check debounce timing (16-bit counter @ 50MHz ≈ 1.3ms)
- Verify buttons are connected correctly
- Press and hold briefly

### Wrong test results
- Verify test_vectors.mem is loaded correctly
- Check memory initialization in Quartus
- Review compilation warnings for memory issues

### LEDs not changing
- Verify clock is running (50 MHz)
- Check reset is released (RST_N = high)
- Ensure valid_out signal is asserted

## Memory Map

Each test occupies 28 memory locations (28 features × 32 bits):

```
Address Range | Test ID
0-27          | Test 0
28-55         | Test 1
56-83         | Test 2
84-111        | Test 3
112-139       | Test 4
140-167       | Test 5
168-195       | Test 6
196-223       | Test 7
224-251       | Test 8
252-279       | Test 9
```

## Advanced Usage

### Adding More Tests
1. Edit `scripts/generate_mem_files.py` and increase `num_tests`
2. Run `make gen-mem`
3. Update `N_TESTS` parameter in `fpga_test_controller.sv`
4. Recompile

### Custom Test Vectors
1. Modify `model/diverse_test_golden.json`
2. Run `make gen-mem`
3. Reload .mif file in Quartus
4. Recompile and reprogram

## Simulation

Test the controller in ModelSim before FPGA:

```bash
# Compile
vlog -sv +acc -work work src/pca_coeffs_pkg.sv src/fem.sv src/pca_detector.sv src/top_pipeline.sv src/fpga_test_controller.sv

# Create testbench and simulate
vsim -gui work.fpga_test_controller
```
