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
## CODE
     `timescale 1ns / 1ps
      module axi4_lite_slave #(
          parameter ADDR_WIDTH = 32,
          parameter DATA_WIDTH = 32
      )(
          input  wire ACLK,
          input  wire ARESETn,
          // WRITE ADDRESS CHANNEL
          input  wire [ADDR_WIDTH-1:0] AWADDR,
          input  wire AWVALID,
          output reg  AWREADY,
          // WRITE DATA CHANNEL
          input  wire [DATA_WIDTH-1:0] WDATA,
          input  wire [(DATA_WIDTH/8)-1:0] WSTRB,
          input  wire WVALID,
          output reg  WREADY,
          // WRITE RESPONSE CHANNEL
          output reg  [1:0] BRESP,
          output reg   BVALID,
          input  wire  BREADY,
          // READ ADDRESS CHANNEL
          input  wire [ADDR_WIDTH-1:0]   ARADDR,
          input  wire                    ARVALID,
          output reg                     ARREADY,
          // READ DATA CHANNEL
          output reg  [DATA_WIDTH-1:0] RDATA,
          output reg  [1:0] RRESP,
          output reg  RVALID,
          input  wire RREADY
      );
          // Internal registers
          reg [DATA_WIDTH-1:0] CONTROL;
          // READY signals (always ready - simple design)
          always @(posedge ACLK) begin
              if (!ARESETn) begin
                  AWREADY <= 0;
                  WREADY  <= 0;
                  ARREADY <= 0;
              end else begin
                  AWREADY <= 1;
                  WREADY  <= 1;
                  ARREADY <= 1;
              end
          end
          // WRITE LOGIC
          always @(posedge ACLK) begin
              if (!ARESETn) begin
                  CONTROL <= 0;
                  BVALID  <= 0;
                  BRESP   <= 2'b00;
              end else begin
                  // Write happens when both address & data are valid
                  if (AWVALID && WVALID && AWREADY && WREADY) begin
                      if (AWADDR[5:2] == 4'h0) begin
                          CONTROL <= WDATA;
                      end
                      BVALID <= 1;
                      BRESP  <= 2'b00; // OKAY
                  end else if (BVALID && BREADY) begin
                      BVALID <= 0;
                  end
              end
          end
          // READ LOGIC
          always @(posedge ACLK) begin
              if (!ARESETn) begin
                  RDATA  <= 0;
                  RVALID <= 0;
                  RRESP  <= 2'b00;
              end else begin
                  if (ARVALID && ARREADY && !RVALID) begin
                      if (ARADDR[5:2] == 4'h0)
                          RDATA <= CONTROL;
                      else
                          RDATA <= 0;
                           RVALID <= 1;
                      RRESP  <= 2'b00; // OKAY
                  end else if (RVALID && RREADY) begin
                      RVALID <= 0;
                  end
              end
          end
      endmodule
## TESTBENCH CODE
     `timescale 1ns/1ps
    module tb_axi4_lite_slave;
        parameter ADDR_WIDTH = 32;
        parameter DATA_WIDTH = 32;
        // Clock & Reset
        reg clk;
        reg rst_n;
        // WRITE ADDRESS CHANNEL
        reg  [ADDR_WIDTH-1:0] AWADDR;
        reg  AWVALID;
        wire AWREADY;
    // WRITE DATA CHANNEL
    reg  [DATA_WIDTH-1:0] WDATA;
    reg  [(DATA_WIDTH/8)-1:0] WSTRB;
    reg  WVALID;
    wire WREADY;
    // WRITE RESPONSE CHANNEL
    wire [1:0] BRESP;
    wire BVALID;
    reg  BREADY;
    // READ ADDRESS CHANNEL
    reg  [ADDR_WIDTH-1:0] ARADDR;
    reg  ARVALID;
    wire ARREADY;
    // READ DATA CHANNEL
    wire [DATA_WIDTH-1:0] RDATA;
    wire [1:0] RRESP;
    wire RVALID;
    reg  RREADY;
    // DUT INSTANTIATION
    axi4_lite_slave dut (
        .ACLK    (clk),
        .ARESETn (rst_n),.AWADDR  (AWADDR),.AWVALID (AWVALID),.AWREADY (AWREADY), .WDATA   (WDATA),.WSTRB  (WSTRB),.WVALID  (WVALID), .WREADY  (WREADY),.BRESP   (BRESP),.BVALID  (BVALID),.BREADY  (BREADY),
      .ARADDR  (ARADDR),.ARVALID (ARVALID),.ARREADY (ARREADY),.RDATA   (RDATA), .RRESP   (RRESP),.RVALID  (RVALID),.RREADY  (RREADY)
    );
    // CLOCK: 10ns period
    always #5 clk = ~clk;
     initial begin
        // INITIAL VALUES
        clk     = 0;rst_n   = 0; AWADDR  = 0; AWVALID = 0; WDATA   = 0; WSTRB   = 4'b1111; WVALID  = 0; BREADY  = 0; ARADDR  = 0;ARVALID = 0; RREADY  = 0;
        // APPLY RESET
        #20;
        rst_n = 1;
        // WRITE TRANSACTION
        @(posedge clk);
        AWADDR  <= 32'h0000_0000;
        AWVALID <= 1;
        WDATA   <= 32'hA5A5A5A5;
        WVALID  <= 1;
        BREADY  <= 1;
        // Wait for write handshake
        wait (AWREADY && WREADY);
        @(posedge clk);
        AWVALID <= 0;
        WVALID  <= 0;
        // Wait for write response
        wait (BVALID);
        @(posedge clk);
        BREADY <= 0;
        // READ TRANSACTION
        @(posedge clk);
        ARADDR  <= 32'h0000_0000;
        ARVALID <= 1;
        RREADY  <= 1;
        // Wait for read address handshake
        wait (ARREADY);
        @(posedge clk);
        ARVALID <= 0;
        // Wait for read data
        wait (RVALID);
        $display("READ DATA = %h", RDATA);
        @(posedge clk);
        RREADY <= 0;
        // END SIMULATION
        #50;
        $finish;
    end
    endmodule

## RTL DIAGRAM

<img width="1366" height="768" alt="Screenshot (127)" src="https://github.com/user-attachments/assets/6c1b6622-008e-4bc0-a35e-da12ac941bff" />

## WAVEFORM

<img width="1366" height="768" alt="Screenshot (126)" src="https://github.com/user-attachments/assets/d94598e0-a960-4a0b-b63e-3b8d66a2eded" />

## CONCLUSION
In this project, an AXI4-Lite slave interface was successfully designed and verified using Verilog HDL. The design correctly supports read and write operations through a memory-mapped register interface by 
following the AXI4-Lite handshaking protocol. Simulation results confirm that data written by the master is accurately stored and read back from the slave registers. This project helped in understanding AXI4-Lite protocol basics, 
RTL design, and verification using testbenches, which are essential skills for SoC and VLSI design.

