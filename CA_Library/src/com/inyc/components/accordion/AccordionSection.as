package com.inyc.components.accordion {
	
	import com.inyc.core.CoreModel;
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class AccordionSection extends CoreMovieClip {
		
		
		public var mc:Accordion_Section;
		//public var model:CoreModel;
		public var accordion:Accordion;
		
		public var sectionName:String;
		public var sectionItems:Vector.<CoreModel>;
		public var itemContainer:MovieClip;
		public var itemMCs:Vector.<AccordionItem>;
		
		public function AccordionSection(pAccordion:Accordion, pSectionName:String, pItems:Vector.<CoreModel>){
			super();
			log("constructor pSectionName: "+pSectionName);
			
			mc = new Accordion_Section;
			mc.addEventListener(MouseEvent.CLICK, onMouseEvent);
			
			sectionName = pSectionName;
			sectionItems = pItems;
			accordion = pAccordion;
			
			mc.tf_title.label.text = sectionName;
			addChild(mc);
			
			if (sectionItems.length > 0) {
				mc.tf_count.label.text = String(sectionItems.length);
			}else{
				mc.tf_count.label.text = "0";
			}
			
			
			
		}
		
		private function createItemContainer():void{
			itemContainer = new MovieClip();
			itemContainer.y = mc.height
			itemMCs = new Vector.<AccordionItem>;
			
			for (var i:int = 0; i < sectionItems.length; i++){
				
				/**
				 * CREATE ACCORDION ITEM
				 */
				
				log("create AccordionItem: "+sectionItems[i].dataString);
				
				var ai:AccordionItem = new AccordionItem(accordion, sectionItems[i]);
				var nextSectionY:int;
				
				if (i > 0){
					var previousSection:MovieClip = itemMCs[i-1];
					nextSectionY = previousSection.y + previousSection.height;
				}else{
					nextSectionY = 0;
				}
				
				
				
				ai.y = nextSectionY;
				
				itemMCs.push(ai);
				itemContainer.addChild(ai);
				
				
				//				ai.tf.label.text = sectionItems[i] || "null";
				//				ai.y = i*(ai.height + _cellPadding);
				//				ai.indicator.addEventListener(MouseEvent.CLICK, itemClicked);
				//				sectionBody.addChild(ai);
			}
		}
		
		
		public function toggleSection():void{
			log("toggleSection");
			
			
			if (!itemContainer){
				createItemContainer();
			}
			
			if(this.contains(itemContainer)){
				removeChild(itemContainer);
			}else{
				addChild(itemContainer);
			}
			
			
		}
		
		
		protected function onMouseEvent(e:MouseEvent):void{
			//log("onMouseEvent: "+e.type+" :: "+e.currentTarget);
			
			switch(e.type){
				case MouseEvent.CLICK:
					_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.ACCORDION_SECTION_CLICKED, {accordionSection:this}));
					break
				case MouseEvent.MOUSE_DOWN:
					break;
				case MouseEvent.MOUSE_UP:
					break;
				case MouseEvent.RELEASE_OUTSIDE:
					break;
			}
			
			
		}
		
		
		
		
	}
}