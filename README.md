# AXI_LITE_SLAVE
## AIM:To design and implement an AMBA AXI4-Lite Slave Interface using Verilog HDL and verify its read and write operations through simulation.

## APPARATUS
Software:

Vivado / ModelSim / QuestaSim

Verilog HDL

GTKWave (for waveform analysis)

Hardware (Optional):

FPGA Board (Basys-3 / Artix-7)

USB Cable

PC/Laptop

## PROCEDURE
Step 1:

Study the AMBA AXI4-Lite protocol and understand its five channels.

Step 2:

Define all AXI4-Lite slave interface signals:

Write Address Channel (AW)

Write Data Channel (W)

Write Response Channel (B)

Read Address Channel (AR)

Read Data Channel (R)

Step 3:

Create internal registers (for example, 4 or 8 registers) to store data.

Step 4:

Implement Write Address logic:
Capture the address when AWVALID and AWREADY are high.

Step 5:

Implement Write Data logic:
Store incoming data into the selected register.

Step 6:

Generate Write Response:
Send BRESP and BVALID after successful write.

Step 7:

Implement Read Address logic:
Capture address when ARVALID and ARREADY are high.

Step 8:

Send Read Data:
Provide stored data through RDATA and assert RVALID.

Step 9:

Design a testbench:
Generate write and read transactions to verify functionality.

Step 10:

Run simulation and verify:

Correct handshake operation

Correct data transfer

Proper response signals

## HOW TO DO THE PROJECT 
Create a new RTL project in Vivado/ModelSim.

Write the AXI4-Lite slave Verilog module.

Define parameters like data width and address width.

Create internal register memory.

Implement write channel logic with handshake mechanism.

Implement read channel logic.

Handle reset condition properly.

Write testbench for:

Writing data to slave

Reading data from slave

Simulate and observe waveforms.

Verify that read data matches written data.

Debug if handshake timing is incorrect.

## CONCLUSION
The AMBA AXI4-Lite Slave Interface was successfully designed and verified using Verilog HDL. The implemented design correctly supports single read and write transactions using the VALID and READY handshake mechanism defined by the AXI4-Lite protocol.

Through simulation, the slave module accurately stored write data into internal registers and returned correct data during read operations. The write response and read response signals were properly generated, ensuring correct communication between master and slave.
