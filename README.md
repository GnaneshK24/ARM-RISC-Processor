# RISC Processor Implementation

A complete implementation of a RISC processor in Verilog, featuring a full instruction set, memory hierarchy, and peripheral support.

## 🚀 Features

### Core Components
- **Program Counter (PC)**: Manages instruction sequencing
- **ALU**: Supports arithmetic and logical operations
  - ADD, SUB, AND, OR, XOR
  - Shift operations (SLL, SRL, SRA)
  - Comparison operations (SLT)
- **Register File**: 32 x 32-bit general-purpose registers
- **Memory System**:
  - Instruction Memory (4KB)
  - Data Memory (4KB)
- **Control Unit**: Generates control signals for all components
- **Branch Unit**: Handles conditional branching
- **Immediate Generator**: Generates immediate values for instructions

### Peripheral Components
- **Timer**: Generates periodic interrupts
- **UART**: Serial communication interface
  - Configurable baud rate
  - 8-bit data transmission
  - Start and stop bit support

### Instruction Support
- **R-type**: ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT
- **I-type**: ADDI, ANDI, ORI, XORI, SLLI, SRLI, SRAI, SLTI
- **Load/Store**: LW, SW
- **Branch**: BEQ, BNE, BLT, BGE
- **Jump**: JAL, JALR

## 📁 Project Structure

```
arm-RISC/
├── rtl/                    # RTL implementation files
│   ├── alu.v              # Arithmetic Logic Unit
│   ├── control_unit.v     # Control Unit
│   ├── data_memory.v      # Data Memory
│   ├── instruction_memory.v# Instruction Memory
│   ├── processor_top.v    # Top-level module
│   ├── register_file.v    # Register File
│   ├── timer.v           # Timer peripheral
│   └── uart.v            # UART peripheral
├── testbench/             # Testbench files
│   ├── alu_tb.v          # ALU testbench
│   ├── processor_tb.v     # Top-level testbench
│   └── ...               # Other component testbenches
├── sim/                   # Simulation outputs
├── scripts/              # Utility scripts
├── program.mem           # Program memory initialization
├── Makefile             # Build automation
└── simulate.sh          # Simulation script
```

## 🛠️ Prerequisites

- Icarus Verilog (iverilog)
- GTKWave (for waveform viewing)
- GNU Make

## 📥 Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/arm-RISC.git
cd arm-RISC
```

2. Install dependencies (Ubuntu/Debian):
```bash
sudo apt-get install iverilog gtkwave make
```

## 🚀 Usage

1. **Compile and Run Simulation**:
```bash
./simulate.sh
```

2. **View Waveforms**:
```bash
gtkwave sim/processor.vcd
```

3. **Run Specific Tests**:
```bash
make test_alu        # Run ALU tests
make test_processor  # Run processor tests
```

## 📊 Testing

The project includes comprehensive testbenches for all components:

- Unit tests for individual modules
- Integration tests for the complete processor
- Automated test suite with expected outputs
- Waveform generation for debugging

### Sample Test Output
```
SUCCESS: x1 = 0000001e (Expected: 0000001e)
SUCCESS: x4 = 0000000f (Expected: 0000000f)
```

## 🔍 Implementation Details

### ALU Operations
- ADD/SUB with overflow detection
- Logical operations (AND, OR, XOR)
- Shift operations with variable shift amount
- Signed comparison

### Control Unit
- Instruction decoding
- Control signal generation
- Pipeline control (if implemented)

### Memory System
- Word-aligned addressing
- Synchronous write operations
- Asynchronous read operations

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- RISC-V instruction set architecture
- Digital design principles and best practices
- Open-source hardware community

## 📞 Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter) - email@example.com

Project Link: [https://github.com/yourusername/arm-RISC](https://github.com/yourusername/arm-RISC) 