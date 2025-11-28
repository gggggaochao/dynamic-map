package
{
	import flash.display.Sprite;
	
	public class TrainsTools extends Sprite
	{
		public function TrainsTools()
		{
//			var source:Array = [1000128,1000025,1000024,1000023,1000022,1000021,1000020,1000019,1000018,1000017,1000016,1000015,1000138,1000013,1000105,1000104,1000103,1000102,1000101,1000145,1000109,1000108,1000107,1000106,1000076,1000141,1000142,1000060,1000143,1000144];
			
			var source:Array = [
				1000025,
				1000024,
				1000023,
				1000022,
				1000021,
				1000020,
				1000019,
				1000018,
				1000017,
				1000016,
				1000015,
				1000138,
				1000013,
				1000105,
				1000104,
				1000103,
				1000102,
				1000101,
				1000145,
				1000109,
				1000108,
				1000107,
				1000106,
				1000076,
				1000141,
				1000142,
				1000060,
				1000143,
				1000144,
				1000022
			];
			
			executeXML(source , '4_2_down_');
			
		}
		
		private function executeXML(source:Array , lineNum:String):void{
			for(var i:int ; i < source.length ; i++){
				var stationId:String = source[i].toString();
				var n:int = i + 1;
				var addNum:String = n < 9 ? '0'+n : n.toString();
				var key:String = lineNum+addNum;
				var value:String = source[i];
				var xml:String = '<String key="'+key+'" value="'+value+'"/>';
				trace(xml);
			}
		}
		
		private function executeSQL(source:Array):void{
			for(var i:int ; i < source.length ; i++){
				var stationId:String = source[i].toString();
				var order:int = i+1;
				var sql:String = "insert into MIT_App_LineStation (LineId,StationId,orderid,STime,ETime,WaitTime,DriveTime) values ('LINE_4_2_DOWN','"+stationId+"',"+order+",'5:15','22:10',29,520);";
				trace(sql);
			}
		}
		
		
	}
}