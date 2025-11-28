package com.missiongroup.car.services
{
import com.missiongroup.car.consts.CMD;
import com.missiongroup.car.messages.CMDMessages;
import com.missiongroup.metro.core.AppCache;
import com.missiongroup.metro.entities.TrainStation;
import com.missiongroup.metro.servers.Services;
import com.spring.managers.SpringBeanManager;
import com.struts.utils.HashTable;
import com.missiongroup.car.views.LineCanvas;
import com.missiongroup.car.messages.Logtmp

public class CMDServices extends Services
{
	
	private var keys : HashTable = SpringBeanManager.getBean("stationsMap");

	public function CMDServices()
	{
		super([CMD.ArrivedStation,
				CMD.ArrivedStation_End,
				CMD.LeaveStation,
				CMD.ChangeLine,
				CMD.PassStation,
				CMD.PassStation_ReSet,
				CMD.LeaveStation,
				CMD.LeaveStation_End]);
	}
	
	
	override public function commandHandler():void
	{
		var selector : String;
		switch(cmd)
		{
//			case CMD.LeaveStation:
//			case CMD.LeaveStation_End:
//				selector = "WillArriveCMD";
//				break;
			case CMD.ArrivedStation : 
			{
				selector = "ArrivedCMD";
				break;
			}
			case CMD.ArrivedStation_End :
			{
				selector = "ArrivedEndCMD";
				break;
			}
			case CMD.LeaveStation :
			{
				selector = "LeaveCMD";
				break;
			}
				
			case CMD.LeaveStation :
			{
				selector = "LeaveEndCMD";
				break;
			}
				
			case CMD.ChangeLine :
			{
				selector = "ChangeLine";
				break;
			}
				
				
			case CMD.PassStation :
			{
				selector = "PassStation";
				break;
			}
				
			case CMD.PassStation_ReSet :
			{
				selector = "PassStationReSet";
				break;
			}			
		}
		
		if(selector)
		{
			try
			{
				// 忽略掉第一个数字：功能码
				
				// 1.线路号
				var Line : String = this.command.Content.@LineNum;
				
				// 2.上下行（0:上行（内圈）	1:下行（外圈））
				var Dir : Number = Number(this.command.Content.@Dir);
				
				// 3.起始站
				var StartStationNum : Number = Number(this.command.Content.@StartStation);
				
				// 4.当前站
				var CurrStationNum : Number = Number(this.command.Content.@CurrStation);
				
				// 5.下一站
				var NextStationNum : Number = Number(this.command.Content.@NextStation);
				
				// 6.终点站
				var EndStationNum : Number = Number(this.command.Content.@EndStation);
				
				// 7.开门侧（0：左侧开门	1：右侧开门	2：双侧开门	3:  双侧都不开门）
				var DoorDirNum : Number = Number(this.command.Content.@DoorDir);
				
				// 8.是否环线（0：本线非环线	1：本线环线）
				var isRing : Number = Number(this.command.Content.@isRing);
				
				// 9.越站设置（0：当前站正常	1：当前站越站）
				var isPass : Number = Number(this.command.Content.@isPass);
				
				// 10.越站恢复（0：不恢复当前越站	1：恢复当前越站信息）
				var isPassReset : Number = Number(this.command.Content.@isPassReset);
				
				// 11.钥匙信号（0: 钥匙在TC1端	1：钥匙在TC2端）
				var keyCode : Number = Number(this.command.Content.@keyCode);
				
				// 12.车厢号是否反向（1,2,3：正向开门		4,5,6：反向开门）
				var isReverse : Number = Number(this.command.Content.@isReverse);
				
				// 13.4号线是否最后一圈（0：否 	1：是）
				var line4Flag : Number = Number(this.command.Content.@line4Flag);
				
				
				var getStationLineKey:String = Line;
				
//				//线路号为5时，取线路号为4的数据
				if(Line == "5"){
					Line = '4_2';
					getStationLineKey = Dir == 0 ? "4_2_up_" : "4_2_down_";
					if(selector == 'LeaveCMD' || selector == 'LeaveEndCMD'){
						selector = 'WillArriveCMD';
					}
					if(selector == 'ChangeLine'){
						selector = 'LeaveCMD5';
					}
				}
				
				var message : CMDMessages = new CMDMessages(selector);
				message.Line = Line;
				message.Dir = Dir;
				message.DoorDir = DoorDirNum;
				message.isEnd = CurrStationNum == EndStationNum;
				message.StartStation = getStation(getStationLineKey,StartStationNum);
				message.NextStation = getStation(getStationLineKey,NextStationNum);
				message.CurrentStation = getStation(getStationLineKey,CurrStationNum);
				message.EndStation = getStation(getStationLineKey,EndStationNum);
				message.isRing = isRing;
				message.isPass = isPass;
				message.isPassReset = isPassReset;
				message.keyCode = keyCode;
				message.IsReverse = isReverse;
				message.line4Flag = line4Flag;
				
				message.CurrentStation.IsPass = message.isPass == 1;
				

				var msg:String = this.command.Cmd + " " + Line+" "+Dir  +" "+StartStationNum+" "+CurrStationNum +" "+NextStationNum+" "+EndStationNum
					+" "+DoorDirNum
					+" "+isRing
					+" "+isPass 
					+" "+isPassReset
					+" "+keyCode
					+" "+isReverse 
					+" "+line4Flag;
				
				logger.info(msg);
				trace("CMD MSG=========="+msg);
				// 添加代码，将报文内容发送到LineCanvas进行显示
		try {
			// 创建一个消息对象，使用"ShowCommandMsg"作为selector
			var message1 : Logtmp = new Logtmp("ShowCommandMsg");
			message1.msg =  msg;
			dispatcher(message1);
			trace("Sent command message via dispatcher: " + msg);
		} catch (e:Error) {
			logger.error("Failed to dispatch command message: " + e.message);
		}
				dispatcher(message);
			}
			catch(error : Error)
			{
				logger.error(error.getStackTrace());
			}

		}
	}
	
	
//	public function pushMessage(message:CMDMessages,msg:String):void {
//		logger.info(msg);
//		dispatcher(message);
//	}
	
	
	
	
	private function getStation(line : String,stationNum : Number) : TrainStation
	{
		var sKey : String = stationNum > 9 ? String(stationNum) : "0" + stationNum;
		sKey = keys ? keys.find(line + sKey) : sKey;
		trace("------------------    "+sKey + "======="+AppCache.Stations.find(sKey));
		return AppCache.Stations.find(sKey);
	}
	
	
}
}