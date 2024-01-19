
class apb_master_driver extends uvm_driver#(apb_sequence_item);

   virtual apb_inf vinf;
   
   bit [15:0]que[$];
    
  `uvm_component_utils(apb_master_driver)

  function new(string name = "apb_master_driver",uvm_component parent);
    super.new(name,parent);
    //`uvm_info(get_type_name(),":construct !",UVM_MEDIUM)
  endfunction



  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   //`uvm_info(get_type_name(),":buid_phase !",UVM_NONE)
   if(!uvm_config_db#(virtual apb_inf)::get(this,"*","vinf",vinf))
   `uvm_fatal(get_type_name(),":FAIL! to get Interafec")
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
	
  	forever begin
	  @(posedge vinf.PCLK);
	  seq_item_port.get_next_item(req);
	 
	  ideal();

	  seq_item_port.item_done();
	end
  endtask

/*
  task apb_write();
	vinf.PADDR <= req.PADDR;
	vinf.PWDATA <= req.PWDATA;
	vinf.PWRITE <= req.PWRITE;
	vinf.PSEL <= 1;
	//Till setup phase
	@(posedge vinf.PCLK);
	vinf.PENABLE <= 1;
    wait(vinf.PREADY);
	vinf.PSEL<=0;
	vinf.PENABLE <= 0;
  endtask

  task apb_read();
	vinf.PADDR <= req.PADDR;
	vinf.PWRITE <= req.PWRITE;
    vinf.PSEL <= 1;
	@(posedge vinf.PCLK);
    vinf.PENABLE <= 1;
	wait(vinf.PREADY); 
  endtask

*/

  task ideal();
    vinf.PSEL <= 0;
	vinf.PENABLE <= 0;
	vinf.PWRITE <= 0;
	vinf.PADDR <= 0;
	vinf.PWDATA <= 0;
	vinf.PRDATA <= 0;
    setup();
  endtask

  task setup();
    vinf.PSEL <= 1;
    vinf.PADDR <= req.PADDR;
    vinf.PWRITE <= req.PWRITE;
	vinf.PWDATA <= (req.PWRITE==1) ? (req.PWDATA):8'd0;
	@(posedge vinf.PCLK);
	access();
  endtask

  task access();
	vinf.PENABLE <= 1;
    wait(vinf.PREADY);
	@(posedge vinf.PCLK);
  endtask


endclass


