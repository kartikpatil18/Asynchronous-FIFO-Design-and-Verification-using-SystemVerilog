//rd_gen class

class rd_gen;
   rd_tx tx;

   task run();
   $display("rd_gen is happening");
      case(fifo_common::testname)
        "FULL": begin

         end
      "EMPTY": begin
	           wait(fifo_common::wr_gen_count == fifo_common::wr_bfm_count);
			  // wait(fifo_common::wr_count == `FIFO_SIZE);
               reads(`FIFO_SIZE);
       end
      "OVERFLOW": begin

       end
      "UNDERFLOW": begin
	               wait(fifo_common::wr_gen_count == fifo_common::wr_bfm_count);
                   reads(`FIFO_SIZE+1);

       end
      "CONCURRENT": begin
                    reads(`FIFO_SIZE);
       end

      endcase
   endtask
   
   task reads(input int N);
       repeat(N) begin
          tx = new();
    	  tx.randomize() with {rd_en == 1'b1;};   //inline constraint
    	  //tx.print("rd_gen");
    	  fifo_common::rd_gen2bfm.put(tx);
       end
   endtask

endclass
