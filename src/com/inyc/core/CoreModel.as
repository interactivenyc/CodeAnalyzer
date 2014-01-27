package com.inyc.core
{
	import com.adobe.utils.StringUtil;
	import com.inyc.utils.TextUtil;
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
			//input = StringUtil.remove(input, "()");
			input = StringUtil.remove(input, "{");
			input = StringUtil.remove(input, "}");
			input = StringUtil.remove(input, ";");
			input = TextUtil.trim(input);
			
			return input;
		}
		
		protected function prefixSymbols(declaration:String, name:String):String{
			var prefix:String = "";
			
			if (declaration.indexOf("final") > -1){
				prefix = "F" + prefix
			}
			if (declaration.indexOf("static") > -1){
				prefix = "S" + prefix
			}
			if (declaration.indexOf("override") > -1){
				prefix = "O" + prefix
			}
			
			if (declaration.indexOf("public") > -1){
				prefix = "+" + prefix
			}else if (declaration.indexOf("private") > -1){
				prefix = "-" + prefix
			}else if (declaration.indexOf("protected") > -1){
				prefix = "*" + prefix
			}
			
			return "["+prefix+"] " +name;
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