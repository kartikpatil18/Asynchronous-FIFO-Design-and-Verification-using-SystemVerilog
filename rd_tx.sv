//rd_tx class

class rd_tx;
   //common properties
   rand bit rd_en;
        bit[`WIDTH-1:0] rdata;
        bit empty,underflow;

   //common methods
   function void print(input string str = "rd_tx");
      $display("%0t----------%0s-----------",$time,str);
	  $display("rd_en=%b",rd_en);
	  $display("rdata=%0d",rdata);
	  $display("empty=%b",empty);
	  $display("underflow=%b",underflow);
   endfunction

   //common constriants, either consider inclass or inline constraint

endclass
