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
	import com.inyc.utils.FileUtils;
	import com.inyc.utils.LoaderUtils;
	import com.inyc.utils.MovieClipUtils;
	import com.inyc.utils.TextUtil;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	//import flash.filesystem.File;
	//import flash.net.FileFilter;
	
	
	public class CodeAnalyzer extends CoreMovieClip{
		
		private var _appModel:AppModel;
		private var _appView:AppView;
		private var _currentView:IOSImageView;
		
		private var _toolbar:Toolbar;
		
		private var _viewContainer:CoreMovieClip;
		
		private var _loaderUtils:LoaderUtils;
		
		public static var SCALE_X:Number = 1;
		public static var SCALE_Y:Number = 1;
		
		private var _sourceDir:File;
		private var _sourceFiles:Vector.<File>;
		
		public function CodeAnalyzer(){
			log("CodeAnalyzer");
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
			//loadFilesFromManifest();
			browseForSourceDir();
			
		}
		
		
		override protected function onRemovedFromStage(e:Event):void{
			log("onRemovedFromStage");
			super.onRemovedFromStage(e);
		}
		
		
		
		
		/****************************************************
		 * @category Create Model
		 **************************************************/
		
		private function browseForSourceDir():void {
			log("browseForSourceDir");
			
			_sourceDir = new File();
			_sourceDir.browseForDirectory("Choose SRC Folder");
			_sourceDir.addEventListener(Event.SELECT, onSourceDirSelected); 
		}
		
		private function onSourceDirSelected(event:Event = null):void{
			_sourceDir.removeEventListener(Event.SELECT, onSourceDirSelected); 
			
			readSourceDir(_sourceDir);
		}
		
		private function useManifestToLoadFiles():void{
			_sourceDir =  File.applicationDirectory.resolvePath("data");
			readSourceDir(_sourceDir);
		}
		
		private function readSourceDir(sourceDir:File):void{ 
			log("readSourceDir: "+_sourceDir.nativePath); 
			
			_sourceFiles = new Vector.<File>
			getFilesFromDirectory(_sourceDir);
			
			for (var i:int=0; i<_sourceFiles.length; i++){
				log("_sourceFiles["+i+"] "+_sourceFiles[i]);
			}
			
			createModelAndViews(_sourceFiles);
		} 
		
		
		private function getFilesFromDirectory(file:File):void{
			log("processDirectory package.name: "+FileUtils.getFilename(file));
			
			var processFiles:Array = file.getDirectoryListing();
			var currentFile:File;
			var localFilePath:String;
			
			for (var i:int=0; i<processFiles.length; i++){
				
				currentFile = processFiles[i] as File;
				
				
				if (currentFile.nativePath.indexOf(_sourceDir.nativePath) > -1){
					//From Browse for Source Dir
					localFilePath = TextUtil.replaceChars(currentFile.nativePath, _sourceDir.nativePath, "");
				}else{
					//From Manifest
					localFilePath = currentFile.nativePath.split("data/")[1];
				}
				
				
				if (currentFile.isDirectory){
					log("i:"+i+" :: processDirectory: "+currentFile.name);
					getFilesFromDirectory(currentFile);
				}else{
					if (currentFile.name.indexOf(".as") > -1){
						log("i:"+i+" :: addFile: "+currentFile.name);
						_sourceFiles.push(currentFile);
					}
				}
				
			}
			
		}

		
		
//		private function fileDataLoaded(e:GenericDataEvent):void {
//			log("fileDataLoaded");
//			_loaderUtils.removeEventListener(LoaderUtilsEvent.FILE_LOADED, fileDataLoaded);
//			var fileData:String = e.data.file;
//			//log(_fileData);
//			
//			var fileArray:Array = fileData.split(/\n/);
//			createModelAndViews(fileArray);
//			
//		}
		
		
		
		/****************************************************
		 * @category Create View
		 **************************************************/
		
		
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
		
		
		private function createModelAndViews(fileArray:Vector.<File>):void{
			log("createModelAndViews");
			
			_appModel = new AppModel(fileArray);
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
					browseForSourceDir();
					break;
				case CodeAnalyzerEvents.LOAD_FILES_FROM_MANIFEST:
					useManifestToLoadFiles();
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
