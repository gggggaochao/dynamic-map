package com.missiongroup.metro.local
{
public class LocalCMD
{
	
	
	/**
	 * 
	 * 请求周边蓝牙设备指令 ：  [CMD=ALLBTS]
	 * 
	 * CMD ：指令
	 * 
	 * 返回：
	 * 
	 * "[CMD=ALLBTS&RES=设备1,设备2,设备3]"
	 *  
	 * RES ：设备列表
	 */	
	public static const BLUETOOTH_CMD : String  = "ALLBTS";
	
	
	
	/**
	 * 
	 * 蓝牙设备显示指令  [CMD=BT$BT=设备1&CONTENT=发送内容]
	 * 
	 *  BT : 设备名称
	 *  CONTENT :　发送内容
	 *
	 *  返回：
	 * 
	 * "[CMD=BTSEND&SUCCESS=1]"
	 *  
	 * SUCCESS :　0 失败 1 成功
	 */	
	public static const BLUETOOTH_SEND : String  = "BT";
	
	
	
	
	
	/**
	 * 
	 * 打印指令 [CMD=PRINT&CONTENT=打印内容]
	 * 
	 * CONTENT :　打印内容
	 * 
	 * 返回：
	 * 
	 * "[CMD=PRINT&SUCCESS=1]"
	 *  
	 * SUCCESS :　0 失败 1 成功
	 */	

	public static const PRINT_SEND : String = "PRINT";
	
	
	
	/**
	 * 
	 * 读卡指令 [CMD=CARD]
	 * 
	 * CONTENT :　打印内容
	 * 
	 * 返回：
	 * 
	 * "[CMD=CARD&RES=100233,102.2]"
	 *  
	 * RES :　卡号，余额
	 */	
	
	public static const CARD_CMD : String = "CARD";
	
	/**
	 * 更新文件[CMD=FILE]
	 * 
	 * bt:文件类型
	 * 
	 * CONTENT:文件路径
	 */
	public static const UPDATE_FILE :String = "FILE"; 
	
}
}