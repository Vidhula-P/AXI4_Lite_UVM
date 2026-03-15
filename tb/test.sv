class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  
  environment env;
  
  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // override base sequence
    uvm_factory::get().set_type_override_by_type(base_sequence::get_type(), sequence_1::get_type());
    env = environment::type_id::create("env", this);
  endfunction
endclass

class test_1 extends base_test;
  `uvm_component_utils(test_1)
  
  function new(string name = "test_1", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task run_phase(uvm_phase phase);
    base_sequence seq;
    phase.raise_objection(this);
    seq = sequence_1::type_id::create("seq");
    seq.start(env.agt.seqr);
    #100
    phase.drop_objection(this);
  endtask
  
endclass