package com.inyc.components.accordion
{
	import com.inyc.components.MCButton;
	import com.inyc.core.CoreMovieClip;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Accordion extends CoreMovieClip
	{
		public var accordion:Accordion_MC;
		public var indicator:MCButton;
		public var bg:MovieClip;
		private var sections:Array = new Array();
		private var _cellPadding:int = 2;
		
		public function Accordion()
		{
			super();
			accordion = new Accordion_MC();
			
			indicator = new MCButton();
			indicator.addChild(accordion.header.indicator);
			indicator.addEventListener(MouseEvent.CLICK, onMouseEvent);
			
			bg = accordion.header.bg as MovieClip;
			bg.addEventListener(MouseEvent.CLICK, onMouseEvent);
			bg.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			bg.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			bg.addEventListener(MouseEvent.RELEASE_OUTSIDE, onMouseEvent);
			
			accordion.header.tf.mouseEnabled = false;
			accordion.header.tf.mouseChildren = false;
			
			addChild(accordion);
			addChild(indicator);
			
			cacheAsBitmap = true;
		}
		
		public function set headerText(text:String):void{
			accordion.header.tf.label.text = text;
		}
		
		public function addSection(sectionName:String, sectionItems:Array = null):void{
			var section:Accordion_Section = new Accordion_Section();
			section.tf_title.label.text = sectionName;
			
			if (sectionItems && sectionItems.length > 0) {
				section.tf_count.label.text = String(sectionItems.length);
			}else{
				section.tf_count.label.text = "0";
			}
			
			section.x = accordion.header.x;
			section.y = (accordion.header.height + _cellPadding) + (sections.length * (18 + _cellPadding));
			
			
//			var sectionBody:MovieClip = new MovieClip();
//			sectionBody.y = bg.y + bg.height;
//			section.addChild(sectionBody);
//			
//			for (var i:int = 0; i < sectionItems.length; i++){
//				var ai:Accordion_Item = new Accordion_Item();
//				ai.tf.label.text = sectionItems[i] || "null";
//				ai.y = i*(ai.height + _cellPadding);
//				sectionBody.addChild(ai);
//			}
			
			sections.push(section);
			addChild(section);
			
			accordion.bottom.y = section.y + section.height + _cellPadding;
			accordion.bg.height = accordion.bottom.y + accordion.bottom.height + 4;
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