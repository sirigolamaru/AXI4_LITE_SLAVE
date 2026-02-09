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
