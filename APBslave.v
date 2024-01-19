`define ADDRWIDTH 16
`define DATAWIDTH 8

module APB( input PCLK,PRESET,PSEL,PENABLE,PWRITE,
            input [`ADDRWIDTH-1:0] PADDR,
            input [`DATAWIDTH-1:0]PWDATA,
            //input transfer,
            output reg [`DATAWIDTH-1 :0] PRDATA,
            output reg PREADY,
            output PSLVERR 
            );

//parameter ADDwidth = 16;
//parameter DATAwidth = 8;

reg [`DATAWIDTH-1:0] mem [0:`ADDRWIDTH-1];
reg [1:0] sstate;
reg error_addr,error_read,error_write;

parameter [1:0] idle = 2'b00;
parameter [1:0] setup = 2'b01;
parameter [1:0] access = 2'b10;

integer i;
//reg [`ADDRWIDTH-1:0] i;

always @(posedge PCLK or negedge PRESET,PSEL,PENABLE) begin
    if(PRESET == 0) begin //preset is active LOW signal  
        sstate <= idle;
        PRDATA <= `DATAWIDTH'd0;
        PREADY <= 0; 
       //--memory initialization.
        for(i = 0;i <`ADDRWIDTH;i=i+1 )begin
            mem[i] <=`DATAWIDTH'd0;
        end
    end
    else begin
            case(sstate)
            idle : begin
                    //PRDATA <= 0;
                     if(PSEL==1) begin
                         sstate <= setup;
                     end
                     else begin
                         sstate <= idle;
                     end
            end

            setup : begin
                    //PRDATA <= 0;
                    //if(PSEL == 1 && PENABLE == 1 && transfer == 1 ) begin    //original
                    //if(PENABLE==1) begin
                     //  if(transfer)                        //modified.
                    //end
		    //if(transfer==0) begin
                      //   sstate <= idle;   
                    //end
		    if(PENABLE) begin
                        sstate <= access;
		end
            end
                   
                     
            access :begin 
                         PREADY<=1;
                     if (!PREADY) begin
                       sstate <= access; 
                     end
                     //PREADY<=1;
                    /* if(PREADY==1 && transfer==1) begin
                        sstate<=setup;
                     end
                     if(PREADY==1 && transfer==0) begin
                        sstate<=idle;
                     end*/
                   
                     if(PWRITE) begin // 1 to write and 0 to read
                        mem[PADDR] <= PWDATA; 
                        /*for(i = 0;i <`ADDRWIDTH;i=i+1 )begin
                              $display("%p",mem);
                        end*/
                        if(PSEL==1 && PENABLE==0) begin
                         sstate<=setup;
                        end
                        if(PSEL==0 && PENABLE==0) begin
                         sstate<=idle;
                        end
                        /*if(PREADY==1 &&transfer==1) begin
                          sstate<=setup;
                        end
                        if(PREADY==1 &&transfer==0) begin
                         sstate<=idle;
                        end*/
                     end
                     else begin
                        PRDATA<= mem[PADDR];
                        /*for(i = 0;i <`ADDRWIDTH;i=i+1 )begin
                              $display("%p",mem);
                        end*/
                        if(PSEL==1 && PENABLE==0) begin
                         sstate<=setup;
                        end
                        if(PSEL==0 && PENABLE==0) begin
                         sstate<=idle;
                        end
                        /*if(PREADY==1 && transfer==1) begin
                          sstate<=setup;
                        end
                        if(PREADY==1 && transfer==0) begin
                         sstate<=idle;
                        end*/
                        
                     end
                        /*if(PENABLE==0 && transfer==1) begin
                         sstate<=setup;
                        end
                        if(PENABLE==0 && transfer==0) begin
                         sstate<=idle;
                        end*/
               
                        /*for(i = 0;i <`ADDRWIDTH;i=i+1 )begin
                              $display("%p",mem);
                        end*/
                    end
                        
           endcase
            end
        
end

// always @(sstate or PREADY or tr ) begin
//     case 
        
//     endcase
// end

assign PSLVERR =  error_addr || error_read || error_write;

always @(*) begin
    if(!PRESET) begin
        //error <= 0;
       //--modified
        error_addr <= 0;
        error_read <= 0;
        error_write <= 0;
    end
    else begin
      if((PADDR === 16'dx) && (PSEL))
		  error_addr = 1;
	  else error_addr = 0;
          end
          
	  if((PRDATA === 8'dx) &&(PSEL))
		  error_read = 1;
	  else  error_read = 0;
          begin
          if((PWDATA === 8'dx) && (PSEL))
		   error_write = 1;
          else error_write = 0;
          end   

    end
    

endmodule
//sstate suitation simulation in different different sstates
