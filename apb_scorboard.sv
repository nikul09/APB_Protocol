
class apb_scorboard extends uvm_scoreboard;

  `uvm_component_utils(apb_scorboard)
  
  uvm_analysis_imp #(apb_sequence_item,apb_scorboard) ip;
  apb_sequence_item sqn[$];

  
  reg [7:0]refmem[15:0];

  function new(string name = "apb_scorboard",uvm_component parent);
    super.new(name,parent);
	//`uvm_info(get_type_name(),":construct !",UVM_NONE);
	ip = new("ip",this);
  endfunction

  function void build_phase(uvm_phase phase);
    //`uvm_info(get_type_name(),":construct !",UVM_NONE);
	super.build_phase(phase);
	foreach(refmem[i]) refmem[i] = 8'h00;
  endfunction

  function void connect_phase(uvm_phase phase);
    //`uvm_info(get_type_name(),":construct !",UVM_NONE);
	super.connect_phase(phase);
  endfunction


  function void write(apb_sequence_item sqn_pkt);
    sqn.push_back(sqn_pkt);
  endfunction
 

  task run_phase(uvm_phase phase);
    //super.run_phase(phase);
	apb_sequence_item sqn_co;
	
	forever begin
	  wait(sqn.size()>0);
	  sqn_co = sqn.pop_front();

	  if(sqn_co.PWRITE == 1)begin
        refmem[sqn_co.PADDR] = sqn_co.PWDATA;
	  end

	  else if(sqn_co.PWRITE == 0)begin
	    if(refmem[sqn_co.PADDR] == sqn_co.PRDATA)begin
          `uvm_info(get_type_name(),"------- READ -> DATA MATCH----------",UVM_MEDIUM)
		  `uvm_info(get_type_name(),$sformatf("address : %0d, expected : %0d, acutal : %0d",sqn_co.PADDR, refmem[sqn_co.PADDR],sqn_co.PRDATA),UVM_MEDIUM)
		end
		else begin
          `uvm_error(get_type_name(),"------- READ -> DATA MISMATCH----------")
		  `uvm_error(get_type_name(),$sformatf("address : %0d, expected : %0d, acutal : %0d",sqn_co.PADDR, refmem[sqn_co.PADDR],sqn_co.PRDATA))
		end
	  end
	end
   endtask
 

endclass

