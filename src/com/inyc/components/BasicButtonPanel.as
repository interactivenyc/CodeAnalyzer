package com.inyc.components
{
	import com.inyc.core.CoreMovieClip;
	
	import flash.events.MouseEvent;
	
	public class BasicButtonPanel extends CoreMovieClip
	{
		protected var _buttons:Array = new Array();
		
		
		public function BasicButtonPanel(){
			super();
		}
		
		protected function addButton(btn:BasicButton):void{
			btn.addEventListener(MouseEvent.CLICK, onMouseEvent);
			_buttons.push(btn);
		}
		
		protected function onMouseEvent(e:MouseEvent):void{
			for (var i:int=0; i<_buttons.length; i++){
				(_buttons[i] as BasicButton).selected = false;
				(e.target as BasicButton).selected = true;
			}
		}
	}
}