package com.speakaboos.ipad.view
{
	import com.greensock.TweenLite;
	import com.speakaboos.core.settings.AppConfig;
	import com.speakaboos.ipad.controller.AppController;
	import com.speakaboos.ipad.events.AppEvents;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.events.LoginEvents;
	import com.speakaboos.ipad.models.data.HolderChildParams;
	import com.speakaboos.ipad.models.data.Story;
	import com.speakaboos.ipad.models.impl.UserProfileImpl;
	import com.speakaboos.ipad.models.services.SpeakaboosService;
	import com.speakaboos.ipad.utils.MovieClipUtils;
	import com.speakaboos.ipad.view.components.CacheLoader;
	import com.speakaboos.ipad.view.holders.CoreMovieClipHolder;
	import com.speakaboos.ipad.view.holders.components.MCButton;
	import com.speakaboos.story.utils.AudioPlayer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class StoryListing extends CoreMovieClipHolder
	{
		public var popupAnim:MovieClip;
		public var title:TextField;
		public var container:MCButton;
		public var story:Story;
		private var _cacheLoader:CacheLoader;
		private var _thumbnail:Bitmap;
		private var _iconContainer:MovieClip;
		
		public function StoryListing(pStory:Story, direction:int) {
			super(new StoryListingMC());
			if (pStory) this.story = pStory;
			setupChildren(Vector.<HolderChildParams>([
				new HolderChildParams("container", MCButton, null, new GenericDataEvent(AppEvents.GRID_ITEM_CLICKED, {story:story})),
				new HolderChildParams("title")
			]));

			//title.visible = false;

			if (direction == 1){
				popupAnim = new popupAnimFwd();
			}else{
				popupAnim = new popupAnimBack();
			}
			
			mc.container.addChild(popupAnim);
			mc.popupAnim = popupAnim; // TODO:this should not be necessary, fix later with CategoryPageLayouts
		}
		
		override public function onAddedToStage(e:Event = null):void{
			super.onAddedToStage(e);
			_eventDispatcher.addEventListener(AppEvents.USER_DATA_UPDATE_PROCESSED, updateDisplay);
//			_eventDispatcher.addEventListener(AppEvents.CONNECTION_MODE_CHANGED, updateDisplay);
//			_eventDispatcher.addEventListener(AppEvents.RESTRICTED_MODE_CHANGED, updateDisplay);
//			
//			_eventDispatcher.addEventListener(LoginEvents.ANONYMOUS_USER_LOGGED_IN, updateDisplay);
//			_eventDispatcher.addEventListener(LoginEvents.USER_LOGGED_IN, updateDisplay);
//			_eventDispatcher.addEventListener(AppEvents.LOGIN_SUCCESS, updateDisplay);
//			_eventDispatcher.addEventListener(AppEvents.LOGOUT_USER, updateDisplay);
			
			display();
			updateDisplay();
		}
		
		override public function onRemovedFromStage(e:Event = null):void{
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
		
		
		private function display():void{
			if (story==null) return;
			
			title.text = "";
			
			_cacheLoader = new CacheLoader();
			//("display storyIcon: "+story.storyIcon);
			
			_cacheLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onThumbnailLoaded,false,0,true);
			_cacheLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError,false,0,true);
			_cacheLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError,false,0,true);
			_cacheLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError,false,0,true);
			_cacheLoader.loadUrl(story.storyIcon);
			
		}

		
		private function onThumbnailLoaded(e:Event):void{
			_thumbnail = Bitmap(_cacheLoader.content);
			
			if (_cacheLoader.contentLoaderInfo.url == null){
				mc.dispatchEvent(new Event(AppEvents.THUMBNAIL_LOADED));
				return;
			}
			
			TweenLite.delayedCall(.25, setText);
			
			//Create bitmap, add to Story as lowResIcon. This is actually the highResBitmap that appears on the PBE story loading screen.
			var tempBD:BitmapData = new BitmapData(_thumbnail.width, _thumbnail.height, true, 0x000000);
			tempBD.draw(_thumbnail);
			story.lowResIcon = tempBD;
			
//			//Scale bitmap using copyScaledBmp routine - disable for now
//			var bitmap:Bitmap = BitmapUtils.copyScaledBmp(_thumbnail, 240);
//			popupAnim.container.addChild(bitmap);
			
			//Scale down bitmap for use on StoryListings page
			_thumbnail.width = 240;
			_thumbnail.scaleY = _thumbnail.scaleX;
			_thumbnail.smoothing = true;
			
			popupAnim.container.addChild(_thumbnail);
			//AudioPlayer.getInstance().playInternalSound("SkewSound");
			
						
			mc.dispatchEvent(new Event(AppEvents.THUMBNAIL_LOADED));
			
			if (AppConfig.DEBUG_MODE && story.saved){
				log("Applying saved icon to story icon: " + story.shortTitle);
				var savedIcon:SavedIcon = new SavedIcon();
				addChild(savedIcon);
			}else{
				//addChild(MovieClipUtils.getFilledMC(12,12));
			}
			
			showModeIcons();
			destroyLoader();
		}
		
		protected function setText():void{
			if (story) {
				title.text = story.shortTitle;
				var fmt:TextFormat = title.getTextFormat();
				fmt.color = "0x" + SpeakaboosService.getInstance().category.category_screen_text_color;
				title.setTextFormat(fmt);
			}
		}
		
		protected function showModeIcons():void{
			var _modeIcon:Array = [];
			for( var i:int = 0; i < story.modes.length; i++ ) {
				switch(story.modes[i]) {
					case "0":
						if (story.storyType == "video-song"){
							_modeIcon.push(new Bitmap( new modeIndicatorSmall3() ));
						}else{
							_modeIcon.push(new Bitmap( new modeIndicatorSmall0() ));
						}
						
						break
					case "1":
						_modeIcon.push(new Bitmap( new modeIndicatorSmall1() ));
						break;
					case "2":
						_modeIcon.push(new Bitmap( new modeIndicatorSmall2() ));
						break;
					
				}	
			}
			
			_iconContainer = new MovieClip();
			_iconContainer.y = title.y + 30;
			switch(_modeIcon.length) {
				case 1:
					_iconContainer.addChild(_modeIcon[0]);
					
					_modeIcon[0].scaleX = _modeIcon[0].scaleY = .5;
					break;
				case 2: 
					_iconContainer.addChild(_modeIcon[0]);
					_iconContainer.addChild(_modeIcon[1]);
					
					_modeIcon[0].scaleX = _modeIcon[0].scaleY = .5;
					_modeIcon[1].scaleX = _modeIcon[1].scaleY = .5;
					
					_modeIcon[1].x = _modeIcon[0].x + _modeIcon[1].width + 2;
					
					break;
				case 3:
					_iconContainer.addChild(_modeIcon[0]);
					_iconContainer.addChild(_modeIcon[1]);
					_iconContainer.addChild(_modeIcon[2]);
					
					_modeIcon[0].scaleX = _modeIcon[0].scaleY = .5;
					_modeIcon[1].scaleX = _modeIcon[1].scaleY = .5;
					_modeIcon[2].scaleX = _modeIcon[2].scaleY = .5;
					
					_modeIcon[1].x = _modeIcon[0].x + _modeIcon[1].width + 2;
					_modeIcon[2].x = _modeIcon[1].x + _modeIcon[2].width + 2;
					
					break;
			}
			_iconContainer.x = (_thumbnail.width/2) - (_iconContainer.width/2);
			container.addChild(_iconContainer);
			container.addChild(title);
		}
		
		private function destroyLoader():void {
			_cacheLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onThumbnailLoaded);
			_cacheLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_cacheLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_cacheLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_cacheLoader.destroy();
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
		
		public function convertToBitmap():void{
			//log("convertToBitmap");			
			var _renderedMC:MovieClip = MovieClipUtils.getRenderedMC(mc);
			
			popupAnim.container.visible = false;
			//container.visible = false;
			
			title.visible = false;
			
			addChild(_renderedMC);
		}
		
		public function get thumbnail():BitmapData{
			var bitmapData:BitmapData = new BitmapData(_thumbnail.width, _thumbnail.height);
			bitmapData.draw(_thumbnail);
			return bitmapData;
		}
		
		public function updateDisplay(e:GenericDataEvent = null):void{
//			log("* updateDisplay");
//			if (e != null) log("* updateDisplay: "+e.type);

//			log("* updateDisplay ENABLE");
			MovieClipUtils.reEnable(mc);
			if (AppController.inOfflineMode) {
				if (!story.saved){
//					log("* updateDisplay OFFLINE MODE");
					MovieClipUtils.hiliteAndDisable(mc);
				}
			}else if (AppController.inRestrictedMode){
//				log("* updateDisplay RESTRICTED MODE");
				if (!story.saved) MovieClipUtils.hiliteMC(mc);
			}
		}

		override public function destroy():void {
			log("destroy");
			destroyLoader();
			removeChildren();
			story = null;
			_cacheLoader = null;
			_thumbnail = null;
			super.destroy();
		}
	}
}
