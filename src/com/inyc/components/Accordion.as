package com.inyc.components
{
	import com.inyc.core.CoreMovieClip;
	
	import flash.events.MouseEvent;
	
	public class Accordion extends CoreMovieClip
	{
		public var accordion:ACMini_MC;
		public var indicator:MCButton;
		public var bg:MCButton;
		
		
		public function Accordion()
		{
			super();
			accordion = new ACMini_MC();
			//accordion.bottom.y = accordion.top.y + accordion.top.height;
			
			indicator = accordion.top.indicator as MCButton;
			indicator.addEventListener(MouseEvent.CLICK, onMouseEvent);
			
			bg = accordion.top.bg as MCButton;
			bg.addEventListener(MouseEvent.CLICK, onMouseEvent);
			bg.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			bg.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			bg.addEventListener(MouseEvent.RELEASE_OUTSIDE, onMouseEvent);
			
			accordion.top.tf.mouseEnabled = false;
			accordion.top.tf.mouseChildren = false;
			
			addChild(accordion);
		}
		
		public function set headerText(text:String):void{
			accordion.top.tf.label.text = text;
		}
		
		protected function onMouseEvent(e:MouseEvent):void{
			//log("onMouseEvent: "+e.type+" :: "+e.currentTarget);
			
			switch(e.type){
				case MouseEvent.CLICK:
					if (e.currentTarget == indicator){
						log("indicator clicked");
					}
					break
				case MouseEvent.MOUSE_DOWN:
					startDrag();
					break;
				case MouseEvent.MOUSE_UP:
					stopDrag();
					break;
				case MouseEvent.RELEASE_OUTSIDE:
					stopDrag();
					break;
			}
			
			
		}
		
		
	}
}