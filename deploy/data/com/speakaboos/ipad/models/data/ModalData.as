package com.speakaboos.ipad.models.data
{
	public class ModalData
	{
		public var type:Class;
		public var frame: int;
		public var title: String;
		public var texts: Array;
		public var labels:Array;
		public var bttns: Array;
		public var menuBttns: Array;
		public var customObject: Object;
		
		function ModalData() {};

		public function setData(args:Array):ModalData {
			trace("[ ModalData ] * setData: "+args[0]);
			type = args[0] as Class;
			if (type === ModalsInfo.MESSAGE_MODAL_TYPE) {
				return setDataRest(0, args[1], args[2], null, args[3]);
			} else {
				return setDataRest(args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
			}
		}
		private function setDataRest(pFrame:int = 0, pTitle:String = "", pTexts:Array = null, pLabels:Array = null, pBttns:Array = null, pMenuBttns:Array = null, pCustomObject:Object = null):ModalData {
			frame = pFrame;
			title = pTitle;
			texts = pTexts || [];
			labels = pLabels || [];
			bttns = pBttns || [];
			menuBttns = pMenuBttns || [];
			customObject = pCustomObject;
			if (frame < 1) frame = bttns.length;
			return this;
		}
		public function reset():void {
			type = null;
			frame = 0;
			title = null;
			texts = null;
			labels = null;
			bttns = null;
			menuBttns = null;
			customObject = null;
		}
	}
}