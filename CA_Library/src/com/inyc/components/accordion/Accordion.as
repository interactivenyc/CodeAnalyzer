package com.inyc.components.accordion
{
	import com.inyc.components.MCButton;
	import com.inyc.core.CoreModel;
	import com.inyc.core.CoreMovieClip;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Accordion extends CoreMovieClip
	{
		public var mc:Accordion_MC;
		public var indicator:MCButton;
		public var bg:MovieClip;
		private var sections:Vector.<AccordionSection> = new Vector.<AccordionSection>;
		private var _cellPadding:int = 0;
		
		public function Accordion()
		{
			super();
			mc = new Accordion_MC();
			
			indicator = new MCButton();
			indicator.addChild(mc.header.indicator);
			indicator.addEventListener(MouseEvent.CLICK, onMouseEvent);
			
			bg = mc.header.bg as MovieClip;
			bg.addEventListener(MouseEvent.CLICK, onMouseEvent);
			bg.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			bg.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			bg.addEventListener(MouseEvent.RELEASE_OUTSIDE, onMouseEvent);
			
			mc.header.tf.mouseEnabled = false;
			mc.header.tf.mouseChildren = false;
			
			addChild(mc);
			addChild(indicator);
			
			cacheAsBitmap = true;
		}
		
		public function set headerText(text:String):void{
			mc.header.tf.label.text = text;
		}
		
		public function addSection(sectionName:String, sectionItems:Vector.<CoreModel>):void{
			log("addSection: "+sectionName);
			var section:AccordionSection = new AccordionSection(sectionName, sectionItems);
			var nextSectionY:int;
			
			if (sections.length > 0){
				var previousSection:AccordionSection = sections[sections.length-1];
				nextSectionY = nextSectionY + previousSection.y + previousSection.height;
			}else{
				nextSectionY = mc.header.height - 2;
			}
			
			section.x = mc.header.x;
			section.y = nextSectionY;
			
			sections.push(section);
			addChild(section);
			
			mc.bottom.y = section.y + section.height + _cellPadding;
			mc.bg.height = mc.bottom.y + mc.bottom.height + 4;
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
		
		protected function itemClicked(e:MouseEvent):void{
			log(e.target + ", " +e.currentTarget.parent);
			var ai:Accordion_Item = e.currentTarget.parent as Accordion_Item;
			log(ai.tf.label.text);
		}
		
		
	}
}