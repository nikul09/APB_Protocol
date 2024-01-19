
class apb_master_sequencer extends uvm_sequencer#(apb_sequence_item);

  `uvm_component_utils(apb_master_sequencer)

  function new(string name = "name",uvm_component parent);
    super.new(name,parent);
    //`uvm_info(get_type_name(),":construct !",UVM_NONE);
  endfunction

endclass
