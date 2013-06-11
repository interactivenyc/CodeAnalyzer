package 
{
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.events.LoaderUtilsEvent;
	import com.inyc.utils.LoaderUtils;
	
	import flash.events.Event;
	
	public class CodeAnalyzer extends CoreMovieClip{
		
		private var fileData:String;
		private var fileArray:Array;
		private var fileObject:Object;
		private var rootPath:String = "./data";
		
		private var _loaderUtils:LoaderUtils;
		
		public function CodeAnalyzer(){
			super();
			log("CodeAnalyzer");
			
			_loaderUtils = new LoaderUtils();
			_loaderUtils.addEventListener(LoaderUtilsEvent.FILE_LOADED, fileIndexLoaded);			_loaderUtils.readFile(rootPath + "/files.txt");
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			_loaderUtils.addEventListener(LoaderUtilsEvent.FILE_LOADED, fileLoaded);
		}
		
		
		override protected function onRemovedFromStage(e:Event):void{
			super.onAddedToStage(e);
			_loaderUtils.removeEventListener(LoaderUtilsEvent.FILE_LOADED, fileLoaded);

		}
		
		private function fileIndexLoaded(e:GenericDataEvent):void {
			log("fileIndexLoaded");
			_loaderUtils.removeEventListener(LoaderUtilsEvent.FILE_LOADED, fileIndexLoaded);
			
			fileData = e.data.file;
			log(fileData);
			fileArray = fileData.split(/\n/);
		}
		
		private function fileLoaded(e:GenericDataEvent):void {
			log("fileDataLoaded");
			var fileContents:String = e.data.file;
			processClassFile(fileContents);
			loadNextFile(fileArray.shift());
		}
		
		private function processClassFile(classFile:String):void{
			log("processClassFile: "+classFile);
		}
		
		private function loadNextFile(filePath:String):void{
			log("loadNextFile: "+filePath);
		}
		
		private function allFilesLoaded(filePath:String):void{
			log("allFilesLoaded: "+filePath);
		}
		
	}
}