# AXI4_LITE_SLAVE
## AIM:
To design and verify an AXI4-Lite Slave Interface using Verilog HDL, implementing a memory-mapped register set that supports single-beat read and write transactions as per the ARM AMBA AXI4-Lite.

## APPARATUS:
Computer or Laptop

Verilog HDL

AXI4-Lite Protocol

Vivado / ModelSim Simulator

Waveform Viewer

## PROCEDURE
Study the basic AXI4-Lite read and write signals.

Define clock, reset, and AXI4-Lite interface signals in Verilog.

Create internal registers for data storage.

Capture write address when AWVALID and AWREADY are high.

Store write data into the selected register.

Generate write response after successful write.

Capture read address when ARVALID and ARREADY are high.

Read data from the selected register.

Send read data and response to the master.

Verify write and read operations using a testbench and waveforms.

## HOW TO RUN THE CODE
Open Vivado / ModelSim software.

Create a new project.

Add the AXI4-Lite slave Verilog file to the project.

Add the testbench file to the project.

Set the testbench as top module.

Compile all the Verilog files.

Run the simulation.

Open the waveform window.

Check write and read signals in the waveform.

Verify that read data matches written data.

## CONCLUSION
In this project, an AXI4-Lite slave interface was successfully designed and verified using Verilog HDL. The design correctly supports read and write operations through a memory-mapped register interface by 
following the AXI4-Lite handshaking protocol. Simulation results confirm that data written by the master is accurately stored and read back from the slave registers. This project helped in understanding AXI4-Lite protocol basics, 
RTL design, and verification using testbenches, which are essential skills for SoC and VLSI design.
