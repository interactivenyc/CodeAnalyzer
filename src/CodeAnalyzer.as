package 
{
	import com.inyc.codeanalyzer.models.AppModel;
	import com.inyc.codeanalyzer.view.AppView;
	import com.inyc.core.Config;
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.events.LoaderUtilsEvent;
	import com.inyc.utils.LoaderUtils;
	
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	[SWF(width=1024,height=768)]
	public class CodeAnalyzer extends CoreMovieClip{
		
		private var _appModel:AppModel;
		private var _appView:AppView;
		
		private var _fileData:String;
		private var _fileArray:Array;
		
		private var _viewContainer:CoreMovieClip;
		
		private var _loaderUtils:LoaderUtils;
		
		public static var STAGE_WIDTH:int = 1024;
		public static var STAGE_HEIGHT:int = 768;
		public static var SCALE_X:Number = 1;
		public static var SCALE_Y:Number = 1;
		
		public function CodeAnalyzer(){
			super();
			log("CodeAnalyzer");
			
//			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
//			stage.quality = StageQuality.MEDIUM; // .HIGH; //
//			stage.stageWidth = STAGE_WIDTH;
//			stage.stageHeight = STAGE_HEIGHT;
			
			init();
			
		}
		
		override protected function init():void{
			_viewContainer = new CoreMovieClip();
			addChild(_viewContainer);
			_loaderUtils = new LoaderUtils();
			_loaderUtils.addEventListener(LoaderUtilsEvent.FILE_LOADED, fileDataLoaded);
			_loaderUtils.readFile(Config.ROOT_PATH + "/files.txt");
		}
		
		
		private function fileDataLoaded(e:GenericDataEvent):void {
			log("fileDataLoaded");
			_loaderUtils.removeEventListener(LoaderUtilsEvent.FILE_LOADED, fileDataLoaded);
			_fileData = e.data.file;
			//log(_fileData);
			_fileArray = _fileData.split(/\n/);
			_appModel = new AppModel(_fileArray);
			_appView = new AppView(_appModel);
			_viewContainer.addChild(_appView);
		}
		
	}
}
