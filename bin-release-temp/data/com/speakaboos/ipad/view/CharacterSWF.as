package com.speakaboos.ipad.view
{
	import com.greensock.TweenLite;
	import com.speakaboos.ipad.controller.AppController;
	import com.speakaboos.ipad.events.AppEvents;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.events.LoginEvents;
	import com.speakaboos.ipad.models.data.Category;
	import com.speakaboos.ipad.models.data.Character;
	import com.speakaboos.ipad.models.data.HolderChildParams;
	import com.speakaboos.ipad.models.services.SpeakaboosService;
	import com.speakaboos.ipad.utils.MovieClipUtils;
	import com.speakaboos.ipad.view.holders.CoreMovieClipHolder;
	import com.speakaboos.ipad.view.holders.components.MCButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class CharacterSWF extends CoreMovieClipHolder
	{
		private var _position:int;
//		private var _hitArea:Shape;
		private var _character:Character;
		private var _charMC:MovieClip;
		private var _animFinishedCallback:Function;

		public function set character(charInfo:Character):void {
			_character = charInfo;
			//if (mc) mc.name = _character.slug;
		}
		
		
		public function CharacterSWF(swf:MovieClip, charInfo:Character){
			super(swf);
			character = charInfo;
			_charMC = mc.getChildAt(0) as MovieClip;
			//log("CharacterSWF child name "+_charMC.name);
			//log(_charMC, mc.getChildByName(_charMC.name));
			setupChildren(Vector.<HolderChildParams>([
				new HolderChildParams(_charMC.name, MCButton, null, new GenericDataEvent(CharacterWheel.CHAR_CLICKED, {char:_character}))
			]));
			prepAnim();
			
			updateDisplay();
			
		}
		
		override public function onAddedToStage(e:Event = null):void {
			super.onAddedToStage(e);
			_eventDispatcher.addEventListener(AppEvents.USER_DATA_UPDATE_PROCESSED, updateDisplay);
		}
		
		override public function onRemovedFromStage(e:Event = null):void {
			super.onRemovedFromStage(e);
			_eventDispatcher.removeEventListener(AppEvents.USER_DATA_UPDATE_PROCESSED, updateDisplay);
//			_eventDispatcher.removeEventListener(AppEvents.CONNECTION_MODE_CHANGED, updateDisplay);
//			_eventDispatcher.removeEventListener(AppEvents.RESTRICTED_MODE_CHANGED, updateDisplay);
//
//			_eventDispatcher.removeEventListener(LoginEvents.ANONYMOUS_USER_LOGGED_IN, updateDisplay);
//			_eventDispatcher.removeEventListener(LoginEvents.USER_LOGGED_IN, updateDisplay);
//			_eventDispatcher.removeEventListener(AppEvents.LOGIN_SUCCESS, updateDisplay);
//			_eventDispatcher.removeEventListener(AppEvents.LOGOUT_USER, updateDisplay);
			
		}
		
		private function prepAnim():void {
			visible = false;
			for (var i:int = 1; i<=CharacterWheel.CHAR_SLOT_COUNT; i++) {
				_charMC.gotoAndStop("out_0"+i);
				_charMC.addFrameScript(_charMC.currentFrame - 1, stopAnim);
				_charMC.gotoAndStop("animFinished_0"+i);
				_charMC.addFrameScript(_charMC.currentFrame - 1, stopAnim);
			}
		}
		
		private function playAnim(startFrame:String):void{
			_charMC.gotoAndPlay(startFrame);
			visible = true;
		}
		
		private function stopAnim(): void {
			_charMC.stop();
			var callback:Function = _animFinishedCallback;
			_animFinishedCallback = null;
			if (callback) callback();
		}
		
		public function setPosition(pos:int, callback:Function = null):void{
			//log("setPosition: "+pos);
			_animFinishedCallback = callback;
			_position = pos;
			visible = false;
			if (_position == -1){
				
			}else{
				var startFrame:String = "in_0"+_position;
				TweenLite.delayedCall(_position/8, playAnim, [startFrame]);
			}
		}
		
		public function updateDisplay(e:GenericDataEvent = null):void{
			//log("* updateDisplay char "+_character.slug+", "+_character.savedStoryCount);
//			if (e != null) log("* updateDisplay: "+e.type);

			MovieClipUtils.reEnable(mc);
//			log("* updateDisplay ENABLE");
						
			if (AppController.inRestrictedMode && _character.savedStoryCount == 0){
//				log("* updateDisplay RESTRICTED");
				MovieClipUtils.hiliteMC(mc);
			}
			
			if (AppController.inOfflineMode && _character.savedStoryCount == 0) {
//				log("* updateDisplay OFFLINE MODE");
				MovieClipUtils.hiliteAndDisable(mc);
			}
		}
		
		override public function destroy():void {
			//TODO: flesh this out
			log("destroy");
			TweenLite.killDelayedCallsTo(playAnim);
			super.destroy();
		}
	}
}
