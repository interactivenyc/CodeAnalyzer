package com.inyc.core
{
	import com.adobe.utils.StringUtil;
	import com.inyc.utils.debug.Logger;
	
	import flash.events.EventDispatcher;
	

	public class CoreModel extends EventDispatcher
	{
		protected var _eventDispatcher:CoreEventDispatcher;
		
		public static const PUBLIC:String = "PUBLIC";
		public static const PRIVATE:String = "PRIVATE";
		public static const PROTECTED:String = "PROTECTED";
		
				
		public function CoreModel(){
			_eventDispatcher = CoreEventDispatcher.getInstance();
		}
		
		protected function stripChars(input:String):String{
			input = StringUtil.remove(input, "()");
			input = StringUtil.remove(input, "{");
			input = StringUtil.remove(input, "}");
			input = StringUtil.remove(input, ";");
			
			return input;
		}
		
		protected function log(logItem:*, ...args):void{
			var category:Array = [String(this).replace("[object ", "").replace("]", "")];
			Logger.log(logItem,category,true);
			
			if (args.length > 0) {
				Logger.log(args,[category[0]+"..."],true);
			}
		}
		
		
	}
}