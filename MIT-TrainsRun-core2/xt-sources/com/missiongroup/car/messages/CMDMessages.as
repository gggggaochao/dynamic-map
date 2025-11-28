package com.missiongroup.car.messages
{
import com.missiongroup.metro.entities.TrainStation;
import com.spring.core.Message;

public class CMDMessages extends Message
{
	/**
	 * 线路号
	 */
	public var Line : String;
	
	/**
	 * 上下行（0:上行（内圈）	1:下行（外圈））
	 */
	public var Dir : Number;
	
	/**
	 * 起始站
	 */
	public var StartStation : TrainStation;
	
	/**
	 * 终点站
	 */
	public var EndStation : TrainStation;
	
	/**
	 * 当前站
	 */
	public var CurrentStation : TrainStation;
	
	/**
	 * 下一站
	 */
	public var NextStation : TrainStation;
	
	/**
	 * 开门侧（0：左侧开门	1：右侧开门	2：双侧开门	3:  双侧都不开门）
	 */
	public var DoorDir : Number;
	
	/**
	 * 结束符（？）
	 */
	public var isEnd : Boolean;
	
	/**
	 * 是否环线（0：本线非环线	1：本线环线）
	 */
	public var isRing : Number;
		

	/**
	 * 越站设置（0：当前站正常	1：当前站越站）
	 */	
	public var isPass : Number;
	
	
	/** 
	 * 越站恢复（0：不恢复当前越站	1：恢复当前越站信息） 
	 */
	public var isPassReset : Number;
	
	
	/**
	 * 钥匙信号（0: 钥匙在TC1端	1：钥匙在TC2端）
	 */	
	public var keyCode : Number;
	
	/**
	 * 车厢号是否反向（1,2,3：正向开门		4,5,6：反向开门）
	 */
	public var IsReverse : Number;
	
	// Add by chenjun according to <<功放与动态地图通信协议定义V2.2.docx>>
	/**
	 * 4号线是否最后一圈
	 * 0：否
	 * 1：是
	 */
	public var line4Flag : Number;
	
	public function CMDMessages(selector:String)
	{
		super(selector);
	}
}
}