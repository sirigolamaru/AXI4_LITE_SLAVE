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
