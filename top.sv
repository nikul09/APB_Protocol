// define time scal

`include "assertion.sv"
`include "apb_pkg.svh"

module apb_top();
        
  bit pclk;
  bit prst;
  string str1;


  //-- apb Interface --//

  apb_inf pinf(pclk,prst);

   // -- set configuration --//

  initial begin 
    uvm_config_db#(virtual apb_inf)::set(null,"*","vinf",pinf);
  // uvm config #(<type>)::set(cntx,"her","feild_name",value)
  // 1. from coock bool seen apb_coverage onece
  
  // set return void 
  // get return bit value
  // uvm_config_db#(<type>)::set(uvm_component cntx,string inst_name,string field_name, field value)

  // 1. null -> configuration is not tied to a specific instance. It's a wildcard match for any instance
  // 2. "*" -> thre are not specifiy any herachial so it is wild card /
  end

  APB apb_uu(
          .PCLK(pinf.PCLK),
		  .PRDATA(pinf.PRDATA),
		  .PRESET(pinf.PRESET),
		  .PADDR(pinf.PADDR),
		  .PWDATA(pinf.PWDATA),
		  .PSEL(pinf.PSEL),
		  .PENABLE(pinf.PENABLE),
		  .PWRITE(pinf.PWRITE),
		  .PREADY(pinf.PREADY),
		  .PSLVERR(pinf.PSLVERR)
		  );

 bind APB : apb_uu assertion_bind sva (
                                       PCLK,
									   PSEL,
									   PENABLE,
									   PREADY
									   ); 

  // -- clock generate -- //

  initial begin 
    forever #5 pclk = ~pclk;
  end

  // -- rst -- //

  initial begin 
    prst = 1;
	#1;
	prst = 0;
	#4;
	prst= 1;
  end
 
  initial begin
  if($test$plusargs("apb_test")) run_test("apb_test");
  // need to pass "+apb_test in command line

  //if($value$plusargs("test_name=%s",str1)) run_test(str1);

  
    // invoke phases 
	// -- run test --//
	// read from command line 
	//1. write each any evrything here what is run_test,why,write signnifications
	//2. if my tb contain more then 1 test we are not give any argu then which test select frist -> its chose from command line 

	// run tesst control phases (start)
    // control test_top , root track phases
    // run_phase is nature is paralllel but due to delata delay its top to dwon
    // end sim smoothly not by force

    // -- run test --//
    //1. write each any evrything here what is run_test,why,write signnifications 
    //2. if my tb contain more then 1 test we are not give any argu then which test select frist

  end
endmodule

