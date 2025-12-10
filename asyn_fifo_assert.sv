//assertions for asyn fifo

module asyn_fifo_ass(wr_clk,rd_clk,rst,wr_en,wdata,full,overflow,rd_en,rdata,empty,underflow);

   input wr_clk,rd_clk,rst,wr_en,rd_en;
   input [`WIDTH-1:0] wdata;
   input [`WIDTH-1:0] rdata;
   input full,overflow,empty,underflow;
   integer local_var = `FIFO_SIZE;
   
   //To check for wr_en is asserted or not
   property wr_en_check;
     @(posedge wr_clk) disable iff(rst) wr_en |-> !($isunknown(wdata)); 
   endproperty

   WR_EN : assert property(wr_en_check);

   //To check for rd_en is asserted or not
   property rd_en_check;
     @(posedge rd_clk) disable iff(rst) rd_en |-> !$isunknown(rdata);
   endproperty
   
  RD_EN : assert property(rd_en_check);

   //To check for full is asserted or not
   property full_check;
     @(posedge wr_clk) disable iff(rst) wr_en |-> ((asyn_fifo.wr_ptr==asyn_fifo.rd_ptr_wr_clk) && (asyn_fifo.wr_toggle_f!=asyn_fifo.rd_toggle_f_wr_clk)) |-> full;
   endproperty

   FL : assert property(full_check);


   //To check for empty is asserted or not
   property empty_check;
     @(posedge rd_clk) disable iff(rst) rd_en |-> ((asyn_fifo.wr_ptr_rd_clk==asyn_fifo.rd_ptr) && (asyn_fifo.wr_toggle_f_rd_clk==asyn_fifo.rd_toggle_f)) |-> empty;
   endproperty

   EM : assert property(empty_check);

   //To check for overflow is happened or not
   property overflow_check;
     @(posedge wr_clk) disable iff(rst) wr_en |-> ((asyn_fifo.wr_ptr==asyn_fifo.rd_ptr_wr_clk) && (asyn_fifo.wr_toggle_f!=asyn_fifo.rd_toggle_f_wr_clk)) |-> full |=> overflow;
   endproperty

   OV : assert property(overflow_check);

   //To check for underflow is happened or not
   property underflow_check;
     @(posedge rd_clk) disable iff(rst) rd_en |-> ((asyn_fifo.wr_ptr_rd_clk==asyn_fifo.rd_ptr) && (asyn_fifo.wr_toggle_f_rd_clk==asyn_fifo.rd_toggle_f)) |-> empty |=> underflow;
   endproperty

   UN : assert property(underflow_check);

   //To check for wr_ptr increament
   property wr_ptr_incr;
     @(posedge wr_clk) disable iff(rst) (wr_en && !full) |=> (dut.wr_ptr - 1'b1 == $past(dut.wr_ptr));
   endproperty

   W_PT: assert property(wr_ptr_incr); 

   //To check for rd_ptr increment
   property rd_ptr_incr;
      @(posedge rd_clk) disable iff(rst) (rd_en && !empty)|=> (dut.rd_ptr - 1'b1 == $past(dut.rd_ptr));
   endproperty 

   R_PT: assert property(rd_ptr_incr); 

endmodule
