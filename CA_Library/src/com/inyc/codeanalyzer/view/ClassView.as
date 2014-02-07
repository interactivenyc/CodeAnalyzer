package com.inyc.codeanalyzer.view
{
	import com.inyc.codeanalyzer.models.ClassItem;
	import com.inyc.components.accordion.Accordion;
	import com.inyc.core.CoreMovieClip;

	import flash.events.Event;


	public class ClassView extends CoreMovieClip
	{
		private var _classItem:ClassItem;
		public function get classItem():ClassItem {return _classItem};

		private var _accordion:Accordion;

		public static const WIDTH:int = 180;
		public static const HEIGHT:int = 120;

		public function ClassView(classItem:ClassItem){
			super();
			_classItem = classItem;
			log("constructor: "+classItem.name);
			
			addAccordion();
		}

		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);

			//if (!_accordion) addAccordion();
			//addTree();
		}

		override protected function onRemovedFromStage(e:Event):void{
			super.onRemovedFromStage(e);
		}

		private function addAccordion():void{
			log("addAccordion")
			_accordion = new Accordion();
			_accordion.headerText = _classItem.name;
			addChild(_accordion);

			_accordion.addSection("imports", _classItem.imports, false);
			_accordion.addSection("variables", _classItem.variables, true);
			_accordion.addSection("functions", _classItem.functions, true);
			
		}
		
		public function expand():void{
			_accordion.expandSections();
		}



	}
}

