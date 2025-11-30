# Makefile for NIDS Pipeline Testbench - Automated Workflow
# Supports ModelSim with diverse test cases (63 tests)

# Simulator selection
SIM ?= modelsim

# Project directories
SRC_DIR = src
TB_DIR = tb
BUILD_DIR = build
OUTPUT_DIR = output

# Source files (package must be compiled first)
PKG_FILES = $(SRC_DIR)/pca_coeffs_pkg.sv

SRC_FILES = $(SRC_DIR)/fem.sv \
            $(SRC_DIR)/pca_detector.sv \
            $(SRC_DIR)/top_pipeline.sv

# Use diverse testbench with 63 test cases
TB_FILES = $(TB_DIR)/tb_diverse.sv

ALL_FILES = $(PKG_FILES) $(SRC_FILES) $(TB_FILES)

# Top module
TOP_MODULE = tb_diverse

# Simulation time
SIM_TIME = -all

# ModelSim settings
VLOG = vlog
VSIM = vsim
VLOG_FLAGS = -sv +acc -work work
VSIM_FLAGS = -c -do "run $(SIM_TIME); quit -f"

# Verilator settings
VERILATOR = verilator
VERILATOR_FLAGS = --cc --exe --build -Wall -Wno-fatal --top-module $(TOP_MODULE)
VERILATOR_TB = verilator_tb.cpp

# Default target - Full automated verification
.PHONY: all
all: clean-build gen-tests compile run report
	@echo ""
	@echo "==================================================================="
	@echo "  AUTOMATED VERIFICATION COMPLETE!"
	@echo "==================================================================="
	@echo "  ✓ Generated 63 diverse test cases"
	@echo "  ✓ Compiled hardware design"
	@echo "  ✓ Ran ModelSim simulation"
	@echo "  ✓ Generated HTML verification report"
	@echo ""
	@echo "  📊 Open: output/verification_report.html"
	@echo "==================================================================="
	@echo ""

# Generate diverse test cases and testbench
.PHONY: gen-tests
gen-tests:
	@echo "==================================================================="
	@echo "  Generating Diverse Test Cases (63 tests)"
	@echo "==================================================================="
	@python scripts/generate_diverse_testbench.py
	@python scripts/generate_sv_testbench.py
	@echo "✓ Test generation complete"
	@echo ""

# HTML Report generation
.PHONY: report
report:
	@echo "==================================================================="
	@echo "  Generating HTML Verification Report"
	@echo "==================================================================="
	@if not exist $(OUTPUT_DIR) mkdir $(OUTPUT_DIR)
	@python scripts/generate_html_report.py
	@echo ""
	@echo "✓ HTML report: $(OUTPUT_DIR)/verification_report.html"
	@echo ""

# Create build directory
$(BUILD_DIR):
	@if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)

# Compile for ModelSim
.PHONY: compile
compile: $(BUILD_DIR)
	@echo "==================================================================="
	@echo "  Compiling Hardware Design"
	@echo "==================================================================="
	@if not exist work vlib work
	$(VLOG) $(VLOG_FLAGS) $(ALL_FILES)
	@echo "✓ Compilation successful"
	@echo ""

# Run simulation
.PHONY: run
run:
	@echo "==================================================================="
	@echo "  Running ModelSim Simulation (63 tests)"
	@echo "==================================================================="
	$(VSIM) $(VSIM_FLAGS) work.$(TOP_MODULE)
	@echo "✓ Simulation complete"
	@echo ""

# Run with GUI
.PHONY: gui
gui: compile
	@echo "Opening ModelSim GUI..."
	$(VSIM) -gui work.$(TOP_MODULE)

# Run with waveform
.PHONY: wave
wave: compile
	@echo "Running with waveform capture..."
	$(VSIM) work.$(TOP_MODULE) -do "add wave -r /*; run $(SIM_TIME); wave zoom full"

