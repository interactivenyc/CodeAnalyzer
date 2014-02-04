package com.inyc.components.accordion {
	
	import com.inyc.core.CoreModel;
	import com.inyc.core.CoreMovieClip;
	
	import flash.display.MovieClip;
	
	public class AccordionSection extends CoreMovieClip {
		
		public var mc:Accordion_Section;		
		public var sectionName:String;
		public var sectionItems:Vector.<CoreModel>;
		public var itemContainer:MovieClip;
		public var itemMCs:Vector.<AccordionItem>;
		
		public function AccordionSection(pSectionName:String, pItems:Vector.<CoreModel>){
			super();
			log("constructor pSectionName: "+pSectionName);
			
			mc = new Accordion_Section;
			
			sectionName = pSectionName;
			sectionItems = pItems;
			
			mc.tf_title.label.text = sectionName;
			addChild(mc);
			
			if (sectionItems.length > 0) {
				mc.tf_count.label.text = String(sectionItems.length);
			}else{
				mc.tf_count.label.text = "0";
			}
			
			itemContainer = new MovieClip();
			itemContainer.y = mc.height
			addChild(itemContainer)
			
			itemMCs = new Vector.<AccordionItem>;
			
			
			for (var i:int = 0; i < sectionItems.length; i++){
				
				/**
				 * CREATE ACCORDION ITEM
				 */
				
				log("create AccordionItem: "+sectionItems[i].dataString);
				
				var ai:AccordionItem = new AccordionItem(sectionItems[i]);
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
		
	}
}