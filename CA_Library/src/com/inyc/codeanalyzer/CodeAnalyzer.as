package com.inyc.codeanalyzer  
{
	import com.inyc.codeanalyzer.events.CodeAnalyzerEvents;
	import com.inyc.codeanalyzer.models.AppModel;
	import com.inyc.codeanalyzer.view.AppView;
	import com.inyc.codeanalyzer.view.MenuView;
	import com.inyc.components.IOSImageView;
	import com.inyc.components.Toolbar;
	import com.inyc.core.Config;
	import com.inyc.core.CoreEventDispatcher;
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.events.LoaderUtilsEvent;
	import com.inyc.utils.LoaderUtils;
	import com.inyc.utils.MovieClipUtils;
	
	import flash.events.Event;
	//import flash.filesystem.File;
	//import flash.net.FileFilter;
	
	
	public class CodeAnalyzer extends CoreMovieClip{
		
		private var _appModel:AppModel;
		private var _appView:AppView;
		private var _currentView:IOSImageView;
		
		private var _toolbar:Toolbar;
		
		private var _fileData:String;
		private var _fileArray:Array;
		
		private var _viewContainer:CoreMovieClip;
		
		private var _loaderUtils:LoaderUtils;
		
		public static var SCALE_X:Number = 1;
		public static var SCALE_Y:Number = 1;
		
		//public var fileToOpen:File = File.documentsDirectory;
		
		public function CodeAnalyzer(){
			log("CodeAnalyzer DESKTOP");
			super();
		}
		
		override protected function init():void{
			super.init();
			log("init");
			_eventDispatcher = CoreEventDispatcher.getInstance();
			_eventDispatcher.addEventListener(CodeAnalyzerEvents.SHOW_FILE_BROWSER, receiveEvent);
			_eventDispatcher.addEventListener(CodeAnalyzerEvents.LOAD_FILES_FROM_MANIFEST, receiveEvent);
			_eventDispatcher.addEventListener(AppEvents.FILE_LOADED, receiveEvent);
			_eventDispatcher.addEventListener(AppEvents.ALL_FILES_LOADED, receiveEvent);
			
			_eventDispatcher.addEventListener(AppEvents.TOOLBAR_SELECT, receiveEvent);
			_eventDispatcher.addEventListener(AppEvents.TOOLBAR_MOVE, receiveEvent);
			_eventDispatcher.addEventListener(AppEvents.TOOLBAR_ZOOM_IN, receiveEvent);
			_eventDispatcher.addEventListener(AppEvents.TOOLBAR_ZOOM_OUT, receiveEvent);
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
		
//		private function showFileBrowser():void {
//			log("showFileBrowser");
//			
//			selectTextFile(fileToOpen);
//		}
//		
//		private function selectTextFile(root:File):void { 
//			var txtFilter:FileFilter = new FileFilter("Text", "*.as;*.css;*.html;*.txt;*.xml"); 
//			root.browseForOpen("Open", [txtFilter]); 
//			root.addEventListener(Event.SELECT, fileSelected); 
//		} 
//		
//		private function fileSelected(event:Event):void{ 
//			trace(fileToOpen.nativePath); 
//
//			_fileArray = new Array();
//			_fileArray.push(fileToOpen.nativePath);
//			
//			_appModel = new AppModel(_fileArray);
//			_appView = new AppView(_appModel);
//			setView(_appView);
//			
//		} 
		
		
		private function loadFilesFromManifest():void {
			log("loadFilesFromManifest");
			_loaderUtils = new LoaderUtils();
			_loaderUtils.addEventListener(LoaderUtilsEvent.FILE_LOADED, fileDataLoaded);
			
			var manifestURL:String = Config.ROOT_PATH + "/files.txt";
			log("manifestURL: "+manifestURL);
			
			_loaderUtils.readFile(manifestURL);
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
			_viewContainer.addChild(MovieClipUtils.getFilledMC(stage.width,stage.height, 0x996666));
			addChild(_viewContainer);
			
			
		}
		
		
		private function receiveEvent(e:GenericDataEvent):void{
			log("receiveEvent e.type: "+e.type);
			switch(e.type){
				case CodeAnalyzerEvents.SHOW_FILE_BROWSER:
					//showFileBrowser();
					break;
				case CodeAnalyzerEvents.LOAD_FILES_FROM_MANIFEST:
					loadFilesFromManifest();
					break;
				case AppEvents.FILE_LOADED:
					break;
				case AppEvents.ALL_FILES_LOADED:
					
					_toolbar = new Toolbar();
					addChild(_toolbar);
					
					break;
				case AppEvents.TOOLBAR_SELECT:					
					break;
				case AppEvents.TOOLBAR_MOVE:					
					break;
				case AppEvents.TOOLBAR_ZOOM_IN:		
					_currentView.scaleX = _currentView.scaleY = (_currentView.scaleX * 1.25);
					break;
				case AppEvents.TOOLBAR_ZOOM_OUT:	
					_currentView.scaleX = _currentView.scaleY = (_currentView.scaleX / 1.25);
					break;
			}
			
		}

		
	}
}
