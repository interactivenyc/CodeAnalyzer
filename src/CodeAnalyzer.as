package 
{
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.events.LoaderUtilsEvent;
	import com.inyc.utils.LoaderUtils;
	
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
			
			_loaderUtils.addEventListener(LoaderUtilsEvent.FILE_LOADED, fileDataLoaded);
			_loaderUtils.readFile(rootPath + "/files.txt");
		}
		
//		private function readDataFile():void{
//			log("readFiles");
//			var myTextLoader:URLLoader = new URLLoader();
//			myTextLoader.addEventListener(Event.COMPLETE, onDataLoaded);
//			myTextLoader.load(new URLRequest(rootPath + "/files.txt"));
//		}
		
		private function fileDataLoaded(e:GenericDataEvent):void {
			log("fileDataLoaded");
			_loaderUtils.removeEventListener(LoaderUtilsEvent.FILE_LOADED, fileDataLoaded);
			fileData = e.data.file;
			log(fileData);
			fileArray = fileData.split(/\n/);
		}
		
	}
}