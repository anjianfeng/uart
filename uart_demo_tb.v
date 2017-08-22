// Author: Jianfeng An
// 2016-08-15 10:18:14

module tb ();

	reg sys_rst;
	reg sys_clk;

	reg [15:0] divisor;

	wire [7:0] rx_data;
	wire rx_done;

	reg [7:0] tx_data;
	reg tx_wr;
	wire tx_done;

uart_transceiver SEND(
	. sys_rst(sys_rst),
	. sys_clk(sys_clk),

	. uart_rx(uart_rx),
	. uart_tx(uart_tx),

	. divisor(divisor),

	. rx_data(rx_data),
	. rx_done(rx_done),

	. tx_data(tx_data),
	. tx_wr(tx_wr),
	. tx_done(tx_done)
);

uart  DUT(
	. clk(sys_clk),
	. rst(sys_rst),

	. uart_rx(uart_tx),
	. uart_tx(uart_rx)
);



   initial begin
      //divisor = 100000000/16/115200;
      divisor = 1 ; // For simulate fast
      sys_rst = 0 ;
	   sys_clk = 0 ;
      tx_wr=0;
      tx_data=8'b10101010;
      #5 ;
      sys_rst = 1 ;
      #20 ;
      sys_rst = 0 ;
      #100 ;
		
		// Write test
      tx_wr=1;
      tx_data='h12;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h56;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h01;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h02;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h03;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h04;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h05;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h06;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h07;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h08;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h09;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
		
		// Read test
		#20000;
      tx_wr=1;
      tx_data='h12;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h34;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h01;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h02;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h03;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);
      tx_wr=1;
      tx_data='h04;
		#15 ;tx_wr=0;
      #10 ;wait (tx_done);

   end
   
   always
	   #(5) sys_clk = ~sys_clk; // 100 MHz,  10 ns

endmodule
