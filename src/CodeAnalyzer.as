package 
{
	import com.inyc.codeanalyzer.models.AppModel;
	import com.inyc.codeanalyzer.view.AppView;
	import com.inyc.codeanalyzer.view.MenuView;
	import com.inyc.components.IOSImageView;
	import com.inyc.core.Config;
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.events.LoaderUtilsEvent;
	import com.inyc.utils.LoaderUtils;
	import com.inyc.utils.MovieClipUtils;
	
	import flash.events.Event;
	
	
	public class CodeAnalyzer extends CoreMovieClip{
		
		private var _appModel:AppModel;
		private var _appView:AppView;
		private var _currentView:IOSImageView;
		
		private var _fileData:String;
		private var _fileArray:Array;
		
		private var _viewContainer:CoreMovieClip;
		
		private var _loaderUtils:LoaderUtils;
		
		public static var SCALE_X:Number = 1;
		public static var SCALE_Y:Number = 1;
		
		public function CodeAnalyzer(){
			log("CodeAnalyzer");
			super();
		}
		
		override protected function init():void{
			super.init();
			log("init");
		}
		
		
		override protected function onAddedToStage(e:Event):void{
			log("onAddedToStage stage.stageWidth: "+stage.stageWidth);
			super.onAddedToStage(e);
			setupViewContainer();
			//showMenu();
			loadFilesFromManifest();
			
		}
		
		
		override protected function onRemovedFromStage(e:Event):void{
			log("onRemovedFromStage");
			super.onRemovedFromStage(e);
		}
		
		
		
		
		private function showMenu():void {
			setView(new MenuView());
		}
		
		private function setView(view:IOSImageView):void{
			if(_currentView && _viewContainer.contains(_currentView)){
				_viewContainer.removeChild(_currentView);
			}
			_currentView = view;
			_viewContainer.addChild(view);
		}
		
		
		private function loadFilesFromManifest():void {
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
			setView(_appView);
		}
		
		private function setupViewContainer():void {
			log("setupViewContainer: ("+stage.stageWidth+", "+stage.stageHeight+")");
			_viewContainer = new CoreMovieClip();
			_viewContainer.addChild(MovieClipUtils.getFilledMC(stage.width,stage.height));
			addChild(_viewContainer);
		}

		
	}
}
