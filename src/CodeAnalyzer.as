package 
{
	import com.inyc.codeanalyzer.models.AppModel;
	import com.inyc.core.Config;
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.events.LoaderUtilsEvent;
	import com.inyc.utils.LoaderUtils;
	
	public class CodeAnalyzer extends CoreMovieClip{
		
		private var fileData:String;
		private var fileArray:Array;
		private var fileObject:Object;
		private var appModel:AppModel;
		
		private var _loaderUtils:LoaderUtils;
		
		public function CodeAnalyzer(){
			super();
			log("CodeAnalyzer");
			
			_loaderUtils = new LoaderUtils();
			_loaderUtils.addEventListener(LoaderUtilsEvent.FILE_LOADED, fileDataLoaded);
			_loaderUtils.readFile(Config.ROOT_PATH + "/files.txt");
		}
		
		
		private function fileDataLoaded(e:GenericDataEvent):void {
			log("fileDataLoaded");
			_loaderUtils.removeEventListener(LoaderUtilsEvent.FILE_LOADED, fileDataLoaded);
			fileData = e.data.file;
			//log(fileData);
			fileArray = fileData.split(/\n/);
			appModel = new AppModel(fileArray);
		}
		
	}
}
