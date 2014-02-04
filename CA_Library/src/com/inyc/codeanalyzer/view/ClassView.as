package com.inyc.codeanalyzer.view
{
	import com.inyc.codeanalyzer.models.ClassItem;
	import com.inyc.components.accordion.Accordion;
	import com.inyc.core.CoreMovieClip;
	
	import flash.events.Event;
	
	
	public class ClassView extends CoreMovieClip
	{
		private var _classItem:ClassItem;
		private var _accordion:Accordion;
		
		public static const WIDTH:int = 180;
		public static const HEIGHT:int = 120;
		
		public function ClassView(classItem:ClassItem){
			super();
			_classItem = classItem;
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			
			addAccordion();
			//addTree();
		}
		
		override protected function onRemovedFromStage(e:Event):void{
			super.onRemovedFromStage(e);
		}
		
		private function addAccordion():void{
			_accordion = new Accordion();
			_accordion.headerText = _classItem.name;
			addChild(_accordion);
			
			//_accordion.addSection("imports", _classItem.imports);
			_accordion.addSection("variables", _classItem.variables);
			_accordion.addSection("functions", _classItem.functions);

		}
		
	}
}