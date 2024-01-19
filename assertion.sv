
module assertion_bind(input PCLK,PSEL,PENABLE,PREADY);

  property ideal_1;
    @(posedge PCLK) (!PSEL and !PENABLE) |-> $fell(PREADY);
   endproperty

  property ideal_2;
    @(posedge PCLK) (!PSEL and !PENABLE) |-> $rose(PREADY);
   endproperty

  property invalid_1;
    @(posedge PCLK) (!PSEL and PENABLE) |-> $fell(PREADY);
  endproperty

  property invalid_2;
    @(posedge PCLK) (!PSEL and PENABLE) |-> $rose(PREADY);
  endproperty

  property setup_1;
    @(posedge PCLK) (PSEL and !PENABLE) |-> $fell(PREADY);
  endproperty

  property setup_2;
    @(posedge PCLK) (PSEL and !PENABLE) |-> $rose(PREADY);
  endproperty

  property access_1;
    @(posedge PCLK) (PSEL and PENABLE) |-> $fell(PREADY);
  endproperty

  property access_2;
    @(posedge PCLK) (PSEL and PENABLE) |-> $rose(PREADY);
  endproperty

  property valid_enable;
    @(posedge PCLK) PSEL ##1 PENABLE; 
  endproperty

  property no_wait;
    @(posedge PCLK) PSEL ##1 PENABLE ##1 PREADY;
  endproperty

  cp_ideal_1:cover property(ideal_1);
  cp_setup_1:cover property(setup_1);
  cp_access_1:cover property(access_1);
  cp_invalid_1: cover property(invalid_1);
  cp_ideal_2:cover property(ideal_2);
  cp_setup_2:cover property(setup_2);
  cp_access_2:cover property(access_2);
  cp_invalid_2: cover property(invalid_2);

  cp_valid_enable:cover property(valid_enable);
  cp_no_wait:cover property(no_wait);
endmodule
