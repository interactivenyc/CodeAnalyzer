package com.inyc.codeanalyzer.view
{
	import com.inyc.codeanalyzer.models.ClassItem;
	import com.inyc.components.MCButton;
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.utils.MovieClipUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ClassView extends MCButton
	{
		private var _classItem:ClassItem;
		
		public function ClassView(classItem:ClassItem)
		{
			super();
			
			_classItem = classItem;
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			var bg:MovieClip = MovieClipUtils.getFilledMC(64,48,0x000000);
			bg.x += 1;
			bg.y += 1;
			addChild(bg);
			addChild(MovieClipUtils.getFilledMC(64,48,0xff6600));
		}
		
		
		override protected function onRemovedFromStage(e:Event):void{
			super.onRemovedFromStage(e);
		}
		
		override protected function onMouseEvent(e:MouseEvent):void{
			super.onMouseEvent(e);
			switch(e.type){
				case MouseEvent.MOUSE_DOWN:
					startDrag();
					break;
				case MouseEvent.MOUSE_UP:
					stopDrag();
					break;
			}
		}
	}
}