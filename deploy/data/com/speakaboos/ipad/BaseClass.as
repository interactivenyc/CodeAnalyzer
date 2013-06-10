package com.speakaboos.ipad
{
	import com.speakaboos.ipad.utils.debug.Logger;

	public class BaseClass
	{
		protected function log(logItem:*, ...args):void{
			var category:Array = [String(this).replace("[object ", "").replace("]", "")];
			Logger.log(logItem,category,true);
			
			if (args.length > 0) {
				Logger.log(args,[category[0]+"..."],true);
			}
		}
		
	}
}