# Compiler and simulator
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# Directories
RTL_DIR = rtl
TB_DIR = testbench
SIM_DIR = sim

# Default target
all: pc_sim imem_sim regfile_sim alu_sim ctrl_sim alu_ctrl_sim

# Compile and simulate program counter
pc_sim: $(RTL_DIR)/program_counter.v $(TB_DIR)/program_counter_tb.v
	$(IVERILOG) -o $(SIM_DIR)/pc_sim $^
	$(VVP) $(SIM_DIR)/pc_sim

# Compile and simulate instruction memory
imem_sim: $(RTL_DIR)/instruction_memory.v $(TB_DIR)/instruction_memory_tb.v
	$(IVERILOG) -o $(SIM_DIR)/imem_sim $^
	$(VVP) $(SIM_DIR)/imem_sim

# Compile and simulate register file
regfile_sim: $(RTL_DIR)/register_file.v $(TB_DIR)/register_file_tb.v
	$(IVERILOG) -o $(SIM_DIR)/regfile_sim $^
	$(VVP) $(SIM_DIR)/regfile_sim

# Compile and simulate ALU
alu_sim: $(RTL_DIR)/alu.v $(TB_DIR)/alu_tb.v
	$(IVERILOG) -o $(SIM_DIR)/alu_sim $^
	$(VVP) $(SIM_DIR)/alu_sim

# Compile and simulate control unit
ctrl_sim: $(RTL_DIR)/control_unit.v $(TB_DIR)/control_unit_tb.v
	$(IVERILOG) -o $(SIM_DIR)/ctrl_sim $^
	$(VVP) $(SIM_DIR)/ctrl_sim

# Compile and simulate ALU control unit
alu_ctrl_sim: $(RTL_DIR)/alu_control.v $(TB_DIR)/alu_control_tb.v
	$(IVERILOG) -o $(SIM_DIR)/alu_ctrl_sim $^
	$(VVP) $(SIM_DIR)/alu_ctrl_sim

# View waveforms
wave_pc:
	$(GTKWAVE) $(SIM_DIR)/program_counter.vcd &

wave_imem:
	$(GTKWAVE) $(SIM_DIR)/instruction_memory.vcd &

wave_regfile:
	$(GTKWAVE) $(SIM_DIR)/register_file.vcd &

wave_alu:
	$(GTKWAVE) $(SIM_DIR)/alu.vcd &

wave_ctrl:
	$(GTKWAVE) $(SIM_DIR)/control_unit.vcd &

wave_alu_ctrl:
	$(GTKWAVE) $(SIM_DIR)/alu_control.vcd &

# Clean generated files
clean:
	rm -f $(SIM_DIR)/*

.PHONY: all clean wave_pc wave_imem wave_regfile wave_alu wave_ctrl wave_alu_ctrl 