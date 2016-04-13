
/**************************************************************
********波特率计数模块
**1：确定发送数据和接收数据的有效范围
**2：进行分频计数（此例中波特率9600bps，时钟50MHz，则分频计数为5207）
**************************************************************/
module		Bps_select(
	input					clk,													//系统时钟50MHz	
	input					rst_n,													//低电平复位
	input					en,														//使能信号：串口接收活发送开始
	output		reg			sel_data,												//波特率计数中心点（采集数据的使能信号）
	output		reg	[3:0]	num													//一帧数据bit0~bit9
);
	parameter		bps_div	=	13'd5207,										//(1/9600*1000000*1000/20)
					bps_div2	=	13'd2603;
					
//发送/接收标志位：接收到使能信号en后，将标志位flag拉高，当计数信号num记完一帧数据后将flag拉低
	reg		flag;
always	@(posedge	clk	or	negedge	rst_n)
	if(!rst_n)
		flag	<=	0;
	else
		if(en)
			flag	<=	1;
		else
			if(num	==	4'd10)														//计数完成？
				flag	<=	0;

//波特率计数
	reg		[12:0]		cnt;
always	@(posedge	clk	or	negedge	rst_n)
	if(!rst_n)
		cnt		<=		13'd0;
	else
		if(flag	&&	cnt	<	bps_div)
			cnt		<=		cnt		+	1'b1;
		else
			cnt		<=		13'd0;

//规定发送数据和接收数据的范围：一帧数据为10bit：1bit开始位+8bit数据位+1bit停止位			
always	@(posedge	clk	or	negedge	rst_n)
	if(!rst_n)
		num	<=		4'd0;
	else
		if(flag	&&	sel_data)
			num		<=		num	+1'b1;
		else
			if(num	==	4'd10)
				num		<=		1'd0;

//数据在波特率的中间部分采集，即：发送/接收数据的使能信号
always	@(posedge	clk	or	negedge	rst_n)
	if(!rst_n)
		sel_data	<=		1'b0;
	else
		if(cnt	==	bps_div2)												//中间取数是为了产生尖峰脉冲，尖峰脉冲为采集数据使能信号，用来把握速率
			sel_data	<=	1'b1;
		else
			sel_data	<=	1'b0;

endmodule

/*
parameter         bps9600     = 5207,    //波特率为9600bps
                 bps19200     = 2603,    //波特率为19200bps
                bps38400     = 1301,    //波特率为38400bps
                bps57600     = 867,    //波特率为57600bps
                bps115200    = 433;    //波特率为115200bps 

parameter        bps9600_2     = 2603,
                bps19200_2    = 1301,
                bps38400_2    = 650,
                bps57600_2    = 433,
                bps115200_2 = 216;  
*/