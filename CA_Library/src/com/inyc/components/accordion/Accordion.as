package com.inyc.components.accordion
{
	import com.inyc.components.MCButton;
	import com.inyc.core.CoreModel;
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.utils.MovieClipUtils;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Accordion extends CoreMovieClip
	{
		public var mc:Accordion_MC;
		public var indicator:MCButton;
		public var bg:Square_MC;
		private var sections:Vector.<AccordionSection> = new Vector.<AccordionSection>;
		private var _cellPadding:int = 0;
		
		public function Accordion(){
			super();
			
			mc = new Accordion_MC();
			
			log("new accordion name: "+name);
			
			indicator = new MCButton();
			indicator.addChild(mc.header.indicator);
			indicator.addEventListener(MouseEvent.CLICK, onMouseEvent);
			
			_eventDispatcher.addEventListener(AppEvents.ACCORDION_ITEM_CLICKED, receiveAccordionEvent);
			_eventDispatcher.addEventListener(AppEvents.ACCORDION_SECTION_CLICKED, receiveAccordionEvent);
			
			bg = mc.header.bg as Square_MC;
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
		
		public function addSection(sectionName:String, sectionItems:Vector.<CoreModel>, expanded:Boolean):void{
			log("addSection: "+sectionName);
			var section:AccordionSection = new AccordionSection(this, sectionName, sectionItems);			
			
			
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
			if (expanded) section.toggleSection();
			
			setBottomMCs();
		}
		
		protected function onMouseEvent(e:MouseEvent):void{
			//log("onMouseEvent: "+e.type+" :: "+e.currentTarget);
			
			switch(e.type){
				case MouseEvent.CLICK:
					if (e.currentTarget == indicator){
						log("indicator clicked - COPY Class Diagram to Clipboard");
						var bmpData:BitmapData = MovieClipUtils.getBitmapDataFromMC(this);
						Clipboard.generalClipboard.setData(ClipboardFormats.BITMAP_FORMAT, bmpData);
					}
					break
				case MouseEvent.MOUSE_DOWN:
					log("start dragging: MOUSE_DOWN name: "+name);
					startDrag(false);
					break;
				case MouseEvent.MOUSE_UP:
					log("stop dragging: MOUSE_UP name: "+name);
					stopDrag();
					break;
				case MouseEvent.RELEASE_OUTSIDE:
					log("stop dragging: RELEASE_OUTSIDE name: "+name);
					stopDrag();
					break;
			}
		}
		
		protected function receiveAccordionEvent(e:GenericDataEvent):void{
			//every accordion receives this event from every section
			//filter to make sure event belongs to this accordion
			//or consider not using _eventDispatcher for these events
			var section:AccordionSection = e.data.accordionSection;
			if(section.accordion != this) return;
				
			log("receiveAccordionEvent: "+e.type);
			
			switch(e.type){
				case AppEvents.ACCORDION_ITEM_CLICKED:
					break;
				case AppEvents.ACCORDION_SECTION_CLICKED:
					sectionClicked(section);
					break;
			}
		}
		
//		private function itemClicked(e:MouseEvent):void{
//			log(e.target + ", " +e.currentTarget.parent);
//			var ai:Accordion_Item = e.currentTarget.parent as Accordion_Item;
//			log(ai.tf.label.text);
//		}
		
		private function sectionClicked(section:AccordionSection):void{
			
			var sectionIndex:int = sections.indexOf(section);
			
			log("sectionClicked sectionIndex: "+sectionIndex);
			section.toggleSection();
			
			for (var i:int=sectionIndex + 1; i<sections.length; i++){
				if (i==0) {
					sections[i].y = mc.header.height;
				}else{
					sections[i].y = sections[i-1].y + sections[i-1].height;
				}
			}
			
			setBottomMCs();
		}
		
		private function setBottomMCs():void{
			var section:AccordionSection = sections[sections.length-1];
			mc.bottom.y = section.y + section.height + _cellPadding - 2;
			mc.bg.height = mc.bottom.y + mc.bottom.height;
			mc.bottom.visible = false;
			
		}
		
		public function expandSections():void{
			//INITIAL STATE - EXPAND VARS AND FUNCTIONS
			sections[1].toggleSection();
			sections[2].toggleSection();
		}
		
		
	}
}