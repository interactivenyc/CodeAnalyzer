package com.inyc.codeanalyzer
{
	import com.inyc.core.CoreController;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class AppController extends CoreController
	{
		public function AppController(){
			super();
			log("AppController");
		}
		
		private function readFiles():void{
			var myTextLoader:URLLoader = new URLLoader();
			myTextLoader.addEventListener(Event.COMPLETE, onLoaded);
			myTextLoader.load(new URLRequest("myText.txt"));
		}
		
		private function onLoaded(e:Event):void {
			var myArrayOfLines:Array = e.target.data.split(/\n/);
		}
	}
}