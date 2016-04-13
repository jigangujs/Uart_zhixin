module	Uart_top(
	input				clk,
	input				rst_n,
	input				rs232_rx,
	output				rs232_tx
);

	wire				rx_en;
	wire				sel_data,sel_data_rx,sel_data_tx;
	wire				tx_en;
	wire	[3:0]		num,num_rx,num_tx;
	wire	[7:0]		rx_data;

	
Bps_select		Bps_rx(
	.clk						(clk),				//系统时钟50MHz	
	.rst_n						(rst_n),				//低电平复位
	.en							(rx_en),			//使能信号：串口接收活发送开始
	.sel_data					(sel_data_rx),		//波特率计数中心点（采集数据的使能信号）
	.num						(num_rx)			//一帧数据bit0~bit9
);	

Uart_rx		Uart_rx_inst(						//串口接收模块例化
	.clk							(clk),
	.rst_n							(rst_n),
	.rs232_rx						(rs232_rx),
	.num							(num_rx),
	.sel_data						(sel_data_rx),
	.rx_en							(rx_en),
	.tx_en							(tx_en),
	.rx_data						(rx_data)
);

Bps_select		Bps_tx(
	.clk						(clk),				//系统时钟50MHz	
	.rst_n						(rst_n),				//低电平复位
	.en							(tx_en),			//使能信号：串口接收活发送开始
	.sel_data					(sel_data_tx),		//波特率计数中心点（采集数据的使能信号）
	.num						(num_tx)			//一帧数据bit0~bit9
);	

Uart_tx		Uart_tx_inst(						//串口发送模块例化
	.clk						(clk),
	.rst_n						(rst_n),
	.num						(num_tx),
	.sel_data					(sel_data_tx),
	.rx_data					(rx_data),
	.rs232_tx					(rs232_tx)
);


endmodule