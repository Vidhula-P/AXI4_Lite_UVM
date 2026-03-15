class transaction extends uvm_sequence_item;
  
  //Read Address Channel INPUTS
  rand bit       [31:0]  S_ARADDR;
  //Write Address Channel INPUTS
  rand bit       [31:0]  S_AWADDR;
  //Write Data  Channel INPUTS
  rand bit  	 [31:0]  S_WDATA;
  rand bit        [3:0]  S_WSTRB;	

  //Read Data Channel OUTPUTS
  bit    		 [31:0]	 S_RDATA;
  bit             [1:0]  S_RRESP;
  //Write Response Channel OUTPUTS
  bit             [1:0]  S_BRESP;
  
  `uvm_object_utils(transaction)

   function new(string name="transaction");
      super.new(name);
   endfunction

endclass
