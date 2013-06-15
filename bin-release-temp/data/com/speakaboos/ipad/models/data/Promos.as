package com.speakaboos.ipad.models.data{		import com.speakaboos.ipad.BaseClass;
	
	public class Promos extends BaseClass	{		public var allPromos:Array;				public function Promos(data:Object = null){			if (data) setData(data);		}				public function setData(data:Object):void {			allPromos = new Array();						var i:int, n:int = data.length;			var item:Object;						for (i=n-1;i>-1;i--) {				item = data[i];				allPromos.push(item);			}			allPromos.reverse();		}				public function reset():void
		{			if (allPromos) allPromos.length = 0;			allPromos = null;
		}	}}