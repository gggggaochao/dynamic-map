package com.struts.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.core.IVisualElement;

	import spark.components.Button;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.core.NavigationUnit;
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalAlign;
	import spark.layouts.VerticalLayout;
	import spark.layouts.supportClasses.LayoutBase;

	public class PageContainer extends SkinnableContainer
	{
		[SkinPart(required="false")]
		public var footerGroup : Group;

		[SkinPart(required="false")]
		public var nextButton: Button;

		[SkinPart(required="false")]
		public var preButton : Button;

		private var _anmiatePage : Animate;

		private var _simpleMotionPath : SimpleMotionPath;

		private var _mode : String = "Horizontal";

		/**
		 *  分页模式，水平分页和垂直分页
		 *
		 * */
		[Inspectable(category="General", enumeration="Horizontal,Vertical", defaultValue="Horizontal")]
		public function get mode():String
		{
			return _mode;
		}

		public function set mode(value:String):void
		{
			_mode = value;

			invalidateProperties();
		}

		private var _sumPage : Number = 0;

		private var _currentPage : Number = 1;

		private var _footerHeight : Number = 0;

		public function get currentPage():Number
		{
			return _currentPage;
		}

		public function set currentPage(value:Number):void
		{
			_currentPage = value;
		}

		public function PageContainer()
		{
			super();

			_anmiatePage = new Animate();
			_simpleMotionPath = new SimpleMotionPath();

			if(!_anmiatePage.motionPaths)
				_anmiatePage.motionPaths = new Vector.<MotionPath>();

			_anmiatePage.motionPaths.push(_simpleMotionPath);

		}

		protected override function commitProperties():void
		{
			super.commitProperties();

			if(contentGroup)
			{

				_simpleMotionPath.property = _mode == "Horizontal" ? 
					"horizontalScrollPosition"
					:
					"verticalScrollPosition";

				contentGroup.layout = getLayoutBase();

			}
		}

		private function getLayoutBase() : LayoutBase
		{
			if(_mode == "Horizontal")
			{
				var _horizontalLayout : HorizontalLayout = new HorizontalLayout();
				_horizontalLayout.verticalAlign = VerticalAlign.MIDDLE;
				_horizontalLayout.horizontalAlign =  HorizontalAlign.CENTER;

				return _horizontalLayout;
			}
			else
			{
				var _verticalLayout : VerticalLayout = new VerticalLayout();
				_verticalLayout.verticalAlign = VerticalAlign.MIDDLE;
				_verticalLayout.horizontalAlign =  HorizontalAlign.CENTER;

				return _verticalLayout;		

			}
		}

		protected override function createChildren():void
		{
			super.createChildren();


		}

		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);

			addtoStageHandler(null);

		}

		private function addtoStageHandler(event : Event) : void
		{
			_sumPage = contentGroup.numElements;

			for (var i:int=0;i<_sumPage;i++)
			{
				var childrenElement : IVisualElement =  contentGroup.getElementAt(i);
				childrenElement.width = contentGroup.width;
				childrenElement.height = contentGroup.height;
			}	
		}

		override public function addElement(element:IVisualElement):IVisualElement
		{
			return super.addElement(element);
		}

		protected override function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);

			if(contentGroup == instance)
			{
				_anmiatePage.target = contentGroup;
			}

			if(nextButton == instance)
			{
				nextButton.addEventListener(MouseEvent.CLICK,nextPageHandler);
			}

			if(preButton == instance)
			{
				preButton.addEventListener(MouseEvent.CLICK,prePageHandler);
			}
		}



		/**
		 * 下一页
		 */
		protected function nextPageHandler(event:Event):void
		{
			_currentPage ++;
			_simpleMotionPath.valueBy = contentGroup.getHorizontalScrollPositionDelta(NavigationUnit.PAGE_RIGHT);
			_anmiatePage.play();
		}

		/**
		 * 上一页
		 */
		protected function prePageHandler(event:Event):void
		{
			_currentPage--;
			_simpleMotionPath.valueBy = contentGroup.getHorizontalScrollPositionDelta(NavigationUnit.PAGE_LEFT);
			_anmiatePage.play();
		}
	}
}












