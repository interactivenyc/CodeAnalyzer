package com.speakaboos.ipad.view.components
{
	import com.greensock.TweenLite;
	import com.speakaboos.ipad.controller.AppController;
	import com.speakaboos.ipad.events.AppEvents;
	import com.speakaboos.ipad.events.CoreEventDispatcher;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.story.utils.AudioPlayer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CoreButton extends CoreMovieClip
	{
		protected var _buttonSoundName:String = "GenericButtonPress";
		protected var _buttonClickEvent:String = AppEvents.BUTTON_CLICK;
		public var bg:MovieClip;
		protected var _downState:Boolean = false;
		protected var _playAudio:Boolean = false;
		
		public function get downState():Boolean {
			return _downState;
		}
		
		public function set downState(val:Boolean):void {
			_downState = val;
		}
		
		public function get playAudio():Boolean {
			return _playAudio;
		}
		
		public function set playAudio(val:Boolean):void {
			_playAudio = val;
		}
		
		public function CoreButton(){
			super.init();
		}
		
		override protected function onAddedToStage(e:Event):void{
			//log("onAddedToStage core button "+this.name);
			super.onAddedToStage(e);
			addEventListener(MouseEvent.MOUSE_DOWN, onUIEvent,false,0,true);
			addEventListener(MouseEvent.MOUSE_UP, onUIEvent,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT, onUIEvent,false,0,true);
			addEventListener(MouseEvent.CLICK, onUIEvent,false,0,true);
		}
		
		override protected function onRemovedFromStage(e:Event):void{
			//log("onRemovedFromStage core button "+this.name);
			super.onRemovedFromStage(e);
			TweenLite.killDelayedCallsTo(finishPress);
			removeEventListener(MouseEvent.MOUSE_DOWN, onUIEvent);
			removeEventListener(MouseEvent.MOUSE_UP, onUIEvent);
			removeEventListener(MouseEvent.MOUSE_OUT, onUIEvent);
			removeEventListener(MouseEvent.CLICK, onUIEvent);
		}
		
		public function press():void {
			log("mcb press "+name);
			if(_playAudio) {
				AudioPlayer.getInstance().playInternalSound(_buttonSoundName);
			}
			//TweenLite.delayedCall(0.2, finishPress);
		}
		
		protected function finishPress():void {
			log("mcb finishPress "+name);
			CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(_buttonClickEvent, {button:this}));
			downState = false;
		}
		
		protected function onUIEvent(e:Event):void{
			//log("onUIEvent "+e.type);
			if (AppController.animating == true) return;
			
			switch(e.type){
				case MouseEvent.MOUSE_DOWN:
					downState = true;
					press();
					break;
				case MouseEvent.MOUSE_UP:
					/**
					 * If button handling becomes sluggish again, move this back into MOUSE_DOWN
					 * When it's in MOUSE_DOWN it interferes with Gesture Swipes, so I'm moving it here for now. -steve
					 */
					if (downState) finishPress(); //TweenLite.delayedCall(0.2, finishPress);
					
				case MouseEvent.MOUSE_OUT:
					downState = false;
					break;
				case MouseEvent.CLICK:
					downState = false;
					//press();
					break;
				
			}
		}		
		
				
	}
}
