
class apb_test extends uvm_test;

   apb_sequence seqc;
   apb_environment env;
  
  `uvm_component_utils(apb_test)

  function new(string name = "apb_test",uvm_component parent);
    super.new(name,parent);
    //`uvm_info(get_type_name(),":construct !",UVM_MEDIUM);
  endfunction

 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info(get_type_name(),":build phase !",UVM_MEDIUM)
	env = apb_environment::type_id::create("env",this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
	//`uvm_info(get_type_name(),":end of elaboration phase !",UVM_MEDIUM)
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    //`uvm_info(get_type_name(),":run_phase !",UVM_NONE)
    

	 phase.raise_objection(this,"start sim");

	 seqc = apb_sequence::type_id::create("seqc");
	 // raises the number of objection for the source object by count 
	 //defualt is 1 
     // uvm_objection extends from uvm_report_object  -- fun 
     // The object is have this handle of the caller
     // If object is not specified or null, then call top-level component which is root
     // uvm_objection(uvm_object object ,"discription",int cnt)

    seqc.start(env.agent.sqr); 

	// what is start-> its task its start call body method of sequence
	
	phase.phase_done.set_drain_time(this,25);

	phase.drop_objection(this,"Finish sim");

	 // drop objection -- fun 
     // The object is usually the this handle of the caller.
     // If object is not specified or null
     // If the total objection count has not reached zero for object, then 
     // the drop is propagated up the object hierarchy

  endtask
endclass


