1. Objectives

The purpose of this lab is to design two different implementations of both ROM and RAM in Verilog and simulate their behavior. First, we will design both memory systems using internal logic (hardcoded readable data in ROM and the ability to write/read new data in RAM). Next, we will add file input/output capabilities to both modules, allowing the ROM to read from a .mem file and the RAM to both read and write to an external .mem file. All implementations will be simulated and tested in Vivado to generate waveforms and diagrams.

3. Introduction

Both ROM and RAM systems allow for stored data to be accessed during a program’s runtime, though they differ slightly in their implementation and utility. The key difference between the two is that, while ROM is generally unable to be overwritten, RAM is volatile and can be refreshed and updated as a program requires new data to be stored. 

We implemented our ROM as an array of 4-bit values of length 8 (requiring a single 3-bit input for the ROM address and one 4-bit output representing its corresponding data) using purely combinational structure. For the basic ROM module (no file reading), we used a single procedural block containing a case statement to assign each ROM address to its data value. Similarly, the ROM_file module declares an internal array (using the aforementioned parameters), reads data from a .mem file containing 8 4-bit values, and assigns them to the array in sequential order. In both designs, as ROM_addr input updates, the ROM_data output updates to reflect the data at the new address.

In contrast, the RAM designs required greater complexity to accommodate the overwriting of existing data, with both implemented as an array of 8 8-bit values. This required three additional inputs, an enable signal to dictate whether data is being read or written, a clock signal, and a reset signal used to clear the existing values. Reading data is functionally identical to ROM, while writing requires a high write i_write_en (1-bit) signal to overwrite the specified i_addr (3-bit) location with the provided i_write_data (8-bit)  value. Adding file I/O capability (in the RAM_file module) required minimal adjustments, invoking the $readmemb and $writememb system tasks to load initial values and write updates to an external .mem file containing 8 lines of data.

3. Instructions for simulation and FPGA implementation

  Simulation: 

    a. Create a project in vivavdo containing all of these files.

    b. Select the desired testbench file and corresponding design file as the top modules.

    c. Run simulation and view waveform.

  FPGA implementation:
    No implementation for this lab.

5. Additional Soures

https://hilite.me/ - Used to format Appendix code in Lab Report
