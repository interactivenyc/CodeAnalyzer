package com.inyc.codeanalyzer.view
{
	import com.inyc.codeanalyzer.models.ClassItem;
	import com.inyc.components.mini_accordion.MiniAccordion;
	import com.inyc.components.MCButton;
	import com.inyc.components.TextButton;
	import com.inyc.core.CoreMovieClip;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ClassView extends CoreMovieClip
	{
		private var _classItem:ClassItem;
		private var _textButtons:Array;
		
		private var _accordion:MiniAccordion;
		
		private const WIDTH:int = 180;
		private const HEIGHT:int = 120;
		
		public function ClassView(classItem:ClassItem)
		{
			super();
			
			_classItem = classItem;
			_textButtons = new Array();
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			
			_accordion = new MiniAccordion();
			_accordion.headerText = _classItem.name;
			addChild(_accordion);
			
			_accordion.addSection("imports");
			_accordion.addSection("variables");
			_accordion.addSection("functions");
			
			
			
		}
		
		private function addTextButton(textButton:TextButton):void{
			var prevTextButton:TextButton;
			prevTextButton = _textButtons[_textButtons.length-1];
			textButton.y = prevTextButton.y + prevTextButton.height;
			_textButtons.push(textButton);
			addChild(textButton);
		}
		
		
		override protected function onRemovedFromStage(e:Event):void{
			super.onRemovedFromStage(e);
		}
		
//		override protected function onMouseEvent(e:MouseEvent):void{
//			super.onMouseEvent(e);
//			switch(e.type){
//				case MouseEvent.MOUSE_DOWN:
//					startDrag();
//					break;
//				case MouseEvent.MOUSE_UP:
//					stopDrag();
//					break;
//			}
//		}
	}
}