package
{
	import com.inyc.core.CoreMovieClip;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import com.inyc.codeanalyzer.CodeAnalyzer;
	
	[SWF(width=1200,height=800)]
	public class MainWebApp extends CoreMovieClip
	{
		private var _codeAnalyzer:CodeAnalyzer;
		
		public static var deviceWidth:int;
		public static var deviceHeight:int;
		
		public static var aspectRatio:Number;
		public static var stageScale:Number = 1;
		
		public function MainWebApp(){
			super();
			log("CONSTRUCTOR");
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			initCodeAnalyzer(null);
		}
		
		
		private function handleResize(e:Event = null) :void { 
			deviceWidth = stage.stageWidth;
			deviceHeight = stage.stageHeight;
			aspectRatio = deviceWidth/deviceHeight;
			
			log("handleResize(e)");
			log("***************************************");
			log("DEVICE_SCREEN: "+deviceWidth + " x " + deviceHeight);
			log("ASPECT_RATIO: "+aspectRatio);
			log("stageScale: "+stageScale);
			log("***************************************");	
		}
		
		
		private function initCodeAnalyzer(e:Event = null) :void { 
			stage.removeEventListener(Event.RESIZE, initCodeAnalyzer);
			_codeAnalyzer = new CodeAnalyzer();
			addChild(_codeAnalyzer);
		}
		
	}
}