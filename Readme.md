# 4-Bit ALU Design using Verilog HDL

A modular 4-bit Arithmetic Logic Unit (ALU) designed and implemented in Verilog HDL using Xilinx Vivado. The project integrates arithmetic, logical, comparison, rotation, and binary-to-BCD conversion operations within a hierarchical FPGA-ready architecture.

## Features

* 4-bit Ripple Carry Adder
* 4-bit Subtractor
* 4×4 Array Multiplier
* Magnitude Comparator
* Bitwise AND Operation
* Bitwise XOR Operation
* Circular Bit Rotation
* Binary-to-BCD Converter

## Operation Mapping

| Select | Operation                |
| ------ | ------------------------ |
| 000    | Addition                 |
| 001    | Subtraction              |
| 010    | Multiplication           |
| 011    | Magnitude Comparison     |
| 100    | AND                      |
| 101    | XOR                      |
| 110    | Rotation                 |
| 111    | Binary-to-BCD Conversion |

## Design Highlights

* Developed using modular and hierarchical Verilog HDL.
* Structural implementation of Full Adder, Ripple Carry Adder, Multiplier and Magnitude Comparator.
* Synthesized and implemented using Xilinx Vivado.
* Timing constraints applied for 150 MHz operation.
* Static Timing Analysis (STA) performed across multiple PVT corners.
* Achieved clean timing closure with positive setup and hold slack.

## Results

* Target Device: Xilinx Artix-7 FPGA
* Target Frequency: 150 MHz
* Resource Utilization: 82 LUTs (0.39%)
* Estimated Maximum Frequency: ~157 MHz
* Functional verification completed through Vivado simulation.

## Tools Used

* Verilog HDL
* Xilinx Vivado
* Vivado Simulator (xsim)
* Static Timing Analysis (STA)
