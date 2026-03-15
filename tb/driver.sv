class driver extends uvm_driver #(transaction);
  `uvm_component_utils(driver)
  
  virtual axi_interface vif;
  
  function new (string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual axi_interface)::get(this,"","vif",vif))
      `uvm_fatal("* DRIVER-DUT CONNECTION FAILED *","");
  endfunction
  
  task reset_task();
    vif.ARESETN = 1'b1;
    @(posedge vif.ACLK);
    #2 vif.ARESETN = 1'b0; // asynchronous reset assertion
    repeat (5) @(posedge vif.ACLK);
    vif.ARESETN = 1'b1; // synchronous reset de-assertion
  endtask
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    reset_task();
    
    forever begin
      seq_item_port.get_next_item(req);
      // write address, write data
      vif.S_AWADDR  = req.S_AWADDR;
      vif.S_WDATA   = req.S_WDATA;
      vif.S_WSTRB   = req.S_WSTRB;
      vif.S_AWVALID = 1'b1;
      vif.S_WVALID  = 1'b1;
      wait (vif.S_AWREADY && vif.S_WREADY);
      @(posedge vif.ACLK);
      vif.S_AWVALID = 1'b0;
      vif.S_WVALID  = 1'b0;
	  // write response
      vif.S_BREADY  = 1'b1;	
      wait(vif.S_BVALID);
      @(posedge vif.ACLK) vif.S_BREADY  = 1'b0;
      // read address
      vif.S_ARADDR  = req.S_ARADDR;
      vif.S_ARVALID = 1'b1;
      wait (vif.S_ARREADY);
      @(posedge vif.ACLK) vif.S_ARVALID = 1'b0;
      // read data 
      vif.S_RREADY = 1'b1;
      wait(vif.S_RVALID);
      @(posedge vif.ACLK) vif.S_RREADY = 1'b0;
      seq_item_port.item_done();
      `uvm_info("DRIVER - TRANSACTION NUMBER","",UVM_NONE);
    end
  endtask
  
endclass