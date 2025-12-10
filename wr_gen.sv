//wr_gen class

class wr_gen;
   wr_tx tx;

   task run();
	   $display("wr_gen is happening");
      case(fifo_common::testname)
	  "FULL": begin
              writes(`FIFO_SIZE);
       end
	  "EMPTY": begin
               fifo_common::wr_gen_count = `FIFO_SIZE;
			   writes(`FIFO_SIZE);
       end
	  "OVERFLOW": begin
                  writes(`FIFO_SIZE+1);
       end
	  "UNDERFLOW": begin
                  writes(`FIFO_SIZE);
                  fifo_common::wr_gen_count = `FIFO_SIZE;
       end
	  "CONCURRENT": begin
                    writes(`FIFO_SIZE);
       end
	        default : $display("GEN: Invalid Test");

	  endcase
   endtask

   task writes(input int N);
       repeat(N) begin
	      tx = new();
		  tx.randomize() with {wr_en == 1'b1;};  //inline constraint
		  //tx.print("wr_gen");
		  fifo_common::wr_gen2bfm.put(tx);
	   end
   endtask

endclass
