`define WIDTH 8
`define FIFO_SIZE 16
`define PTR_WIDTH $clog2(`FIFO_SIZE)

class fifo_common;
    static string testname="OVERFLOW";
	static int N = 16;
	static mailbox wr_gen2bfm=new();
	static mailbox rd_gen2bfm=new();
	static int wr_gen_count;
	static int wr_bfm_count;
	static mailbox wr_mon2cov=new();
	static mailbox wr_mon2sbd=new();
	static mailbox rd_mon2cov=new();
	static mailbox rd_mon2sbd=new();
	static int wr_count;
	static int match,mismatch;

endclass

