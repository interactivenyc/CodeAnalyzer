﻿package com.speakaboos.ipad.view{		import com.greensock.TweenLite;	import com.speakaboos.ipad.controller.AppController;	import com.speakaboos.ipad.events.AppEvents;	import com.speakaboos.ipad.events.GenericDataEvent;	import com.speakaboos.ipad.events.LoginEvents;	import com.speakaboos.ipad.models.data.Category;	import com.speakaboos.ipad.models.data.HolderChildParams;	import com.speakaboos.ipad.models.data.Story;	import com.speakaboos.ipad.models.services.SpeakaboosService;	import com.speakaboos.ipad.utils.MovieClipUtils;	import com.speakaboos.ipad.utils.ObjectUtils;	import com.speakaboos.ipad.view.components.CacheLoader;	import com.speakaboos.ipad.view.holders.components.MCButton;		import flash.display.MovieClip;	import flash.events.Event;	import flash.events.MouseEvent;
			public class PromoScreen extends MCButton {		public var container:MovieClip;		public var mask:MovieClip;				private var _thumbnailLoader:CacheLoader;		private var _thumbURL:String;				private var _swiping:Boolean = false;		public function get swiping():Boolean{return _swiping};				private var _swipeDirection:int;		private static var _promo:*;				public function PromoScreen(pMC:MovieClip){			super(pMC);			setupChildren(Vector.<HolderChildParams>([				new HolderChildParams("container"),				new HolderChildParams("mask")			]));									_buttonClickEvent = Billboard.BILLBOARD_CLICK_EVENT;						container.removeChildren();			_thumbnailLoader = new CacheLoader();			container.addChild(_thumbnailLoader);		}				override public function onAddedToStage(e:Event = null):void {			super.onAddedToStage(e);			addListeners();			if (_promo != null) setPromo(_promo);					}				override public function onRemovedFromStage(e:Event = null):void {			super.onRemovedFromStage(e);			removeListeners();		}				private function addListeners():void {			_eventDispatcher.addEventListener(AppEvents.USER_DATA_UPDATE_PROCESSED, updateDisplay);			_eventDispatcher.addEventListener(AppEvents.PAGE_FLIP_FINISHED, updateDisplay);		}				private function removeListeners():void {			_eventDispatcher.removeEventListener(AppEvents.USER_DATA_UPDATE_PROCESSED, updateDisplay);			_eventDispatcher.removeEventListener(AppEvents.PAGE_FLIP_FINISHED, updateDisplay);		}					public function setPromo(promo:*):void{			//log("setPromo: "+promo.thumbnail);			_promo = promo;			_swiping = false;			loadImage(promo);			checkStoryAvailable();			updateDisplay();		}				private function checkStoryAvailable():void{			var category:Category = SpeakaboosService.getInstance().getCategoryBySlug(_promo.slug);			var story:Story = SpeakaboosService.getInstance().getStoryBySlug(_promo.slug);						if (AppController.inOfflineMode && ((category && (category.savedStoryCount < 1)) || (story && !story.saved))) { 				MovieClipUtils.hiliteAndDisable(container);			}		}				public function doSwipe(direction:int, promo:*):void{			_swiping = true;			_swipeDirection = direction;						container.addChild(_thumbnailLoader.content);			_thumbnailLoader.x = _swipeDirection * container.width;			container.addChild(_thumbnailLoader);						//loadImage(promo);			setPromo(promo);			_swiping = true;		}				private function loadImage(promo:*):void{			//log("loadImage promo.slug: "+promo.slug);			_thumbURL = promo.thumbnail;			_thumbnailLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded,false,0,true);			_thumbnailLoader.loadUrl(_thumbURL);		}				private function onImageLoaded(e:Event):void{			//log("onImageLoaded");			_thumbnailLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);			_thumbnailLoader.content.width = 200;			_thumbnailLoader.content.height = 150;			if (_swiping == true){				TweenLite.to(_thumbnailLoader, .25, {x:0, onComplete:transitionFinished});				TweenLite.to(container.getChildAt(0), .25, {x:-200});			}else{				mc.dispatchEvent(new Event(Billboard.PROMO_LOADED_EVENT));			}		}				private function transitionFinished():void{			container.removeChildren();			container.addChild(_thumbnailLoader);			mc.dispatchEvent(new Event(Billboard.PROMO_LOADED_EVENT));			updateDisplay();					}				public function updateDisplay(e:GenericDataEvent = null):void{//			log("* updateDisplay");//			if (e != null) log("* updateDisplay: "+e.type);			//			log("* updateDisplay ENABLE");						var story:Story = SpeakaboosService.getInstance().getStoryBySlug(_promo.slug);			if (story) {				MovieClipUtils.reEnable(mc);								if (AppController.inRestrictedMode){					//				log("* updateDisplay RESTRICTED");					if (story.saved == true){						//					log("* updateDisplay SAVED");						MovieClipUtils.reEnable(mc);					}else{						//					log("* updateDisplay DISABLE");						MovieClipUtils.hiliteMC(mc);					}									}else if (AppController.inOfflineMode) {					//				log("* updateDisplay OFFLINE");										if (story.saved == true){						//					log("* updateDisplay SAVED");						MovieClipUtils.reEnable(mc);					}else{						//					log("* updateDisplay DISABLE");						MovieClipUtils.hiliteAndDisable(mc);					}				}else{									}			}		}						override protected function onUIEvent(e:MouseEvent):void{			//			log("onUIEvent "+e.type+", "+this.name);			if (AppController.animating == true) return;			if (_selected == true) return;						switch(e.type){				case MouseEvent.MOUSE_DOWN:					downState = true;					press();					break;				case MouseEvent.MOUSE_UP:					/**					 * If button handling becomes sluggish again, move this back into MOUSE_DOWN					 * When it's in MOUSE_DOWN it interferes with Gesture Swipes, so I'm moving it here for now. -steve					 */					if (downState) finishPress(); //TweenLite.delayedCall(0.2, finishPress);				case MouseEvent.MOUSE_OUT:					//downState = false;					break;				case MouseEvent.CLICK:					downState = false;					//press();					break;							}		}				override public function destroy():void {			//TODO: flesh this out			log("destroy");			removeListeners();			if (_thumbnailLoader) {				_thumbnailLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);				TweenLite.killTweensOf(_thumbnailLoader);				TweenLite.killTweensOf(container.getChildAt(0));				_thumbnailLoader.destroy();			}						super.destroy();		}	}}