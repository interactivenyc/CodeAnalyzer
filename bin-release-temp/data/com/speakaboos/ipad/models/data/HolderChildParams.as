package com.speakaboos.ipad.models.data
{
	import com.speakaboos.ipad.events.GenericDataEvent;
	
	public class HolderChildParams
	{
		public var name:String;
		public var clss:Class;
		public var info:Object;
		public var clickFunc:Function;
		public var clickEvent:GenericDataEvent;
		
		public function HolderChildParams(pName:String, pClassAndInfo:Object = null, pClickFunction:Function = null, pClickEvent:GenericDataEvent = null) {
			setData(pName, pClassAndInfo, pClickFunction, pClickEvent);
		}
		
		public function setData(pName:String, pClassAndInfo:Object = null, pClickFunction:Function = null, pClickEvent:GenericDataEvent = null):void {
			name = pName;
			if (pClassAndInfo) {
				if (pClassAndInfo.hasOwnProperty("clss")) {
					clss = pClassAndInfo.clss;
					info = pClassAndInfo;
					delete info.clss;
				} else {
					info = null;
					clss = pClassAndInfo as Class;
				}
			} else {
				info = null;
				clss = null;
			}
			clickFunc = pClickFunction;
			clickEvent = pClickEvent;
		}
		
		public function toString():String { //just for debug
			return "name: "+name+", clickEvent type "+((clickEvent) ? clickEvent.type : clickFunc)+", class "+clss+", info:"+info;
		}
		
		public function reset():void {
			name = null;
			clss = null;
			info = null;
			clickFunc = null;
			clickEvent = null;
		}
		
	}
}