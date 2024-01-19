
class apb_environment extends uvm_env;
  
  apb_master_agent agent;
  apb_scorboard sb;
  apb_coverage cvg; 
  
  `uvm_component_utils(apb_environment)

  function new(string name = "apb_environment",uvm_component parent);
    super.new(name,parent);
	//`uvm_info(get_type_name(),":construct !",UVM_MEDIUM)
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	//`uvm_info(get_type_name(),":build phase !",UVM_MEDIUM)
	agent = apb_master_agent::type_id::create("agent",this);
    sb = apb_scorboard::type_id::create("sb",this);
	cvg = apb_coverage::type_id::create("cvg",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
	agent.mon.ap.connect(sb.ip);
	agent.mon.ap.connect(cvg.analysis_export);
    //`uvm_info(get_type_name(),":connect phase !",UVM_MEDIUM)
  endfunction

  task run_phase(uvm_phase phase);
     super.run_phase(phase);
    //`uvm_info(get_type_name(),":run phase !",UVM_MEDIUM)
  endtask

endclass
