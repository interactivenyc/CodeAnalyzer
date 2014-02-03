package com.inyc.components
{
	import com.inyc.core.CoreButton;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	
	import flash.events.MouseEvent;
	
	public class TransparentButton extends CoreButton
	{
		
		public function TransparentButton()
		{
			super();
			alpha = 0;
		}
		
		
		
		
		override protected function onMouseEvent(e:MouseEvent):void{
			
			switch(e.type){
				case MouseEvent.MOUSE_DOWN:
					alpha = .5;
					break;
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_OUT:
					alpha = 0;
					break;
				case MouseEvent.CLICK:
					_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.BUTTON_CLICK, {button:this}));
					break;
				
			}
		}
	}
}