# Quick compile and run (no test regeneration)
.PHONY: quick
quick: compile run
	@echo "✓ Quick test complete"

# Full test with comparison report
.PHONY: test
test: all
	@echo "==================================================================="
	@echo "  Running Full Comparison Analysis"
	@echo "==================================================================="
	@set PYTHONIOENCODING=utf-8 && python scripts/generate_comparison_report.py
	@echo ""
	@echo "✓ Full verification with text comparison complete!"
	@echo "  Check: output/logs/verification_report.txt"
	@echo ""

# Clean only build artifacts (keep work library)
.PHONY: clean-build
clean-build:
	@if exist transcript del /Q transcript 2>nul
	@if exist vsim.wlf del /Q vsim.wlf 2>nul
	@if exist library.cfg del /Q library.cfg 2>nul

# Clean everything including work library
.PHONY: clean
clean:
	@echo "Cleaning all build artifacts..."
	@if exist work rmdir /S /Q work 2>nul
	@if exist $(BUILD_DIR) rmdir /S /Q $(BUILD_DIR) 2>nul
	@if exist transcript del /Q transcript 2>nul
	@if exist vsim.wlf del /Q vsim.wlf 2>nul
	@if exist wlf* del /Q wlf* 2>nul
	@if exist *.vcd del /Q *.vcd 2>nul
	@if exist library.cfg del /Q library.cfg 2>nul
	@echo "✓ Clean complete"

# Clean generated test files
.PHONY: clean-tests
clean-tests:
	@echo "Cleaning generated test files..."
	@if exist model\diverse_test_golden.json del /Q model\diverse_test_golden.json 2>nul
	@if exist $(TB_DIR)\tb_diverse.sv del /Q $(TB_DIR)\tb_diverse.sv 2>nul
	@echo "✓ Test files cleaned"

# Clean all (build + tests + reports)
.PHONY: clean-all
clean-all: clean clean-tests
	@if exist $(OUTPUT_DIR)\logs rmdir /S /Q $(OUTPUT_DIR)\logs 2>nul
	@if exist $(OUTPUT_DIR)\verification_report.html del /Q $(OUTPUT_DIR)\verification_report.html 2>nul
	@echo "✓ All artifacts cleaned"

# View waveform (requires simulation to have been run)
.PHONY: view
view:
	@echo "Opening waveform viewer..."
	$(VSIM) -view vsim.wlf

# Help
.PHONY: help
help:
	@echo "==================================================================="
	@echo "  PCA-based NIDS Hardware Verification - Makefile"
	@echo "==================================================================="
	@echo ""
	@echo "Main Targets:"
	@echo "  all          - Full automated workflow (generate→compile→run→report)"
	@echo "  quick        - Quick test (compile and run only, no regeneration)"
	@echo "  test         - Full test with text comparison report"
	@echo "  report       - Generate HTML verification report only"
	@echo ""
	@echo "Build Targets:"
	@echo "  gen-tests    - Generate 63 diverse test cases and testbench"
	@echo "  compile      - Compile hardware design (SystemVerilog)"
	@echo "  run          - Run ModelSim simulation"
	@echo ""
	@echo "Debug Targets:"
	@echo "  gui          - Open ModelSim GUI"
	@echo "  wave         - Run with waveform capture"
	@echo "  view         - View previous waveform (vsim.wlf)"
	@echo ""
	@echo "Clean Targets:"
	@echo "  clean        - Remove build artifacts and work library"
	@echo "  clean-tests  - Remove generated test files"
	@echo "  clean-all    - Remove everything (build + tests + reports)"
	@echo ""
	@echo "Examples:"
	@echo "  make              # Full automated verification"
	@echo "  make quick        # Fast iteration during development"
	@echo "  make gui          # Interactive debugging"
	@echo "  make test         # Full test with text report"
	@echo "  make clean-all    # Start fresh"
	@echo ""
	@echo "==================================================================="
