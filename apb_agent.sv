
class apb_master_agent extends uvm_agent;

  apb_master_sequencer sqr;
  apb_master_driver drv;
  apb_master_monitor mon;

  `uvm_component_utils(apb_master_agent)

  function new(string name = "name",uvm_component parent);
    super.new(name,parent);
    //`uvm_info(get_type_name(),":construct !",UVM_MEDIUM);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info(get_type_name(),":build phase !",UVM_MEDIUM);
	sqr = apb_master_sequencer::type_id::create("sqr",this);
	drv = apb_master_driver::type_id::create("drv",this);
    mon = apb_master_monitor::type_id::create("mon",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //`uvm_info(get_type_name(),":connect phase !",UVM_NONE);
	drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
	//`uvm_info(get_type_name(),":run phase !",UVM_NONE);
  endtask

endclass
