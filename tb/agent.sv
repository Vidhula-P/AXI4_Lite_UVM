class agent extends uvm_agent;
  
  `uvm_component_utils(agent)
  
  uvm_sequencer#(transaction) seqr;
  driver drv;
  monitor mon;
  
  function new(string name = "agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE) begin //active by deafault so no need to change
      seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
      drv  = driver::type_id::create("drv", this);
    end
    mon = monitor::type_id::create("mon", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin //active by deafault so no need to change
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction
  
endclass