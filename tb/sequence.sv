class base_sequence extends uvm_sequence#(transaction);
  `uvm_object_utils(base_sequence)

  function new(string name="base_sequence");
      super.new(name);
   endfunction

endclass

class sequence_1 extends base_sequence;
   `uvm_object_utils(sequence_1)
   
   function new(string name="sequence_1");
      super.new(name);
   endfunction

   task body();
      transaction trans;
      repeat(1) begin
        trans = transaction::type_id::create("trans");      
        start_item(trans);
        trans.rand_mode(0);
        trans.S_AWADDR = 32'h0000_0001;
        trans.S_WDATA = 32'h1234_abcd;
        trans.S_WSTRB = 4'b1111;
        trans.S_ARADDR = 32'h0000_0001;
        finish_item(trans);
        
        `uvm_info("SEQUENCE ENDED - 1","",UVM_HIGH);
      end   
   endtask

endclass