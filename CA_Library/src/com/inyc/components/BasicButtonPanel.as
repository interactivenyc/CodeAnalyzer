package com.inyc.components
{
	import com.inyc.core.CoreMovieClip;
	
	import flash.events.MouseEvent;
	
	public class BasicButtonPanel extends CoreMovieClip
	{
		protected var _buttons:Vector.<BasicButton> = new Vector.<BasicButton>();
		
		
		public function BasicButtonPanel(){
			super();
		}
		
		protected function addButton(btn:BasicButton):void{
			log("addButton: "+btn.name);
			btn.addEventListener(MouseEvent.CLICK, onMouseEvent);
			_buttons.push(btn);
		}
		
		public function setButton(btn:BasicButton):void{
			log("setButton: "+btn.name);
			for (var i:int=0; i<_buttons.length; i++){
				_buttons[i].selected = false;
			}
			
			btn.selected = true;
		}
		
		protected function onMouseEvent(e:MouseEvent):void{
			setButton(e.currentTarget as BasicButton);
		}
	}
}