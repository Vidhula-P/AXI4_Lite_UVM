import uvm_pkg::*;
`include "uvm_macros.svh"
`include "include_files.sv"

module axi4_lite_top;
  
  parameter DATA_WIDTH = 32;
  parameter ADDRESS = 32;
  
  bit clk, read_s, write_s;
  bit [ADDRESS-1:0]    address;
  bit [DATA_WIDTH-1:0] W_data;

  bit  M_ARREADY,M_ARVALID,M_RREADY,M_AWVALID,M_BREADY,M_WVALID;
  bit [ADDRESS-1:0]M_ARADDR,M_AWADDR;
  bit [DATA_WIDTH-1:0]M_WDATA;
  bit [3:0]M_WSTRB;
  
  // interface to AXI4-Lite slave
  axi_interface intf(.ACLK(clk));

  // DUT instantiation
  axi4_lite_slave dut
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
    uvm_config_db#(virtual axi_interface)::set(null,"*","vif",intf);
    run_test("test_1");
  end
  
  // wave file
  initial begin
    $dumpfile("axi.vcd");
    $dumpvars(0, axi4_lite_top);
  end
endmodule