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
			//accordion.bottom.y = accordion.header.y + accordion.header.height;
			
			indicator = accordion.header.indicator as MCButton;
			indicator.addEventListener(MouseEvent.CLICK, onMouseEvent);
			
			bg = accordion.header.bg as MovieClip;
			bg.addEventListener(MouseEvent.CLICK, onMouseEvent);
			bg.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			bg.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			bg.addEventListener(MouseEvent.RELEASE_OUTSIDE, onMouseEvent);
			
			accordion.header.tf.mouseEnabled = false;
			accordion.header.tf.mouseChildren = false;
			
			addChild(accordion);
		}
		
		public function set headerText(text:String):void{
			accordion.header.tf.label.text = text;
		}
		
		public function addSection(sectionName:String):void{
			var section:Accordion_Section = new Accordion_Section();
			section.tf.label.text = sectionName;
			
			section.x = accordion.header.x;
			section.y = (accordion.header.height + _cellPadding) + (sections.length * (18 + _cellPadding));
			
			log(sectionName + ".y: "+ section.y);
			
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