interface axi4_lite_slave_interface(input ACLK);
  parameter ADDRESS    = 32;
  parameter DATA_WIDTH = 32;
  
  //Global Signal
  logic                    ARESETN;

  ////Read Address Channel INPUTS
  logic     [ADDRESS-1:0]  S_ARADDR;
  logic                    S_ARVALID;
  //Read Data Channel INPUTS
  logic                    S_RREADY;
  //Write Address Channel INPUTS
  logic     [ADDRESS-1:0]  S_AWADDR;
  logic                    S_AWVALID;
  //Write Data  Channel INPUTS
  logic  [DATA_WIDTH-1:0]  S_WDATA;
  logic             [3:0]  S_WSTRB;
  logic                    S_WVALID;
  //Write Response Channel INPUTS
  logic                    S_BREADY;	

  //Read Address Channel OUTPUTS
  logic                    S_ARREADY;
  //Read Data Channel OUTPUTS
  logic    [DATA_WIDTH-1:0]S_RDATA;
  logic         [1:0]      S_RRESP;
  logic                    S_RVALID;
  //Write Address Channel OUTPUTS
  logic                    S_AWREADY;
  logic                    S_WREADY;
  //Write Response Channel OUTPUTS
  logic         [1:0]      S_BRESP;
  logic                    S_BVALID;

endinterface