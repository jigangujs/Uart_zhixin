/*******************************************************************
*****串口发送模块
*****
*****
*******************************************************************/

module	Uart_tx(
	input					clk,
	input					rst_n,
	input		[3:0]		num,											//一帧数据有几位由num来决定
	input					sel_data,										//波特率技计数中心点（采集数据的使能信号）
	input		[7:0]		rx_data,
	output	reg				rs232_tx
);

always	@(posedge	clk	or	negedge	rst_n)
	if(!rst_n)
		rs232_tx	<=		1'b1;
	else
		if(sel_data)														//检测波特率采样中心点（使能信号）
			case(num)														//检测要发送的一帧数据有几位？
				0:	rs232_tx	<=		1'b0;								//开始位为低电平
				1:	rs232_tx	<=		rx_data[0];
				2:	rs232_tx	<=		rx_data[1];
				3:	rs232_tx	<=		rx_data[2];
				4:	rs232_tx	<=		rx_data[3];
				5:	rs232_tx	<=		rx_data[4];
				6:	rs232_tx	<=		rx_data[5];
				7:	rs232_tx	<=		rx_data[6];
				8:	rs232_tx	<=		rx_data[7];
				9:	rs232_tx	<=		1'b1;								//结束位为高电平
				default:	rs232_tx	<=		1'b1;					//在其他情况下一直处于拉高电平状态
			endcase
	
endmodule