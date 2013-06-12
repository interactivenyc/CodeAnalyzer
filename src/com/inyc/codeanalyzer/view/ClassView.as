package com.inyc.codeanalyzer.view
{
	import com.inyc.codeanalyzer.models.ClassItem;
	import com.inyc.core.CoreMovieClip;
	
	import flash.events.Event;
	
	public class ClassView extends CoreMovieClip
	{
		private var _classItem:ClassItem;
		
		public function ClassView(classItem:ClassItem)
		{
			super();
			
			_classItem = classItem;
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
		}
		
		
		override protected function onRemovedFromStage(e:Event):void{
			super.onRemovedFromStage(e);
		}
	}
}