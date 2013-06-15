package com.speakaboos.ipad.view.holders.components
{
	import com.speakaboos.ipad.models.data.HolderChildParams;
	
	import flash.display.MovieClip;

	public class SubscribeButton extends MCButton
	{
		public var best:MovieClip;
		public var textFields:MovieClip;
		
		private var _prodID:String;
		
		//private var _isPromoted:Boolean;
		
		public function SubscribeButton(pMc:MovieClip)
		{
			super(pMc);
			setupChildren(Vector.<HolderChildParams>([
				new HolderChildParams("best"),
				new HolderChildParams("textFields")
			]));
		}
		public function init(prodID:String, title:String="", price:String="", desc:String = "", isPromoted:Boolean = false):void
		{
			log("SubscribeButton constructor");
			log("productID: " + prodID);
			var intSpacer:int = 3;
			
			var titleY:int = 42;
			
			_prodID = prodID;
			
			var arrPrice:Array = price.split(".");
			if (arrPrice.length < 2) arrPrice.push("00");
			
			textFields.dollars.text = arrPrice[0];
			var currency:String = "$"
			var spaces:String = "       ";
			if (arrPrice[0].length > 1) spaces += "     ";
			textFields.cents.text = currency + spaces + arrPrice[1];
			textFields.title.text = title;
			textFields.percent.text = desc;
			
			//if(prodID != "com.speakaboos.ipad.subc")
			best.visible = isPromoted;
			textFields.extra.visible = isPromoted;;
		}
		
		public function getProductID():String{
			return _prodID;
		}
	}
}