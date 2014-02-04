package com.inyc.components.accordion {
	
	import com.inyc.core.CoreModel;
	import com.inyc.core.CoreMovieClip;
	
	public class AccordionItem extends CoreMovieClip{
		
		public var mc:Accordion_Item;
		public var model:CoreModel;
		
		public function AccordionItem(model:CoreModel){
			super();
			log("AccordionItem: "+model.dataString);
			
			mc = new Accordion_Item();
			model = model;
			
			
			addChild(mc);
		}
	}
}