//fifo_interface

interface fifo_intrf(input wr_clk,rd_clk,rst);
     bit wr_en;
	 bit rd_en;
	 bit[`WIDTH-1:0] wdata;
	 bit[`WIDTH-1:0] rdata;
	 bit full,overflow,empty,underflow;

	 clocking wr_bfm_cb @(posedge wr_clk);
          default input #1 output #0;
		  input full;
		  input overflow;
		  output wr_en;
		  output wdata;
	 endclocking

	 clocking rd_bfm_cb @(posedge rd_clk);
          default input #1 output #0;
		  input empty;
		  input rdata;
		  input underflow;
		  output rd_en;
	 endclocking

	 clocking wr_mon_cb @(posedge wr_clk);
          default input #1;
		  input full;
		  input overflow;
		  input wdata;
		  input wr_en;
	 endclocking

	 clocking rd_mon_cb @(posedge rd_clk);
          default input #1;
		  input empty;
		  input rdata;
		  input underflow;
		  input  rd_en;
	 endclocking

endinterface
