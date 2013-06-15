package com.speakaboos.ipad.view
{
	import com.speakaboos.ipad.models.data.HolderChildParams;
	import com.speakaboos.ipad.view.holders.CoreMovieClipHolder;
	import com.speakaboos.ipad.view.holders.components.MCAlphaButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class CharacterWindows extends CoreMovieClipHolder
	{
		public var window_01:MCAlphaButton;
		public var window_02:MCAlphaButton;
		public var window_03:MCAlphaButton;
		public var window_04:MCAlphaButton;
		public var window_05:MCAlphaButton;
		
		public function CharacterWindows(pMc:MovieClip)
		{	super(pMc);
			setupChildren(Vector.<HolderChildParams>([
				new HolderChildParams("window_01", MCAlphaButton, onWindowClicked),
				new HolderChildParams("window_02", MCAlphaButton, onWindowClicked),
				new HolderChildParams("window_03", MCAlphaButton, onWindowClicked),
				new HolderChildParams("window_04", MCAlphaButton, onWindowClicked),
				new HolderChildParams("window_05", MCAlphaButton, onWindowClicked)
			]));
		}
		
		private function onWindowClicked(pMc:MovieClip):void{
			log("onWindowClicked");
		}
		
	}
}
