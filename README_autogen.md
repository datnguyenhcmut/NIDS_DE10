# FPGA-Based Network Intrusion Detection System

Auto-generated pipeline for DE10-Standard (Cyclone V SoC)

## Configuration

- **Fixed-point format**: Q8.8 (16 bits total)
- **PCA components**: 4 major, 2 minor
- **Input features**: 28
- **Dataset**: kddcup.data_10_percent.gz

## Directory Structure

```
output/
├── dataset/          # Processed KDD Cup data
├── model/            # PCA coefficients (JSON)
├── src/              # SystemVerilog source files
│   ├── fem.sv
│   ├── pca_detector.sv
│   └── top_pipeline.sv
├── tb/               # Testbench
│   └── tb_top.sv
├── quartus_project/  # Quartus II project files
│   ├── nids.qpf
│   ├── nids.qsf
│   └── nids.sdc
└── logs/             # Simulation logs and waveforms
    ├── train_log.txt
    ├── sim_report.txt
    └── wave.vcd
```

## Build Instructions

### Simulation

```bash
# Run simulation with iverilog
python auto_nids_hdl.py --data kddcup.data_10_percent.gz --simulate

# View waveforms in GTKWave
gtkwave output/logs/wave.vcd
```

### FPGA Build (Quartus)

1. Open Quartus Prime
2. File → Open Project → `output/quartus_project/nids.qpf`
3. Processing → Start Compilation
4. Tools → Programmer → Load bitstream to DE10-Standard

### Pin Assignments (DE10-Standard)

| Signal | Pin | Description |
|--------|-----|-------------|
| clk | AF14 | 50 MHz clock (CLOCK_50) |
| rst_n | AA14 | Reset button (KEY[0]) |
| attack_detected | AA24 | Attack LED (LEDR[0]) |

## Resource Estimates

- **Logic Elements**: ~15,000 (< 25% of Cyclone V)
- **DSP Blocks**: ~112 (for matrix multiplication)
- **Memory**: ~2 KB (coefficients storage)
- **Fmax**: ~80 MHz (target 50 MHz)

## Performance Metrics

Training samples (normal): 97,278
Total samples: 494,021
Detection rate: TBD (see sim_report.txt)

## Notes

- This is a baseline implementation optimized for low resource usage
- For higher accuracy, increase `--q` and `--r` parameters
- Threshold tuning may be needed for specific datasets
- HPS integration can be added for dynamic updates

## References

Das, A., et al. "An FPGA-Based Network Intrusion Detection Architecture."
IEEE Transactions on Information Forensics and Security, 2008.
