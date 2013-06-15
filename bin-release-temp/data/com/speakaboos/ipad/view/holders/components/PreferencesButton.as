package com.speakaboos.ipad.view.holders.components
{
	import com.greensock.TweenLite;
	import com.speakaboos.ipad.controller.AppController;
	import com.speakaboos.ipad.events.AppEvents;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.events.LoginEvents;
	import com.speakaboos.ipad.utils.MovieClipUtils;
	import com.speakaboos.ipad.view.holders.CoreMovieClipHolder;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class PreferencesButton extends CoreMovieClipHolder
	{
		private var _open:Boolean = false;
		private var _isDown:Boolean = false;
		
		public function PreferencesButton(pMC:MovieClip){
			super(pMC);
			mc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			mc.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			mc.addEventListener(MouseEvent.RELEASE_OUTSIDE, onMouseEvent);
			mc.addEventListener(MouseEvent.CLICK, onMouseEvent);
			mc.addEventListener(AppEvents.ANIM_FINISHED, animClosed);
		}
		
		override public function onAddedToStage(e:Event = null):void {
			super.onAddedToStage(e);
			
			_eventDispatcher.addEventListener(AppEvents.USER_DATA_UPDATE_PROCESSED, updateDisplay);
//			_eventDispatcher.addEventListener(AppEvents.CONNECTION_MODE_CHANGED, updateDisplay);
//			_eventDispatcher.addEventListener(AppEvents.RESTRICTED_MODE_CHANGED, updateDisplay);
			_eventDispatcher.addEventListener(AppEvents.SHOW_PAGE_BUTTONS, updateDisplay);
//
//			_eventDispatcher.addEventListener(LoginEvents.ANONYMOUS_USER_LOGGED_IN, updateDisplay);
//			_eventDispatcher.addEventListener(LoginEvents.USER_LOGGED_IN, updateDisplay);
//			_eventDispatcher.addEventListener(AppEvents.LOGIN_SUCCESS, updateDisplay);
//			_eventDispatcher.addEventListener(AppEvents.LOGOUT_USER, updateDisplay);
			
			mc.visible = false;
			
		}
		
		override public function onRemovedFromStage(e:Event = null):void {
			super.onRemovedFromStage(e);
			_eventDispatcher.removeEventListener(AppEvents.USER_DATA_UPDATE_PROCESSED, updateDisplay);
//			_eventDispatcher.removeEventListener(AppEvents.CONNECTION_MODE_CHANGED, updateDisplay);
//			_eventDispatcher.removeEventListener(AppEvents.RESTRICTED_MODE_CHANGED, updateDisplay);
			_eventDispatcher.removeEventListener(AppEvents.SHOW_PAGE_BUTTONS, updateDisplay);
//
//			_eventDispatcher.removeEventListener(LoginEvents.ANONYMOUS_USER_LOGGED_IN, updateDisplay);
//			_eventDispatcher.removeEventListener(LoginEvents.USER_LOGGED_IN, updateDisplay);
//			_eventDispatcher.removeEventListener(AppEvents.LOGIN_SUCCESS, updateDisplay);
//			_eventDispatcher.removeEventListener(AppEvents.LOGOUT_USER, updateDisplay);
			
		}
		
		private function onMouseEvent(e:MouseEvent):void{
			TweenLite.killDelayedCallsTo(checkLongPress);
			
			TweenLite.delayedCall(1, checkLongPress);
			
			switch(e.type){
				case MouseEvent.MOUSE_DOWN:
					_isDown = true;
					break;
				case MouseEvent.CLICK:
					//openAnim();
					
					if (_open == true){
						closeAnim();
						TweenLite.killDelayedCallsTo(checkCloseAnim);
					}else{
						openAnim();
					}
					break;
				case MouseEvent.MOUSE_UP:
				case MouseEvent.RELEASE_OUTSIDE:
					TweenLite.killDelayedCallsTo(checkLongPress);
					_isDown = false;
					break;
			}
			log("onMouseEvent: "+e.type+", _open: "+_open);
		}
		
		private function closeAnim(e:Event = null):void{
			log("closeAnim frame: "+mc.currentFrame);
			var playFromFrame:int = 75-mc.currentFrame;
			
			log("playFromFrame: "+playFromFrame);
			
			mc.gotoAndPlay(playFromFrame);
			_open = false;
		}
		
		private function animClosed(e:Event = null):void{
			log("animClosed");
			_open = false;
		}

		
		private function openAnim(e:Event = null):void{
			log("openAnim frame: "+mc.currentFrame);
			var playFromFrame:int;
			
			if(mc.currentFrame > 50){
				playFromFrame = 75-mc.currentFrame;
			}else{
				playFromFrame = mc.currentFrame + 1;
			}
			
			log("playFromFrame: "+playFromFrame);
			
			mc.gotoAndPlay(playFromFrame);
			_open = true;			
			TweenLite.delayedCall(3, checkCloseAnim);
		}
		
		private function checkCloseAnim(e:Event = null):void{
			if (_open == true) closeAnim();
		}
		
		private function checkLongPress():void{
			log("checkLongPress");
			if (_isDown == true){
				log("LONG PRESS ACTIVATED - BLINK");
				//mc.addEventListener("BLINK_FINISHED", blinkFinished);
				mc.bg.play();
				TweenLite.delayedCall(.5, blinkFinished);
			}else{
				
			}
		}
		
		private function blinkFinished(e:Event = null):void{
			//mc.removeEventListener("BLINK_FINISHED", blinkFinished);
			mc.gotoAndStop(1);
			_open = false;
			mc.dispatchEvent(new Event(AppEvents.BUTTON_CLICK));
		}
		
		public function updateDisplay(e:GenericDataEvent = null):void{
//			log("* updateDisplay");
//			if (e != null) log("* updateDisplay: "+e.type);
			
//			if (AppController.inRestrictedMode){
//				log("* updateDisplay: RESTRICTED MODE");
//				MovieClipUtils.hiliteAndDisable(mc);
//			}else{
//				log("* updateDisplay ENABLE");
//				MovieClipUtils.reEnable(mc);
//			}
			
			if (AppController.inOfflineMode) {
//				log("* updateDisplay: OFFLINE MODE");
				mc.visible = false;
			}else{
				if (AppController.viewMode == AppController.MODE_CATEGORIES) {
//					log("* updateDisplay ENABLE");
					mc.visible = true;
				}
			}
		}
		
		
		
	}
}