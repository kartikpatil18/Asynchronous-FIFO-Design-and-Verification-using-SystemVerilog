//fifo_sbd class

class fifo_sbd;
   wr_tx w_t;
   rd_tx r_t;
   int que[$];
   int data;

   task run();
     $display("fifo_sbd is happening");
	 forever begin
       fifo_common::wr_mon2sbd.get(w_t);
	   w_t.print("wr_sbd");
      
	   if(fifo_common::testname != "FULL"  &&  fifo_common::testname != "OVERFLOW") begin
          fifo_common::rd_mon2sbd.get(r_t);
	      r_t.print("rd_sbd");

	      if(w_t.wr_en)  que.push_back(w_t.wdata);
	      if(r_t.rd_en) begin
             data = que.pop_front();
	         if(r_t.rdata == data) fifo_common::match++;
	         else fifo_common::mismatch++;
	      end
	   end
	   
	 end

   endtask

endclass
