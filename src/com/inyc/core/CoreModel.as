package com.inyc.core
{
	import com.inyc.utils.debug.Logger;

	public class CoreModel
	{
		public static const PUBLIC:String = "PUBLIC";
		public static const PRIVATE:String = "PRIVATE";
		public static const PROTECTED:String = "PROTECTED";
		
		
		public function CoreModel(){
			
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