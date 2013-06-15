﻿package com.speakaboos.ipad.models.data{	import com.speakaboos.ipad.view.holders.CoreDisplayObjectHolder;		import flash.display.DisplayObject;	import com.speakaboos.ipad.events.GenericDataEvent;	public class HolderChildInfo	{		public var holder:CoreDisplayObjectHolder;		public var clickFunc:Function;		public var clickEvent:GenericDataEvent;		public var child:DisplayObject;				public function HolderChildInfo(pHolder:CoreDisplayObjectHolder, pClickFunction:Function, pClickEvent:GenericDataEvent, pChild:DisplayObject) {			holder = pHolder;			clickFunc = pClickFunction;			clickEvent = pClickEvent;			child = pChild;		}				public function toString():String { //just for debug			return "holder: "+holder+", clickEvent type "+((clickEvent) ? clickEvent.type : clickFunc)+", child.name "+(child?child.name:"null");		}				public function reset():void {			child = null;			if (clickEvent) clickEvent.reset();			clickEvent = null;			clickFunc = null;			holder = null;		}	}}