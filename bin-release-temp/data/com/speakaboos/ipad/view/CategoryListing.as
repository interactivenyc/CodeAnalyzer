
package com.speakaboos.ipad.view
{
	import com.greensock.TweenLite;
	import com.speakaboos.ipad.controller.AppController;
	import com.speakaboos.ipad.events.AppEvents;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.models.data.Category;
	import com.speakaboos.ipad.models.data.HolderChildParams;
	import com.speakaboos.ipad.models.services.SpeakaboosService;
	import com.speakaboos.ipad.view.components.CacheLoader;
	import com.speakaboos.ipad.view.holders.CoreMovieClipHolder;
	import com.speakaboos.story.events.AudioEvent;
	import com.speakaboos.story.events.CentralEventDispatcher;
	import com.speakaboos.story.events.StoryEvent;
	import com.speakaboos.story.utils.AnimationPlayer;
	import com.speakaboos.story.utils.AudioPlayer;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CategoryListing extends CoreMovieClipHolder
	{
		public var container:MovieClip;
		public var title:TextField;
		//		public var subtitle:TextField;
		public var category:Category;
		private var categoryIconLoader:CacheLoader;
		private var _thumbnail:Bitmap;
		private var _categoryIcon:MovieClip;
		private var _fromForwardBack:Boolean;
		private var _blockClick:Boolean = false;
		
		private var _localAssetsDirectory:File;
		public static const FRAME_LABEL_PASSED:String = "FRAME_LABEL_PASSED";
		
		
		
		public function CategoryListing(pMC:MovieClip){
			super(new CategoryListingMC());
			pMC.addChild(mc);
			setupChildren(Vector.<HolderChildParams>([
				new HolderChildParams("container"),
				new HolderChildParams("title")
			]));
		}
		public function init(pCategory:Category = null, pFromForwardBack:Boolean = false):void {
			//this is due to a new feature that changes the category icon animation based on how 
			//the user navigates to the page. If we have a navigation manager or the like in the future we may change this.
			_fromForwardBack = pFromForwardBack; 
			
			if (pCategory) category = pCategory;			
			display();
		}
		
		override public function onAddedToStage(e:Event = null):void{
			//log("onAddedToStage");
			//log("parent:"+mc.parent);
			super.onAddedToStage(e);
			CentralEventDispatcher.getInstance().addEventListener( AudioEvent.PLAY_MAIN_APP_SOUND, playCategorySound );
			CentralEventDispatcher.getInstance().addEventListener( StoryEvent.END_FRAME_REACHED, handleEndFrame );
			this.addEventListener(MouseEvent.MOUSE_DOWN, onButtonClick,false,0,true);
			_eventDispatcher.addEventListener(AppEvents.USER_DATA_UPDATE_PROCESSED, updateDisplay);
//			_eventDispatcher.addEventListener(AppEvents.CONNECTION_MODE_CHANGED, updateDisplay);
//			_eventDispatcher.addEventListener(AppEvents.LOGIN_SUCCESS, updateDisplay);
//			_eventDispatcher.addEventListener(AppEvents.LOGOUT_USER, updateDisplay);
		}
		
		
		override public function onRemovedFromStage(e:Event = null):void{
			log("onRemovedFromStage");
			
			if (_categoryIcon != null) AnimationPlayer.getInstance().stop(_categoryIcon.name);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonClick);
			super.onRemovedFromStage(e);
			_eventDispatcher.removeEventListener(AppEvents.USER_DATA_UPDATE_PROCESSED, updateDisplay);
//			_eventDispatcher.removeEventListener(AppEvents.CONNECTION_MODE_CHANGED, updateDisplay);
//			_eventDispatcher.removeEventListener(AppEvents.LOGIN_SUCCESS, updateDisplay);
//			_eventDispatcher.removeEventListener(AppEvents.LOGOUT_USER, updateDisplay);
		}
		
		private function removeEventListeners():void{
			CentralEventDispatcher.getInstance().removeEventListener( AudioEvent.PLAY_MAIN_APP_SOUND, playCategorySound );
			CentralEventDispatcher.getInstance().removeEventListener( StoryEvent.END_FRAME_REACHED, handleEndFrame );
		}
		
		
		private function display():void{
			//log("display category.slug: "+category.slug);
			if (category==null) return;
			
			title.text = category.short_title;
			
			//log("display: "+title.text);
			
			var fmt:TextFormat = title.getTextFormat();
			fmt.color = "0x" + SpeakaboosService.getInstance().category.category_screen_text_color;
			title.setTextFormat(fmt);
			
			categoryIconLoader = new CacheLoader();
			var iconURL:String;
			
			if (AppController.viewMode == AppController.MODE_STORIES) {
				//log("load Thumbnail: "+category.category_screen_category_icon);
				iconURL = category.category_screen_category_icon;
			}
			
			categoryIconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFLoaded);
			categoryIconLoader.addEventListener(Event.COMPLETE, onSWFLoaded,false,0,true);
			categoryIconLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError,false,0,true);
			categoryIconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError,false,0,true);
			categoryIconLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError,false,0,true);
			categoryIconLoader.loadUrl(iconURL);
		}
		
		private function onSWFLoaded(e:Event):void{	
			log("onSWFLoaded _fromForwardBack: "+_fromForwardBack);
			
			categoryIconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSWFLoaded);	
			mc.dispatchEvent(new Event(AppEvents.THUMBNAIL_LOADED));
			
			_categoryIcon = categoryIconLoader.content as MovieClip;
			
			
			if(_fromForwardBack == true) {
				AudioPlayer.getInstance().stopAllSounds();
				log("Category Internal page turn");
				log("Audio: AnimationPlayer MAIN - IDLE");
				AnimationPlayer.getInstance().play(_categoryIcon, AnimationPlayer.FRAME_POP_UP, AnimationPlayer.FRAME_MAIN);
			} else {
				if(AppController.previousViewMode == AppController.MODE_STORY){
					log("Category accessed from Story");
					log("Audio: AnimationPlayer POP_UP - IDLE");
					AnimationPlayer.getInstance().play(_categoryIcon, AnimationPlayer.FRAME_POP_UP, AnimationPlayer.FRAME_LOOP_IDLE);
				}else{
					log("Category accessed from Home Screen");
					log("Audio: AnimationPlayer POP_UP - IDLE");
					AnimationPlayer.getInstance().play(_categoryIcon, AnimationPlayer.FRAME_POP_UP, AnimationPlayer.FRAME_LOOP_IDLE);
				}
			}
			
			container.addChild(_categoryIcon);
			
			_categoryIcon.mouseEnabled = false;
			_categoryIcon.mouseChildren = false;
			container.addChild(title);
			//destroyLoader();
		}
		
		private function onButtonClick(e:MouseEvent):void{
			if (_blockClick == false){
				log("Category Clicked Audio: category.category_welcome_audio: "+category.category_welcome_audio);
				_blockClick = true;
				TweenLite.delayedCall(1, enableClick);
				
				playCategorySound(null, "category_welcome_audio");
				playCategorySound(null, "main_animation_audio");
				
				AnimationPlayer.getInstance().stop(_categoryIcon.name);
				AnimationPlayer.getInstance().play(_categoryIcon, AnimationPlayer.FRAME_MAIN, AnimationPlayer.FRAME_LOOP_IDLE);
			}
		}
		
		private function enableClick(e:Event = null):void{
			_blockClick = false;
		}
		
		private function handleEndFrame( evt:StoryEvent ):void {
			log("handleEndFrame: "+evt.infoObj.frameLabel);
			log(evt.infoObj);
			
			switch( evt.infoObj.frameLabel ) {
				case AnimationPlayer.FRAME_MAIN:
					AnimationPlayer.getInstance().play(_categoryIcon, AnimationPlayer.FRAME_IDLE, AnimationPlayer.FRAME_LOOP_IDLE);
					break;
				case AnimationPlayer.FRAME_IDLE:
					//AnimationPlayer.getInstance().play(_categoryIcon, AnimationPlayer.FRAME_IDLE, AnimationPlayer.FRAME_LOOP_IDLE);
					break;
						
			}
		}
		
		private function playCategorySound( evt:AudioEvent=null, audioString:String="" ):void {
			if (evt != null) audioString = evt.parameters.audio;
			log("playCategorySound: "+audioString);
			
			switch( audioString ) {
				case "popup_animation_audio":
					CacheLoader.playAudioFromCachedUrl(category.popup_animation_audio);
					break;
				case "main_animation_audio":
					CacheLoader.playAudioFromCachedUrl(category.main_animation_audio);
					CentralEventDispatcher.getInstance().removeEventListener( AudioEvent.PLAY_MAIN_APP_SOUND, playCategorySound );
					break;
				case "category_welcome_audio":
					CacheLoader.playAudioFromCachedUrl(category.category_welcome_audio);
					break;
			}
		}
		
		private function destroyLoader():void {
			categoryIconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSWFLoaded);
			categoryIconLoader.removeEventListener(Event.COMPLETE, onSWFLoaded);
			categoryIconLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			categoryIconLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			categoryIconLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			categoryIconLoader.destroy();
		}
		
		protected function onIOError(e:IOErrorEvent):void{
			destroyLoader();
			log("onIOError: " + e.text);
			//dispatch this anyway
			mc.dispatchEvent(new Event(AppEvents.THUMBNAIL_LOADED));
			
		}
		
		protected function onSecurityError(e:SecurityError):void{
			destroyLoader();
			log("onSecurityError: " + e.text);
			//dispatch this anyway
			mc.dispatchEvent(new Event(AppEvents.THUMBNAIL_LOADED));
		}
		
		public function updateDisplay():void{
			
		}
		
		override public function destroy():void {
			log("destroy");
			destroyLoader();
			removeEventListeners();
			super.destroy();
		}
	}
}
