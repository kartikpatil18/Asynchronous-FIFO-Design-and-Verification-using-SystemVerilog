//top module

module tb;
   fifo_env env;
   bit wr_clk,rd_clk,rst;
   
   //physical interface instance
   fifo_intrf pif(wr_clk,rd_clk,rst);
   
   //DUT instantiation
   asyn_fifo dut(.wr_clk(pif.wr_clk),
                 .rd_clk(pif.rd_clk),
				 .rst(pif.rst),
				 .wr_en(pif.wr_en),
				 .wdata(pif.wdata),
				 .full(pif.full),
				 .overflow(pif.overflow),
				 .rd_en(pif.rd_en),
				 .rdata(pif.rdata),
				 .empty(pif.empty),
				 .underflow(pif.underflow));

	//asyn_fifo_assert instantiation (binding with dut)
    bind asyn_fifo asyn_fifo_ass a1(
	                       .wr_clk(wr_clk),
                           .rd_clk(rd_clk),
				           .rst(rst),
				           .wr_en(pif.wr_en),
				           .wdata(pif.wdata),
				           .full(pif.full),
				           .overflow(pif.overflow),
				           .rd_en(pif.rd_en),
				           .rdata(pif.rdata),
				           .empty(pif.empty),
				           .underflow(pif.underflow));

   always #5 wr_clk = ~wr_clk;
   always #7 rd_clk = ~rd_clk;
    
   initial begin
      $display("fifo_tb is happening");
      rst = 1;
	  repeat(2) @(posedge wr_clk);
	  rst = 0;

      env = new();
	  env.run();

   end

   initial begin
	  #1000;
	   //fifo scoreboard logic
	  $display("match=%0d,mismatch=%0d",fifo_common::match,fifo_common::mismatch);
	  if(fifo_common::match == `FIFO_SIZE && fifo_common::mismatch == 0)
	    $display("test is passed");
	  else $display("test is failed!");
	   
	  $finish();
   end

  endmodule

