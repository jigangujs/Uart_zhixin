/*******************************************************************
*****串口接收模块
*****1：确认开始位（检测低电平）
*****2：采集8bit有效数据位
*******************************************************************/

module		Uart_rx(
	input					clk,																	//系统50MHz时钟
	input					rst_n,																	//复位，低电平有效
	input					rs232_rx,																//输入串行数据
	input		[3:0]		num,																	//控制一帧数据有多少bit
	input					sel_data,																//波特率计数的中心点（采集数据的使能信号）
	output					rx_en,																	//接收信号使能：启动接收波特率计数
	output	reg				tx_en,																	//发送信号使能：接收数据完成后，开始启动发送数据
	output	reg	[7:0]		rx_data																//将接收到的8bit的串行数据转换为并行数据
);

//检测低电平信号（开始位）
	reg		in_1,in_2;
always	@(posedge	clk	or	negedge	rst_n)
	if(!rst_n)
		begin
			in_1	<=		1'b1;
			in_2	<=		1'b1;
		end
	else
		begin
			in_1	<=		rs232_rx;
			in_2	<=		in_1;
		end
assign		rx_en	=	in_2	&	(~in_1);														//当检测到信号由高变低时，将使能信号拉高

//确保一帧数据的中间8bit进行数据的读取，读取完成后，使能信号tx_en控制串口发送模块
	reg		[7:0]	rx_data_r;												//锁存数据寄存器
always	@(posedge	clk	or	negedge	rst_n)
	if(!rst_n)
		begin
			rx_data_r	<=		8'd0;
			rx_data	<=		8'd0;
		end
	else
		if(sel_data)
			case(num)
				0:									;						//忽略开始位
				1:	rx_data_r[0]	<=		rs232_rx;						//采集中间八位有效数据
				2:	rx_data_r[1]	<=		rs232_rx;
				3:	rx_data_r[2]	<=		rs232_rx;
				4:	rx_data_r[3]	<=		rs232_rx;
				5:	rx_data_r[4]	<=		rs232_rx;
				6:	rx_data_r[5]	<=		rs232_rx;
				7:	rx_data_r[6]	<=		rs232_rx;
				8:	rx_data_r[7]	<=		rs232_rx;
				9:	rx_data		<=		rx_data_r;						//锁存采集的8位有效数据（忽略停止位）
				default:							;						//默认状态下不采集
			endcase

//发送使能模块，检测数据接收是否完成？完成后就将tx_en拉高（开始启动数据发送模块）
always	@(posedge	clk	or	negedge	rst_n)
	if(!rst_n)
		tx_en	<=		0;
	else
		if(num	==	4'd9	&&	sel_data)									//接收停止之后拉高一个时钟
			tx_en	<=		1;
		else
			tx_en	<=		0;
		


endmodule