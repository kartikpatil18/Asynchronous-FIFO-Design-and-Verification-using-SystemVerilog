//asynchronous fifo
//two differnt clks required for write and read

//`define WIDTH 32
//`define FIFO_SIZE 16
//`define PTR_WIDTH $clog2(`FIFO_SIZE)

module asyn_fifo(wr_clk,rd_clk,rst,wr_en,wdata,full,overflow,rd_en,rdata,empty,underflow);	
	input wr_clk, rd_clk, rst;
	input wr_en, rd_en;
	input [`WIDTH-1:0] wdata;
	output reg [`WIDTH-1:0] rdata;
	output reg full, overflow, empty, underflow;

	//--------------Local Signals-------------//

	// Binary pointer declaration
	reg [`PTR_WIDTH:0] wr_bin_ptr, rd_bin_ptr;
	//flag signals
	reg wr_toggle_f, rd_toggle_f;
	
	// gray pointer declaration
    wire [`PTR_WIDTH:0] wr_gray_ptr;
    wire [`PTR_WIDTH:0] rd_gray_ptr;
    
	reg [`PTR_WIDTH:0] rd_gray_sync1;
    reg [`PTR_WIDTH:0] rd_gray_sync2;

	reg [`PTR_WIDTH:0] wr_gray_sync1;
    reg [`PTR_WIDTH:0] wr_gray_sync2;
    
	// empty condition local signals
	wire [`PTR_WIDTH:0] rd_bin_next;
	wire [`PTR_WIDTH:0] rd_gray_next;
    
	// full condition local signals
	wire [`PTR_WIDTH:0] wr_bin_next;
    wire [`PTR_WIDTH:0] wr_gray_next;
	wire full_next;

	// fifo declaration
	reg [`WIDTH-1:0] fifo [`FIFO_SIZE-1:0];
	integer i;
	
	always @(posedge wr_clk or posedge rst) begin
		 if(rst==1) begin
			   full <= 0;
			   overflow <= 0;
			   wr_bin_ptr <= 0;
			   wr_toggle_f <= 0;
			   rd_toggle_f <= 0;
			
			   for(i = 0; i < `FIFO_SIZE; i = i + 1) fifo[i] <= 0;
		 end
		 else begin
		   //------------writes-----------//
	       overflow <= 0;
		   if(wr_en==1) begin
		      if(full==1) overflow <= 1;
			  else begin
			    fifo[wr_bin_ptr] <= wdata;
			    if(wr_bin_ptr==`FIFO_SIZE) begin
			       wr_bin_ptr <= 0;
				   wr_toggle_f <= ~wr_toggle_f;
			    end
			    else wr_bin_ptr <= wr_bin_ptr + 1;
			  end
		   end
		 end
	end
	
	//----------reads---------//
	always @(posedge rd_clk or posedge rst) begin
		  if(rst==1) begin
			   empty <= 1;
			   underflow <= 0;
			   rdata <= 0;
			   rd_bin_ptr <= 0;
		  end 
		  else begin
			 underflow <= 0;
		     if(rd_en==1) begin
		       if(empty==1) underflow <= 1;
		       else begin
			     rdata <= fifo[rd_bin_ptr];
			     if(rd_bin_ptr==`FIFO_SIZE)begin
		             rd_bin_ptr <= 0;
					 rd_toggle_f <= ~rd_toggle_f;
			     end
			     else rd_bin_ptr <= rd_bin_ptr + 1;
			   end
		     end
		  end
	end
		
    // Binary ptr to gray ptr conversion
    assign wr_gray_ptr = wr_bin_ptr ^ (wr_bin_ptr >> 1);
    assign rd_gray_ptr = rd_bin_ptr ^ (rd_bin_ptr >> 1);

	// 2_ff synchronizer
	// rd_gray_ptr in write clk domain
    always @(posedge wr_clk or posedge rst)
    begin
       if(rst)
       begin
          rd_gray_sync1 <= 0;
          rd_gray_sync2 <= 0;
       end
       else
       begin
          rd_gray_sync1 <= rd_gray_ptr;
          rd_gray_sync2 <= rd_gray_sync1;
       end
    end

	// wr_gray_ptr in read clk domain
    always @(posedge rd_clk or posedge rst)
    begin
       if(rst)
       begin
          wr_gray_sync1 <= 0;
          wr_gray_sync2 <= 0;
       end
       else
       begin
          wr_gray_sync1 <= wr_gray_ptr;
          wr_gray_sync2 <= wr_gray_sync1;
       end
    end
	
	// condition for empty and full

	//---------empty logic----------//
    assign rd_bin_next = rd_bin_ptr + (rd_en & ~empty);
    assign rd_gray_next = rd_bin_next ^ (rd_bin_next >> 1);

	always @(posedge rd_clk or posedge rst)
    begin
       if(rst) begin
	      empty <= 1;
	   end
	   else begin
          empty <= (rd_gray_next == wr_gray_sync2);
	   end
    end

	//---------full logic----------//
	assign wr_bin_next = wr_bin_ptr + (wr_en & ~full);
    assign wr_gray_next = wr_bin_next ^ (wr_bin_next >> 1);

    assign full_next =
     (
     wr_gray_next ==
     {
       ~rd_gray_sync2[`PTR_WIDTH:`PTR_WIDTH-1],  
        rd_gray_sync2[`PTR_WIDTH-2:0]
     }
     );
    
    always @(posedge wr_clk or posedge rst)
    begin
       if(rst) begin
	      full <= 0;
	   end
	   else begin
          full <= full_next;
	   end 
    end


endmodule




