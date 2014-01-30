package com.inyc.codeanalyzer.view
{
	import com.inyc.codeanalyzer.events.CodeAnalyzerEvents;
	import com.inyc.components.IOSImageView;
	import com.inyc.components.TextButton;
	import com.inyc.events.GenericDataEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class MenuView extends IOSImageView
	{
		public function MenuView(){
			
		}
		
		override protected function init():void {
			super.init();
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			setupView();
		}
		
		
		override protected function onRemovedFromStage(e:Event):void{
			super.onRemovedFromStage(e);
		}
		
		private function setupView():void{
			var btn:TextButton;
			
			btn = new TextButton(CodeAnalyzerEvents.SHOW_FILE_BROWSER);
			btn.eventString = CodeAnalyzerEvents.SHOW_FILE_BROWSER;
			btn.addEventListener(MouseEvent.CLICK, onMouseEvent);
			btn.x = 10;
			btn.y = 10;
			
			addChild(btn);
			
			btn = new TextButton(CodeAnalyzerEvents.LOAD_FILES_FROM_MANIFEST);
			btn.eventString = CodeAnalyzerEvents.LOAD_FILES_FROM_MANIFEST;
			btn.addEventListener(MouseEvent.CLICK, onMouseEvent);
			btn.x = 10;
			btn.y = 50;
			
			addChild(btn);
			
		}
		
		private function onMouseEvent(e:MouseEvent):void{
			var btn:TextButton = e.currentTarget as TextButton;
			log("onMouseEvent btn.eventString: "+btn.eventString);
			switch(btn.eventString){
				case CodeAnalyzerEvents.SHOW_FILE_BROWSER:
					_eventDispatcher.dispatchEvent(new GenericDataEvent(CodeAnalyzerEvents.SHOW_FILE_BROWSER));
					break;
				case CodeAnalyzerEvents.LOAD_FILES_FROM_MANIFEST:
					_eventDispatcher.dispatchEvent(new GenericDataEvent(CodeAnalyzerEvents.LOAD_FILES_FROM_MANIFEST));
					break;
				
			}
		}
		
		
	}
}