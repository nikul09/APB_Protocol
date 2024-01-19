
vlog -coveropt 3 +cover +acc ../RTL/APBslave.v ../TEST/apb_pkg.svh ../TOP/top.sv +incdir+../uvm-1.2/src +incdir+../ENV +incdir+../TEST

vsim -coverage -vopt apb_top -sv_lib C:/questasim64_2021.1/uvm-1.1d/win64/uvm_dpi +UVM_TESTNAME=apb_test +UVM_OBJECTION_TRACE -c -do "coverage save -onexit -directive -cvg -codeall wr_rd_cov.ucdb; run -all; exit"

add wave -position insertpoint sim:/apb_top/apb_uu/*

add wave -position insertpoint sim:/apb_top/pinf/*

run -all

#vlog -coveropt 3 +cover +acc  ..\RTL\ram_16x8.v ..\TEST\ram_pkg.sv ..\TOP\ram_tb_top.sv +incdir+..\ENV +incdir+..\TEST

#vsim -coverage -vopt ram_tb_top -c -do "coverage save -onexit -directive -cvg -codeall wr_rd_cov.ucdb; run -all; exit" +WR_RD_TEST
