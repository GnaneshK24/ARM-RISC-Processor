#!/bin/bash

# Create simulation directory if it doesn't exist
mkdir -p sim

# Compile the design
echo "Compiling design..."
iverilog -o sim/processor.vvp \
    rtl/register.v \
    rtl/multiplexer.v \
    rtl/alu.v \
    rtl/alu_control.v \
    rtl/branch_unit.v \
    rtl/control_unit.v \
    rtl/data_memory.v \
    rtl/immediate_generator.v \
    rtl/instruction_decoder.v \
    rtl/instruction_memory.v \
    rtl/pc_adder.v \
    rtl/processor_top.v \
    rtl/program_counter.v \
    rtl/register_file.v \
    rtl/timer.v \
    rtl/uart.v \
    testbench/processor_tb.v

# Run the simulation
echo "Running simulation..."
vvp sim/processor.vvp

# Open waveform viewer if GTKWave is installed
if command -v gtkwave &> /dev/null; then
    echo "Opening waveform viewer..."
    gtkwave sim/processor.vcd
else
    echo "GTKWave not found. Please install GTKWave to view waveforms."
fi 