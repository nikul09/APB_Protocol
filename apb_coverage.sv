
class apb_coverage extends uvm_subscriber#(apb_sequence_item);

  `uvm_component_utils(apb_coverage)

  covergroup apb_cg with function sample(apb_sequence_item s);

	cp_write_read: coverpoint s.PWRITE{
      bins write_to_write = (1=>1); 
	  bins write_to_read = (1=>0);
	  bins read_to_write = (0=>1);
	  bins read_to_read = (0=>0);
	}

   cp_addr: coverpoint s.PADDR{
	 bins valid_addr[] = {[0:15]};
	 }
  
   cp_wdata: coverpoint s.PWDATA iff(s.PWRITE){
     bins valid_pwdata[16] = {[0:255]};
	 //option.auto_bin_max = 256;
	}

   cp_rdata: coverpoint s.PRDATA iff(!s.PWRITE){
     bins valid_prdata[16] = {[0:255]};
	 //option.auto_bin_max = 256;
	}

   cp_error: coverpoint s.PSLVERR{
     bins slverr = (0=>1); 
	}

endgroup

covergroup addr_toggle with function sample(apb_sequence_item t, bit x);
  cp_addr_toggle: coverpoint x{
    bins x1[] = (0=>1);
	bins x2[] = (1=>0);
  }
endgroup

covergroup pwdata_toggle with function sample(apb_sequence_item t, bit y);
  cp_pwdata_toggle: coverpoint y{
    bins y1[] = (0=>1);
	bins y2[] = (1=>0);
  }

endgroup


  function new(string name = "apb_coverage", uvm_component parent);
    super.new(name,parent);
    apb_cg = new;
    addr_toggle = new;
    pwdata_toggle = new;
  endfunction

  function void write(apb_sequence_item t);
    apb_cg.sample(t);

	for(int i=0;i<$size(t.PADDR);i++)begin
	  addr_toggle.sample(t,t.PADDR[i]);
	end

	for(int j=0;j<$size(t.PWDATA);j++)begin
	  pwdata_toggle.sample(t,t.PWDATA[j]);
	end

  endfunction

endclass


