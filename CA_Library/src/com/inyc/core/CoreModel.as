package com.inyc.core
{
	import com.inyc.utils.debug.Logger;
	import com.inyc.utils.debug.TraceObject;
	
	import flash.events.EventDispatcher;
	

	public class CoreModel extends EventDispatcher{
		public var name:String;
		
		protected var _eventDispatcher:CoreEventDispatcher;
		protected var _data:Object;
		protected var _dataString:String;
		
		public function CoreModel(){
			_eventDispatcher = CoreEventDispatcher.getInstance();
		}
		
		public function get dataString():String{
			var dataString:String = "";
			
			if (_dataString != null) return _dataString;
			if (_data != null) return TraceObject.DUMP(_data);
			
			return dataString;
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