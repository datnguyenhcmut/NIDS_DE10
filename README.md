# PCA-based Network Intrusion Detection System (NIDS)

Hardware implementation of a PCA-based Network Intrusion Detection System for FPGA deployment on DE10-Standard.

## 🎯 Overview

Real-time anomaly detection system using Principal Component Analysis (PCA) to identify network attacks. Trained on KDD Cup dataset with SMOTE augmentation (1.8M samples).

## ✨ Features

- **Algorithm**: PCA anomaly detection (4 major + 2 minor components)
- **Data Format**: Q24.8 fixed-point (32-bit)
- **Target Platform**: DE10-Standard (Cyclone V SoC)
- **Verification**: 63 diverse test cases (100% pass rate)
- **Attack Detection**: Absolute value threshold comparison for robust overflow handling

## 📊 Test Results

```
✅ 63/63 tests passed (100%)
   - 33 synthetic edge cases
   - 30 real network traffic samples
   
🎯 Attack Detection: 100% accuracy
⚡ Score Precision: <0.001% error (fixed-point rounding)
```

## 🏗️ Project Structure

```
.
├── src/                    # SystemVerilog source files
│   ├── pca_detector.sv     # Core PCA detection algorithm
│   ├── pca_coeffs_pkg.sv   # Trained model coefficients
│   ├── fem.sv              # Feature extraction module
│   └── top_pipeline.sv     # Top-level pipeline
├── tb/                     # Testbenches
│   └── tb_diverse.sv       # 63-test verification testbench
├── scripts/                # Python automation scripts
│   ├── generate_diverse_testbench.py
│   ├── generate_sv_testbench.py
│   └── generate_html_report.py
├── model/                  # Trained PCA model
│   ├── pca_coeffs.json
│   └── diverse_test_golden.json
├── dataset/                # KDD Cup dataset
├── output/                 # Reports and logs
│   └── verification_report.html
└── quartus_project/        # Quartus Prime project files
```

## 🚀 Quick Start

### Prerequisites

- ModelSim Intel FPGA Edition (tested with 10.5b)
- Python 3.8+ with NumPy, Pandas
- Make (for automation)
- Quartus Prime (for FPGA synthesis)

### Automated Verification

```bash
# Full automated workflow: generate tests → compile → simulate → report
make

# Quick test (no regeneration)
make quick

# Open ModelSim GUI for debugging
make gui

# Clean all artifacts
make clean-all
```

### Manual Steps

```bash
# Generate test cases (63 diverse tests)
python scripts/generate_diverse_testbench.py
python scripts/generate_sv_testbench.py

# Compile hardware
vlib work
vlog -sv +acc -work work src/pca_coeffs_pkg.sv src/fem.sv src/pca_detector.sv src/top_pipeline.sv tb/tb_diverse.sv

# Run simulation
vsim -c -do "run -all; quit" work.tb_diverse

# Generate HTML report
python scripts/generate_html_report.py
```

## 📈 Performance

- **Test Coverage**: 63 diverse scenarios
  - Edge cases: max values, tiny values, alternating patterns
  - Port scans: 5 rate variations (0.5-0.95)
  - Byte sizes: 100 to 80,000 bytes
  - Failed logins: 1 to 20 attempts
  - Real traffic: 30 KDD Cup samples

- **Hardware Accuracy**:
  - Attack detection: 100% match with Python model
  - Score computation: 63.5% perfect match, 36.5% <0.001% rounding

## 🛠️ Makefile Targets

| Target | Description |
|--------|-------------|
| `make` or `make all` | Full automated verification workflow |
| `make quick` | Fast compile + run (no test regeneration) |
| `make test` | Full test with text comparison report |
| `make report` | Generate HTML verification report |
| `make gui` | Open ModelSim GUI |
| `make wave` | Run with waveform capture |
| `make clean` | Remove build artifacts |
| `make clean-all` | Remove everything (build + tests + reports) |
| `make help` | Show all available targets |

## 🔧 Configuration

### Hardware Parameters
- `DATA_WIDTH`: 32 bits (Q24.8 fixed-point)
- `N_FEATURES`: 28 input features
- `THRESHOLD`: 100 << 8 = 25,600 (in fixed-point)
- `CLK`: 50 MHz

### Model Training
Model trained on `data_after_smote.csv` (1,847,149 samples):
- Features: 28 numeric features from KDD Cup
- Algorithm: Manual SVD implementation (NumPy 2.3.5 compatibility)
- Components: 4 major + 2 minor principal components

## 📝 Test Case Categories

1. **Basic Tests**: Zeros, small values, large values
2. **Edge Cases**: Maximum values, tiny values, alternating patterns
3. **Parametric Sweeps**: 
   - Connection rates (0.5 → 0.95)
   - Byte sizes (100 → 80,000)
   - Failed login attempts (1 → 20)
4. **Random Variations**: Different seeds for coverage
5. **Real Traffic**: 30 samples from KDD Cup dataset

## 🎯 FPGA Deployment (TODO)

- [ ] Quartus synthesis for DE10-Standard
- [ ] Timing constraints validation (50 MHz)
- [ ] Resource utilization optimization
- [ ] HPS integration for Ethernet processing
- [ ] Physical hardware testing

## 📊 Verification Reports

After running `make`, check:
- **HTML Report**: `output/verification_report.html` (interactive with Chart.js)
- **Text Report**: `output/logs/verification_report.txt` (detailed comparison)

## 🧪 Testing

All tests verify:
1. Attack detection flag (0 = normal, 1 = attack)
2. Major score computation accuracy
3. Minor score computation accuracy

**Pass Criteria**: 
- Attack detection must match Python model exactly
- Scores within ±10M tolerance for fixed-point arithmetic

## 📚 References

- Dataset: [KDD Cup 1999](http://kdd.ics.uci.edu/databases/kddcup99/)
- FPGA: [DE10-Standard User Manual](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=1081)
- Algorithm: PCA-based anomaly detection with Q24.8 fixed-point arithmetic

## 📄 License

MIT License - See LICENSE file for details

## 👥 Contributors

- Hardware implementation and verification framework
- Python golden reference model
- Automated test generation (63 diverse cases)

## 🔗 Links

- Repository: https://github.com/datnguyenhcmut/NIDS_DE10
- Issues: https://github.com/datnguyenhcmut/NIDS_DE10/issues

---

**Status**: ✅ Verification Complete (63/63 tests passing)  
**Next Step**: Quartus synthesis for DE10-Standard FPGA
