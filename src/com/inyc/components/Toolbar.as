package com.inyc.components
{
	import flash.events.MouseEvent;
	

	public class Toolbar extends BasicButtonPanel
	{
		public var toolbar:Toolbar_MC;
		public var btn_select:BasicButton;
		public var btn_hand:BasicButton;
		public var btn_zoom_in:BasicButton;
		public var btn_zoom_out:BasicButton;
		
		public function Toolbar(){
			toolbar = new Toolbar_MC;
			addChild(toolbar);
			toolbar.x = toolbar.y = 10;
			
			
			
			btn_select = new BasicButton(new ButtonPanel_Button());
			toolbar.select.addChild(btn_select);
			addButton(btn_select);
			
			
			btn_hand = new BasicButton(new ButtonPanel_Button());
			toolbar.hand.addChild(btn_hand);
			addButton(btn_hand);
			
			btn_zoom_in = new BasicButton(new ButtonPanel_Button());
			toolbar.zoom_in.addChild(btn_zoom_in);
			addButton(btn_zoom_in);
			
			btn_zoom_out = new BasicButton(new ButtonPanel_Button());
			toolbar.zoom_out.addChild(btn_zoom_out);
			addButton(btn_zoom_out);
			
//			var buttons:Array = new Array();
//			var button:BasicButton;
//			//button
//			btn_select = new BasicButton();
//			var classDef:Class = BasicButton;
//			classDef.prototype = btn_select;
//			addChild(btn_select);
			
		}
		
		override protected function onMouseEvent(e:MouseEvent):void{
			super.onMouseEvent(e);
			if (e.type == MouseEvent.CLICK){
				switch(e.currentTarget){
					case btn_select:
						break;
					case btn_hand:
						break;
					case btn_zoom_in:
						log("zoom_in");
						break;
					case btn_zoom_out:
						break;
					
				}
			}
			
		}
		
		
	}
}