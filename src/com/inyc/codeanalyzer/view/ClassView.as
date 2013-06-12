package com.inyc.codeanalyzer.view
{
	import com.inyc.codeanalyzer.models.ClassItem;
	import com.inyc.codeanalyzer.models.ImportItem;
	import com.inyc.components.MCButton;
	import com.inyc.components.TextButton;
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.utils.MovieClipUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	public class ClassView extends MCButton
	{
		private var _classItem:ClassItem;
		private var _textButtons:Array;
		
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
			
			var shadow:MovieClip = MovieClipUtils.getFilledMC(WIDTH,HEIGHT,0x000000);
			shadow.alpha = .7;
			shadow.x += 2;
			shadow.y += 3;
			addChild(shadow);
			
			var bg:MovieClip = MovieClipUtils.getFilledMC(WIDTH,HEIGHT,0xff6600, true);
			addChild(bg);
			
			var textButton:TextButton = new TextButton(_classItem.name,0xff6600,WIDTH,20);
			addChild(textButton);
			_textButtons.push(textButton);
			
			var imports:Vector.<ImportItem> = _classItem.imports;
			
			for (var i:int=0; i<imports.length; i++){
				textButton = new TextButton(imports[i].importClass,0xffff66,WIDTH,16);
				var fmt:TextFormat = new TextFormat();
				fmt.size = 10;
				fmt.align = "left";
				fmt.font = "_sans";
				textButton.textFormat = fmt;
				addTextButton(textButton);
			}
			
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