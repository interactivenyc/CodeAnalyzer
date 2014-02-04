package com.inyc.components.accordion {
	
	import com.inyc.core.CoreModel;
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	
	import flash.events.MouseEvent;
	
	public class AccordionItem extends CoreMovieClip{
		
		public var mc:Accordion_Item;
		public var model:CoreModel;
		public var accordion:Accordion;
		
		public function AccordionItem(pAccordion:Accordion, pModel:CoreModel){
			super();
			log("AccordionItem: "+pModel.dataString);
			
			mc = new Accordion_Item();
			model = pModel;
			accordion = pAccordion;
			
			mc.tf.label.text = model.name;
			mc.indicator.addEventListener(MouseEvent.CLICK, onMouseEvent);
			
			addChild(mc);
		}
		
		
		
		protected function onMouseEvent(e:MouseEvent):void{
			//log("onMouseEvent: "+e.type+" :: "+e.currentTarget);
			
			switch(e.type){
				case MouseEvent.CLICK:
					_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.ACCORDION_ITEM_CLICKED, {accordionItem:this}));
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