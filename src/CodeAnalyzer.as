package 
{
	import com.inyc.core.CoreController;
	import com.inyc.core.CoreMovieClip;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class CodeAnalyzer extends CoreMovieClip{
		public function CodeAnalyzer(){
			super();
			log("CodeAnalyzer");
			readFiles();
		}
		
		private function readFiles():void{
			log("readFiles");
			var myTextLoader:URLLoader = new URLLoader();
			myTextLoader.addEventListener(Event.COMPLETE, onLoaded);
			myTextLoader.load(new URLRequest("CodeAnalyzer-app.xml"));
		}
		
		private function onLoaded(e:Event):void {
			log("onLoaded");
			log(e.target.data);
			var myArrayOfLines:Array = e.target.data.split(/\n/);
		}
	}
}