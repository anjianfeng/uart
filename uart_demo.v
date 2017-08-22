// Author: Jianfeng An
// Date: 2017-08-21 15:07:24
// Write format: ‘h1256XXYYYYYYYY 
// Read  format: 'h1234XX
// 其中XX是8位地址，YYYYYYYY是32位数据
// 发送命令之后，返回值是读出或写入的数据


module uart #(
	parameter clk_freq = 100000000,
	parameter baud = 115200
) (
	input clk,
	input rst,

	input uart_rx,
	output uart_tx
);

wire [7:0] rx_data;
reg  [7:0] tx_data;
reg        tx_wr;

reg [2:0] state;
reg [2:0] counter;

reg [31:0] example_reg[3:0];

reg        cmd;
reg [7:0] cmd_addr;
reg [31:0] cmd_data;
reg [63:0] cmd_return;

parameter s_idle=0,
          s_cmd=1,
          s_addr=2,
          s_data=3,
          s_compute=4,
          s_done=5;

parameter cmd_read_flag='h34,
          cmd_write_flag='h56,
          cmd_start_flag='h12,
          cmd_read=0,
          cmd_write=1;			

uart_transceiver transceiver(
	.sys_clk(clk),
	.sys_rst(rst),

	.uart_rx(uart_rx),
	.uart_tx(uart_tx),

	//.divisor(clk_freq/baud/16),
	.divisor(1),

	.rx_data(rx_data),
	.rx_done(rx_done),

	.tx_data(tx_data),
	.tx_wr(tx_wr),
	.tx_done(tx_done)
);

always @(posedge clk) begin
   if (rst) begin
	    state<=s_idle;
		 tx_data<=0;
		 tx_wr<=0;
		 counter<=0;
		 example_reg[0]<=0;
		 example_reg[1]<=0;
		 example_reg[2]<=0;
		 example_reg[3]<=0;
		 cmd<=0;
		 cmd_addr<=0;
		 cmd_data<=0;
		 cmd_return<=0;
	end else
	case(state)
		s_idle: begin
		    tx_wr<=0;
			 if ((rx_done)&&(rx_data==cmd_start_flag))
                state<=s_cmd;
		end
		s_cmd: begin
		    counter<=3;
		    if ((rx_done)&&(rx_data==cmd_read_flag)) begin
                state<=s_addr;
                cmd<=cmd_read;
		    end 

		    if ((rx_done)&(rx_data==cmd_write_flag)) begin
                state<=s_addr;
                cmd<=cmd_write;
		    end 
		end
		s_addr: begin
		    if (rx_done) begin
		    	cmd_addr<=rx_data;
		    	counter<=counter-1;
		    	if (counter==0) begin
		    	    if (cmd==cmd_write) begin
		    	    	state<=s_data;
		    	    	counter<=3;
		    	    end else begin
		    	      state<=s_compute;
		    	    	counter<=7;
					 end
		    	end
		    end
		end
		s_data: begin
		    if (rx_done) begin
		    	cmd_data<={ cmd_data[23:0], rx_data};
		    	counter<=counter-1;
		    	if (counter==0) 
		    	     state<=s_compute;
		    end
	   end 
		s_compute: begin
		    state<=s_done;
			 
			 counter<=7;
		    
		    cmd_return[63:0]<=64'hFFFFFFFFFFFFFFFF;
		    
		    if (cmd==cmd_write) begin
		        cmd_return[47:16]<=cmd_data;
		        example_reg[cmd_addr[1:0]]<=cmd_data;
		    end else begin
		    	  cmd_return[47:16]<=example_reg[cmd_addr[1:0]];
		    end

		    tx_data<='hff;
		    tx_wr<=1;
      end
		s_done: begin
		    tx_wr<=0;
		    if (tx_done) begin
		    	  cmd_return<={cmd_return[55:0],8'h0};
		    	
		    	  tx_data<=cmd_return[55:48];
		        tx_wr<=1;
		        
		        counter<=counter-1;
		    	if (counter==0) 
		    	     state<=s_idle;
		    end
		end 
	endcase // state
end


endmodule