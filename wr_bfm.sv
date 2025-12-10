//wr_bfm class

class wr_bfm;
    wr_tx tx;
	virtual fifo_intrf vif;

	task run();
	   $display("wr_bfm is happening");
       vif = tb.pif;
	   forever begin
         fifo_common::wr_gen2bfm.get(tx);
	     drive_tx(tx);
         //fifo_common::wr_count++;
		 fifo_common::wr_bfm_count++;
	     tx.print("wr_bfm");
	   end
	endtask

	task drive_tx(wr_tx tx);
       @(vif.wr_bfm_cb);
	     vif.wr_bfm_cb.wr_en <= tx.wr_en;
	     vif.wr_bfm_cb.wdata <= tx.wr_en ? tx.wdata : 0;
	     tx.full <= vif.wr_bfm_cb.full;
	     tx.overflow <= vif.wr_bfm_cb.overflow;
	   @(vif.wr_bfm_cb);
	   vif.wr_bfm_cb.wr_en <= 0;
	   vif.wr_bfm_cb.wdata <= 0;

	endtask
endclass
