//wr_mon class

class wr_mon;
   wr_tx tx;
   virtual fifo_intrf vif;
   task run();
     vif = tb.pif;
     //$display("wr_mon is happening");
     forever begin
       @(vif.wr_mon_cb);
	   if(vif.wr_mon_cb.wr_en == 1) begin
          tx = new();
		  tx.wr_en = vif.wr_mon_cb.wr_en;
		  tx.wdata = vif.wr_mon_cb.wdata;
		  tx.full = vif.wr_mon_cb.full;
		  tx.overflow = vif.wr_mon_cb.overflow;
		  tx.print("wr_mon");
		  fifo_common::wr_mon2sbd.put(tx);
		  fifo_common::wr_mon2cov.put(tx);
	   end
       
	 end
   endtask

endclass
