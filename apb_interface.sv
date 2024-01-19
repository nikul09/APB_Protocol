
interface apb_inf(input bit PCLK, PRESET);
  
  logic [15:0]PADDR;
  logic [7:0]PWDATA;
  logic [7:0]PRDATA; 
  logic PSEL;
  logic PENABLE;
  logic PWRITE;
  logic PREADY;
  logic PSLVERR;

  clocking drv_cb@(posedge PCLK);
    default input #1 output #1;
	input PRDATA,PREADY,PSLVERR;
	output PADDR,PWDATA,PSEL,PENABLE,PWRITE;
  endclocking

  clocking mon_cb@(posedge PCLK);
    default input #1 output #1;
	input PADDR,PWDATA,PSEL,PENABLE,PWRITE;
	input PRDATA,PREADY,PSLVERR;
  endclocking

endinterface

