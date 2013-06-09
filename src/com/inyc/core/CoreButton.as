package com.inyc.core
{
	import com.greensock.TweenLite;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CoreButton extends CoreMovieClip
	{
		//public var bg:MovieClip;
		
		public function CoreButton(){
			//super();
		}
		
		override protected function onAddedToStage(e:Event):void{
			//log("onAddedToStage core button "+this.name);
			super.onAddedToStage(e);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			addEventListener(MouseEvent.CLICK, onMouseEvent);
		}
		
		override protected function onRemovedFromStage(e:Event):void{
			//log("onRemovedFromStage core button "+this.name);
			super.onRemovedFromStage(e);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			removeEventListener(MouseEvent.CLICK, onMouseEvent);
		}
		
		public function set downState(down:Boolean):void{
			//log("set downState: "+down + ", "+this);
			if (down){
				TweenLite.to(this, .01, {colorTransform:{tint:0xFFFFFF, tintAmount:0.35}});
			}else{
				TweenLite.to(this, .01, {colorTransform:{tint:0xFFFFFF, tintAmount:0}});
			}
		}
		
		protected function onMouseEvent(e:MouseEvent):void{
			switch(e.type){
				case MouseEvent.CLICK:
					_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.BUTTON_CLICK, {button:this}));
					break;
			}
		}
		
				
	}
}
