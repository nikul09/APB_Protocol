
class apb_sequence_item extends uvm_sequence_item;

  rand bit [15:0]PADDR; 
  rand bit [7:0]PWDATA;
  rand bit PWRITE;
  logic [7:0] PRDATA;
  logic PSEL;     
  logic PENABLE;   
  logic PREADY;   
  logic PSLVERR;  

  bit [15:0]addrque[$];

  bit [15:0]que[$];

  `uvm_object_utils(apb_sequence_item) 

  function new(string name ="apb_sequence_item");
    super.new(name);
    //`uvm_info(get_type_name(),":construct !",UVM_MEDIUM)
  endfunction

  constraint data1{
    PWDATA > 0;
	PWDATA < 8'd255;
  }
  
  constraint addr{ PADDR >= 0; PADDR <= 15; }

  
  constraint uni_addr{ 
	!(PADDR inside {que});
	}

  function void post_randomize();
    que.push_front(PADDR);

	if(que.size() == $size(PADDR)) que.delete();
  endfunction


endclass

