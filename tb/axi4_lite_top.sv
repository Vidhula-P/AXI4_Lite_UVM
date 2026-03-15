`include "include_files.sv"

module axi4_lite_top;
  
  parameter DATA_WIDTH = 32;
  parameter ADDRESS = 32;
  
  logic clk, read_s, write_s;
  logic [ADDRESS-1:0]    address;
  logic [DATA_WIDTH-1:0] W_data;

  logic  M_ARREADY,M_ARVALID,M_RREADY,M_AWVALID,M_BREADY,M_WVALID;
  logic [ADDRESS-1:0]M_ARADDR,M_AWADDR;
  logic [DATA_WIDTH-1:0]M_WDATA;
  logic [3:0]M_WSTRB;
  
  // interface to AXI4-Lite slave
  axi4_lite_slave_interface intf(.ACLK(clk));

  // DUT instantiation
  axi4_lite_slave u_axi4_lite_slave0
  (
    .ACLK(clk),
    .ARESETN(intf.ARESETN),
    .S_ARREADY(intf.S_ARREADY),
    .S_RDATA(intf.S_RDATA),
    .S_RRESP(intf.S_RRESP),
    .S_RVALID(intf.S_RVALID),
    .S_ARADDR(intf.S_ARADDR),
    .S_ARVALID(intf.S_ARVALID),
    .S_RREADY(intf.S_RREADY),
    .S_AWREADY(intf.S_AWREADY),
    .S_WVALID(intf.S_WVALID),
    .S_WREADY(intf.S_WREADY),
    .S_BRESP(intf.S_BRESP),
    .S_BVALID(intf.S_BVALID),
    .S_AWADDR(intf.S_AWADDR),
    .S_AWVALID(intf.S_AWVALID),
    .S_WDATA(intf.S_WDATA),
    .S_WSTRB(intf.S_WSTRB),
    .S_BREADY(intf.S_BREADY)
  );
  
  // output signals
  logic [DATA_WIDTH-1:0] output_rdata;
  logic            [1:0] output_rresp;
  
  // start global clock
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial begin
    intf.ARESETN = 1;
    #2 intf.ARESETN = 0; // asychronous reset assertion
    repeat (5) @(posedge clk);
    intf.ARESETN = 1; // sychronous reset de-assertion
   	// asychronous reset assertion and sychronous reset de-assertion
    // prevents race between clock and reset
    repeat(50) @(posedge clk);
    $finish;
  end
  
  initial begin
    @(negedge intf.ARESETN); // wait till reset deasserted
    
    // write a word
    // write address, data channel
    $display("Waiting for AW and W ready");
    intf.S_AWADDR = 32'h0000_0001;
    intf.S_WDATA = 32'h1234_abcd;
    intf.S_WSTRB = 4'b1111;
    intf.S_AWVALID = 1'b1;
    intf.S_WVALID = 1'b1;
    wait (intf.S_AWREADY && intf.S_WREADY);
    $display("AW, W ready");
    @(posedge clk);
    intf.S_AWVALID = 1'b0;
    intf.S_WVALID = 1'b0;
    // write response channel
    $display("Waiting for B valid");
    intf.S_BREADY = 1'b1;
    wait(intf.S_BVALID);
    $display("B valid");
    $display("S_BRESP = %h", intf.S_BRESP); // always 0
    @(posedge clk) intf.S_BREADY = 1'b0;
    repeat(5) @(posedge clk);
    
    // read written word
    // read address channel
    $display("Waiting for AR ready");
    intf.S_ARADDR = 32'h0000_0001;
    intf.S_ARVALID = 1'b1;
    wait (intf.S_ARREADY);
    @(posedge clk) intf.S_ARVALID = 1'b0;
    $display("AR ready");
    // read data channel
    $display("Waiting for R ready");
    intf.S_RREADY = 1'b1;
    wait(intf.S_RVALID);
    $display("R ready");
    output_rdata = intf.S_RDATA;
    output_rresp = intf.S_RRESP;
    @(posedge clk) intf.S_RREADY = 1'b0;
    $display("S_RDATA = %h", output_rdata); // expecting 1234_abcd
    $display("S_RRESP = %h", output_rresp); // always 0
    repeat(5) @(posedge clk);
  end
  
  // wave file
  initial begin
    $dumpfile("axi.vcd");
    $dumpvars(0, axi4_lite_top);
  end
endmodule