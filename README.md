SystemVerilog Class Projects
Welcome to the SystemVerilog Class Projects repository! This repository contains a collection of projects and assignments completed as part of a course on SystemVerilog(Digital Systems Laboratory). Each project is designed to explore different aspects of hardware design and digital logic, with an emphasis on SystemVerilog as the hardware description language.

Introduction
This repository features projects created during the study of SystemVerilog and hardware design. Each project is focused on different design concepts like game logic, microprocessor architecture, HDMI controllers, memory management, and more. The goal is to apply theoretical knowledge to practical, hands-on tasks.

Projects
1. Tetris Implementation
This project recreates the classic Tetris game using SystemVerilog. The implementation includes game logic, falling block mechanics, and an optimized pixel map display stored in memory to improve efficiency. The design interacts with peripherals using an SoC.
Key Features:
Game logic implementation on a pixel map
Efficient display updates
Falling and movement logic

2. SLC-3 Microprocessor
This project involves the implementation of an SLC-3 microprocessor, a simplified version of the LC-3 ISA. The processor supports 16-bit instructions, registers, and program counter, and can execute basic operations like list sorting and self-modifying code.
Key Features:
16-bit processor and instruction set
Support for sorting algorithms and self-modifying code
Assembly-level operations

3. HDMI Text Mode Controller
This project implements an HDMI text mode controller using an AXI4 interface. The controller manages font, coordinates, and color inversion, using on-chip memory to resolve timing issues.
Key Features:
AXI4 interface implementation
Dual-channel VRAM access
Efficient timing management for HDMI display

4. Memory-Mapped I/O
This project covers the basics of memory-mapped input/output. It demonstrates how to interface peripherals like USB-connected keyboards and HDMI cables with the system, focusing on how memory-mapped I/O works within an SoC.
Key Features:
Peripheral interfacing using memory-mapped I/O
Efficient interaction between hardware and peripherals

5. SoC Peripheral Interface
In this project, an SoC design is implemented to interface with peripherals, such as keyboards and HDMI. The focus is on setting up communication protocols and managing timing issues between the peripherals and the processor.
Key Features:
SoC design to interface with external devices
HDMI and keyboard integration
Timing and synchronization optimization
