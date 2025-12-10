//wr_cov class

class wr_cov;
   wr_tx tx;

   covergroup cg;
      WR_EN :coverpoint tx.wr_en{
             bins W_E = {1'b1};
	  }  
   
   endgroup 

   function new();
      cg = new();
   endfunction

   task run();
     $display("wr_cov is happening");
	 forever begin
       fifo_common::wr_mon2cov.get(tx);
	   tx.print("wr_cov");
	   cg.sample();
	 end
   endtask

endclass
