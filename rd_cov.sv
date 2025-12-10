//rd_cov class

class rd_cov;
   rd_tx tx;

  covergroup cg;
      RD_EN :coverpoint tx.rd_en{
             bins R_E = {1'b1};
	  } 
  endgroup

   function new();
      cg = new();
   endfunction

   task run();
     $display("rd_cov is happening");
	 forever begin
       fifo_common::rd_mon2cov.get(tx);
	   tx.print("rd_cov");
	   cg.sample();
	 end
   endtask
   
endclass
