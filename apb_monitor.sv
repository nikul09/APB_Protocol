
class apb_master_monitor extends uvm_monitor;

  `uvm_component_utils(apb_master_monitor)
  
  apb_sequence_item sq;
  virtual apb_inf vinf;
  
  uvm_analysis_port #(apb_sequence_item) ap;

 covergroup cv @(posedge vinf.PCLK);
   
   transition: coverpoint {vinf.PSEL,vinf.PENABLE,vinf.PREADY}{
   // legual transition
     bins idel_to_setup = (3'b000,3'b001 => 3'b100,3'b101);
     bins setup_to_access = (3'b100,3'b101 => 3'b110,3'b111);
     bins access_to_setup = (3'b110,3'b111 => 3'b100,3'b101);
     bins access_to_ideal = (3'b110,3'b111 => 3'b000,3'b001);
	 
   // illegal transition for invalid state
	 illegal_bins ideal_to_invalid = (3'b000,3'b001 => 3'b010,3'b011);
	 illegal_bins setup_to_invalid = (3'b100,3'b101 => 3'b010,3'b011);
	 illegal_bins access_to_invalid = (3'b110,3'b111  => 3'b010,3'b011);
	 
	 illegal_bins setup_to_ideal = (3'b100,3'b101 => 3'b000,3'b001);	
	}
 endgroup

   function new(string name = "apb_master_monitor",uvm_component parent);
    super.new(name,parent);
	if(!uvm_config_db#(virtual apb_inf)::get(this,"*","vinf",vinf))
	  `uvm_fatal(get_type_name(),":FAIL! to get Interafec")

	cv = new();
   
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	ap = new("ap",this);	
	sq = apb_sequence_item::type_id::create("sq");
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
   //`uvm_info(get_type_name(),":run_phase !",UVM_MEDIUM);
    forever begin
      @(posedge vinf.PCLK);
	  wait(vinf.PREADY == 1 && vinf.PENABLE == 1);
   
	  if(vinf.PWRITE == 1) apb_write();
	  else apb_read();
      @(posedge vinf.PCLK);
	  ap.write(sq);
 
    end

  endtask

  task apb_write();
    //@(posedge vinf.PCLK);
	sq.PSEL <= vinf.PSEL;
	sq.PENABLE <= vinf.PENABLE;
	sq.PSLVERR <= vinf.PSLVERR;
   	sq.PADDR <= vinf.PADDR;
	sq.PWDATA <= vinf.PWDATA;
	sq.PWRITE <= vinf.PWRITE;
  endtask

  task apb_read();
    //@(posedge vinf.PCLK);
    sq.PSEL <= vinf.PSEL;
	sq.PENABLE <= vinf.PENABLE;
	sq.PSLVERR <= vinf.PSLVERR;
	sq.PADDR <= vinf.PADDR;
	sq.PRDATA <= vinf.PRDATA;
	sq.PWRITE <= vinf.PWRITE;
  endtask

endclass



