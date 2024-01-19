
class apb_sequence extends uvm_sequence#(apb_sequence_item );
  
  int addr_que[$];
  int cnt;
  
  `uvm_object_utils(apb_sequence)

  function new(string name = "apb_sequence");
    super.new(name);
	//`uvm_info(get_type_name(),":construct !",UVM_MEDIUM);
  endfunction

  task body();
    write_seq();
	read_seq();
	back_door();
    b2b_write_read();
	random_sqn();
	write_more_read();
    read_more_write();
  endtask

  task write_seq();
    repeat(16)begin
      `uvm_do_with(req,{req.PWRITE == 1;})
      addr_que.push_back(req.PADDR);
      cnt++;
    end
  endtask
 
  task read_seq();
    repeat(16)begin
      `uvm_do_with(req,{req.PWRITE == 0; req.PADDR == addr_que.pop_front();})
     end
  endtask
 
  task b2b_write_read();
    repeat(15)begin 
      `uvm_do_with(req,{req.PWRITE == 1;req.PADDR == cnt;})
       addr_que.push_back(req.PADDR);
       `uvm_do_with(req,{req.PWRITE == 0;req.PADDR == addr_que.pop_front();})
	   cnt++;
	end
  endtask

  task random_sqn();
    repeat(15)begin 
      `uvm_do_with(req,{req.PWRITE == 1;req.PADDR < 16'd15;})
	end

	repeat(15)begin
      `uvm_do_with(req,{req.PWRITE == 0;req.PADDR < 16'd15;})
	end
  endtask

  task write_more_read();
    repeat(15)begin 
      `uvm_do_with(req,{req.PWRITE == 1;req.PADDR == cnt;})
	  addr_que.push_back(req.PADDR);
	 cnt++;
	end
	repeat(10)begin
      `uvm_do_with(req,{req.PWRITE == 0;req.PADDR == addr_que.pop_front();})
	end

  endtask

  task read_more_write();
    cnt = 0;
    repeat(10)begin 
      `uvm_do_with(req,{req.PWRITE == 1;req.PADDR == cnt;})
	 cnt++;
	end

	cnt = 0;

	repeat(15)begin
      `uvm_do_with(req,{req.PWRITE == 0;req.PADDR == cnt;})
	  cnt++;
	end

  endtask

 endclass


