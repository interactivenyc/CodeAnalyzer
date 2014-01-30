package
{
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width=1200,height=800)]
	public class Main extends MovieClip
	{
		private var _codeAnalyzer:CodeAnalyzer;
		
		//private var _sprite:Sprite;
		//private var _mainMC:MovieClip;
		
		//public static const STAGE_WIDTH:int = 1600;
		//public static const STAGE_HEIGHT:int = 900;
		
		public static var deviceWidth:int;
		public static var deviceHeight:int;
		
		//public static var visibleWidth:Number;
		//public static var leftEdge:Number;
		public static var aspectRatio:Number;
		public static var stageScale:Number = 1;
		
		public function Main(){
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage.addEventListener(Event.RESIZE, handleResize);
			stage.addEventListener(Event.RESIZE, initCodeAnalyzer);
			
			trace("[ Main ] constructor Desktop");
			
		}
		
		
		private function handleResize(e:Event = null) :void { 
			
			deviceWidth = stage.stageWidth;
			deviceHeight = stage.stageHeight;
			//stageScale = deviceHeight / STAGE_HEIGHT;
			aspectRatio = deviceWidth/deviceHeight;
			//visibleWidth = STAGE_HEIGHT * aspectRatio;
			//leftEdge = (STAGE_WIDTH - visibleWidth) / 2;
			//CONFIG::DEBUG {
				trace("[ Main ] handleResize(e)");
				trace("***************************************");
				trace("DEVICE_SCREEN: "+stage.stageWidth + " x " + stage.stageHeight);
				trace("ASPECT_RATIO: "+aspectRatio);
				//trace("LEFT_EDGE: "+leftEdge);
				//trace("VISIBLE_WIDTH: "+visibleWidth);
				trace("stageScale: "+stageScale);
				trace("***************************************");
			//}
				
//			_sprite.x = -(leftEdge * stageScale);
//			_sprite.scaleX = stageScale;
//			_sprite.scaleY = stageScale;
			
		}
		
		private function initCodeAnalyzer(e:Event = null) :void { 
			stage.removeEventListener(Event.RESIZE, initCodeAnalyzer);
			_codeAnalyzer = new CodeAnalyzer();
			addChild(_codeAnalyzer);
		}
	}
}