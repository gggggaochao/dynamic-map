package test
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;

	public class TestLog extends UIComponent
	{
		
		public static var I:TestLog;
		
		private var _text:TextField;
		
		public function TestLog()
		{
			I = this;
			_text = new TextField();
			_text.background = true;
			_text.backgroundColor = 0xffffff;
			
			var tf:TextFormat = new TextFormat();
			tf.size = 14;
			
			_text.defaultTextFormat = tf;
			addChild(_text);
		}
		
		public function log(v:String):void{
			_text.text = v;
		}
		
		
	}
}