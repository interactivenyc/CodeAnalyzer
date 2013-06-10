package 
{
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.AppEvents;
	import com.inyc.events.CoreEventDispatcher;
	import com.inyc.events.GenericDataEvent;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class CodeAnalyzer extends CoreMovieClip{
		
		private var fileData:String;
		private var fileArray:Array;
		private var fileObject:Object;
		private var rootPath:String = "./data";
		
		public function CodeAnalyzer(){
			super();
			log("CodeAnalyzer");
			
			_eventDispatcher.addEventListener(AppEvents.FILE_LOADED, fileDataLoaded);
			readFile("/files.txt");
		}
		
//		private function readDataFile():void{
//			log("readFiles");
//			var myTextLoader:URLLoader = new URLLoader();
//			myTextLoader.addEventListener(Event.COMPLETE, onDataLoaded);
//			myTextLoader.load(new URLRequest(rootPath + "/files.txt"));
//		}
		
		private function fileDataLoaded(e:GenericDataEvent):void {
			log("fileDataLoaded");
			_eventDispatcher.removeEventListener(AppEvents.FILE_LOADED, fileDataLoaded);
			fileData = e.data.file;
			//log(fileData);
			fileArray = fileData.split(/\n/);
		}
		
		private function readFile(filePath:String):void{
			log("readFiles");
			var myTextLoader:URLLoader = new URLLoader();
			myTextLoader.addEventListener(Event.COMPLETE, onFileLoaded);
			myTextLoader.load(new URLRequest(rootPath + filePath));
		}
		
		private function onFileLoaded(e:Event):void {
			log("onFileLoaded");
			fileData = e.target.data;
			log(fileData);
			fileArray = fileData.split(/\n/);
			CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(AppEvents.FILE_LOADED, {file:fileData}));
		}
		
		
		
		
	}
}