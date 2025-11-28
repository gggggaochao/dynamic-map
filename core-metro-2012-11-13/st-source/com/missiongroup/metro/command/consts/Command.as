package com.missiongroup.metro.command.consts
{
public class Command
{
	//0x00	心跳请求
	public static const Keep_HeartBeat : uint = 0x00;
	
	//0x01	心跳应答
	public static const Keep_HeartBeat_Reply : uint = 0x01;
	//0x02	
	//…	
	//0x19	
	//0x20	开机
	//0x21	开机应答
	//0x22	重启
	//0x23	重启确认
	//Ox24	关机
	//0x25	关机确认
	//0x26	PDP开屏
	//0x27	PDP开屏应答
	//0x28	PDP关屏
	//0x29	PDP关屏应答
	//0x30	PDP音量控制
	//0x31	PDP音量控制反馈
	//0x32	PDP静音及恢复
	//0x33	PDP静音及恢复反馈
	//0x34	截图
	//0x35	截图反馈        
	//0x36	PDP静音恢复
	//0x37	PDP静音恢复反馈
	//0x38	PDP状态查询
	//0x39	PDP状态查询反馈
	
	//0x40	系统文件传输
	//0x41	系统文件传输应答
	//0x46	LED开屏
	//0x47	LED开屏应答
	//0x48	LED关屏 
	//0x49	LED关屏应答
	//0x4A	LED信息发布
	//0x4B	LED信息应答
	
	//0x50	资源文件传输
	//0x51	资源文件传输应答
	//0x60	请求下发全路径
	//0x61	请求下发全路径应答
	//0x62	下发全路径更新
	//0x63	下发全路径更新
	//0x70	天气数据
	//0x71	天气数据应答
	//0x72  TOS数据
	//0x73  TOS数据应答
	//0x74  ATS数据
	//0x75  ATS数据应答
	//0x76     综合监控数据
	//0x77     综合监控数据应答
	//0x78     空轨数据
	//0x79     空轨数据应答
	//0x80	一般滚动信息
	//0x81	取消一般滚动信息
	//0x82	紧急信息
	//0x83	取消紧急信息
	//0x84	一般滚动信息应答
	//0x85	取消一般滚动信息应答
	//0x86	紧急信息应答
	//0x87	取消紧急信息应答
	//0x88	首末班车时间
	//0x89	首末班车时间反馈
	//0x90	播放任务发布
	//Ox91	播放任务发布反馈
	
	//0x95	中心获取路由列表(OCC、PCC都一样)
	//0x96	中心获取路由列表应答
	//0x9B	IPIS显示消息
	//0x9C	IPIS取消全屏显示消息
	//0x9D	IPIS失物招领

	
	/**
	 *  查询机
	 * public static const TCM : uint = 0x03;
	 */	
	
	
	/**
	 *  重启计算机
	 */	
	public static const ReStart : uint = 0x01;
	//public static const ReStart : uint = 0x22;
	//public static const ReStart_Reply : uint = 0x23;
	
	/**
	 *  关机 
	 */	
	public static const ShutDown : uint = 0x02;
	//public static const ShutDown : uint = 0x24;
	//public static const ShutDown_Reply : uint = 0x78;

	
	/**
	 *  动态信息发布 
	 */	
	public static const Dynamic_Message : uint = 0x9B;
	//public static const Dynamic_Message_Reply : uint = 0x22;
	
	//public static const Normal_Message : uint = 0x03;
	//public static const Emerg_Message : uint = 0x04;
	
	
	/**
	 * 天气信息发布 
	 */	
	public static const Weather_Data : uint = 0x70;
	//public static const Weather_Data_Reply : uint = 0x71;

	
	/**
	 *  空轨信息发布 
	 */	
	public static const EmptyRail_Data : uint = 0x78;
	//public static const EmptyRail_Data_Reply : uint = 0x22;

	/**
	 *  IPIS通用功能码
	 */	
	public static const Other : uint = 0x03;
	
	 
	/**
	 *  iPis3 在线升级 
	 */	
	public static const Online_Update : uint = 0x04;
	
	/**
	 *  地铁信息发布 
	 */	
	public static const Metro_Data : uint = 0x05;
		
	
	/**
	 *  信息回复模版 
	 */	
	public static const REPLY_TEMPLETA : String = "<?xml version='1.0' encoding='utf-8' ?><msg><status>{0}</status><data>{1}</data></msg>";
	
}
}





