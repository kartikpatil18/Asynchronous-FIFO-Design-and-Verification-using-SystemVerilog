//wr_tx class

class wr_tx;
   //common properties
   rand bit wr_en;
   rand bit[`WIDTH-1:0] wdata;
        bit full,overflow;

   //common methods
   function void print(input string str = "wr_tx");
      $display("%0t----------%0s-----------",$time,str);
	  $display("wr_en=%b",wr_en);
	  $display("wdata=%0d",wdata);
	  $display("full=%b",full);
	  $display("overflow=%b",overflow);
   endfunction

   //common constriants, either consider inclass or inline constraint

endclass
