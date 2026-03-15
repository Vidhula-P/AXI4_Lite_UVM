class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  virtual axi_interface vif;
  
  function new (string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual axi_interface)::get(this,"","vif",vif))
      `uvm_fatal("* MONITOR-DUT CONNECTION FAILED *","");
  endfunction
  
  task run_phase(uvm_phase phase);
    
    transaction trans;
    
    forever begin
      @(negedge vif.ARESETN);
      trans = transaction::type_id::create("trans", this);
      wait(vif.S_RVALID && vif.S_RREADY);
      trans.S_RDATA = vif.S_RDATA;
      trans.S_RRESP = vif.S_RRESP;
      `uvm_info("MON", $sformatf("S_RDATA = %h", trans.S_RDATA), UVM_MEDIUM) // expecting 1234_abcd
      `uvm_info("MON", $sformatf("S_RRESP = %h", trans.S_RRESP), UVM_MEDIUM) // always 0
    end
  endtask
  
endclass