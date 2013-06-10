package com.speakaboos.ipad.view
{
	import com.speakaboos.ipad.controller.AppController;
	import com.speakaboos.ipad.events.AppEvents;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.events.LoginEvents;
	import com.speakaboos.ipad.events.NavEvents;
	import com.speakaboos.ipad.models.data.Story;
	import com.speakaboos.ipad.utils.ObjectUtils;
	import com.speakaboos.ipad.view.components.CacheLoader;
	import com.speakaboos.ipad.view.holders.CoreMovieClipHolder;
	import com.speakaboos.story.controller.StoryController;
	import com.speakaboos.story.events.CentralEventDispatcher;
	import com.speakaboos.story.events.PlaybackEngineApplicationEvent;
	import com.speakaboos.story.events.StoryEvent;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class StoryView extends CoreMovieClipHolder
	{
		private var _currentStory:Story;
		private var _storyController:StoryController;
		
		public function StoryView(){
			log("*** CONSTRUCTOR");
			super(new MovieClip());
		}
		
		
		
		public function set story(story:Story):void{
			log("*** set story: "+story.title);
			_currentStory = story;
			
			_storyController = AppController.getInstance().storyController;
			mc.addChild(_storyController);
			playStory();
		}
		
	
		override public function onAddedToStage(e:Event = null):void{
			log("onAddedToStage");
			super.onAddedToStage(e);
			addListeners();
		}
		
		override public function onRemovedFromStage(e:Event = null):void{
			//log("onRemovedFromStage");
			super.onRemovedFromStage(e);
			removeListeners();
		}
		
		public function addListeners():void{
			_eventDispatcher.addEventListener(NavEvents.GO_CATEGORY, receiveEvent);
			_eventDispatcher.addEventListener(NavEvents.GO_HOME, receiveEvent);
			_eventDispatcher.addEventListener(NavEvents.GO_BACK, receiveEvent);
			_eventDispatcher.addEventListener(NavEvents.GO_FWD, receiveEvent);
			_eventDispatcher.addEventListener(NavEvents.GO_MYBOOKS, receiveEvent);
			
			_eventDispatcher.addEventListener( LoginEvents.INIT_LOGIN, receiveEvent );
			_storyController.addEventListener( StoryEvent.EXIT_STORY, onStoryExitRequest );
			
			CentralEventDispatcher.getInstance().addEventListener( StoryEvent.EXIT_STORY, onStoryEvent );
			CentralEventDispatcher.getInstance().addEventListener( StoryEvent.LOAD_STORY, onStoryEvent );
			CentralEventDispatcher.getInstance().addEventListener( StoryEvent.PLAY_LOADED_STORY, onStoryEvent );
			CentralEventDispatcher.getInstance().addEventListener( PlaybackEngineApplicationEvent.ASSETS_SAVED, onAssetsSaved );
		}
		
		public function removeListeners():void{
			
			_eventDispatcher.removeEventListener(NavEvents.GO_CATEGORY, receiveEvent);
			_eventDispatcher.removeEventListener(NavEvents.GO_HOME, receiveEvent);
			_eventDispatcher.removeEventListener(NavEvents.GO_BACK, receiveEvent);
			_eventDispatcher.removeEventListener(NavEvents.GO_FWD, receiveEvent);
			_eventDispatcher.removeEventListener(NavEvents.GO_MYBOOKS, receiveEvent);
			
			_eventDispatcher.removeEventListener( LoginEvents.INIT_LOGIN, receiveEvent );
			_storyController.removeEventListener( StoryEvent.EXIT_STORY, onStoryExitRequest );
			
			CentralEventDispatcher.getInstance().removeEventListener( StoryEvent.EXIT_STORY, onStoryEvent );
			CentralEventDispatcher.getInstance().removeEventListener( StoryEvent.LOAD_STORY, onStoryEvent );
			CentralEventDispatcher.getInstance().removeEventListener( StoryEvent.PLAY_LOADED_STORY, onStoryEvent );
			CentralEventDispatcher.getInstance().removeEventListener( PlaybackEngineApplicationEvent.ASSETS_SAVED, onAssetsSaved );

			
		}
		
		
		private function playStory():void 
		{
			
			log("**********************************************");
			log("*** playStory");
			log("**********************************************");
			
			log(ObjectUtils.getGenericObject(_currentStory));
			
			log("before loading icon "+_currentStory.slug);
			var loader:CacheLoader = new CacheLoader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, storyIconLoaded);
			loader.loadUrl(_currentStory.storyIcon);
			
		}
		
		private function storyIconLoaded(e:Event):void{
			log("storyIconLoaded "+_currentStory.slug);
			log(e.target.loader);
			
			var loader:CacheLoader = e.target.loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, storyIconLoaded);
			
			var content:DisplayObject = loader.content;
			loader.destroy();
			var bitmapData:BitmapData = new BitmapData(content.width, content.height, true, 0xffffff);
			bitmapData.draw(content);
			_currentStory.lowResIcon = bitmapData;
			
			log("_currentStory.lowResIcon: "+_currentStory.lowResIcon);
			
			log("before fireStoryEvent "+_currentStory.slug);
			fireStoryEvent();
//			checkDB();
		}
		
//		private function checkDB():void{
//			_eventDispatcher.addEventListener(DBEvents.STORY_RETRIEVED, onCheckDB);
//			//SpeakaboosService.getInstance().setCategoryBySlug(_currentStory.categories[0]);
//			StoryDbService.getInstance().getStoryBySlug(_currentStory.slug);
//		}
//		
//		private function onCheckDB(e:GenericDataEvent):void{
//			_eventDispatcher.removeEventListener(DBEvents.STORY_RETRIEVED, onCheckDB);
//			
//			var storyQueryResults:Object = e.data.storyQueryResults;
//			
//			log("onCheckDB");
//			log("onCheckDB storyQueryResults:"+storyQueryResults);
//			log("onCheckDB _currentStory:"+_currentStory);
//			log("onCheckDB _currentStory.slug:"+_currentStory.slug);
//			
//			if(storyQueryResults && storyQueryResults.slug == _currentStory.slug){
//				log("onCheckDB story.saved = true");
//				_currentStory.saved = true;
//			}
//			
//			fireStoryEvent();			
//		}
		
		private function fireStoryEvent():void{
			log("fireEvent");
			
			log(ObjectUtils.getGenericObject(_currentStory));
			
			var storyEvent:StoryEvent = new StoryEvent( StoryEvent.LOAD_STORY, _currentStory );			
			CentralEventDispatcher.getInstance().dispatchEvent( storyEvent );
		}
		
		
		
		private function onAssetsSaved(e:PlaybackEngineApplicationEvent):void{
			log("onAssetsSaved");	
			log("info: "+e.infoObj);
			
//			_currentStory.saved = true; this is done when the DB finishes setting the story saved
			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.STORY_ASSETS_LOADED, {story:_currentStory}));
			
		}
		
		private function onStoryExitRequest(e:StoryEvent):void{
			log("onStoryExitRequest");	
			exitStory();
			
		}
		
		public function exitStory():void{
			log("exitStory");
			
			//CentralEventDispatcher.getInstance().dispatchEvent(new StoryEvent(StoryEvent.EXIT_STORY));
			
			if (contains(_storyController)) {
				removeChild(_storyController);
			}
			
			_storyController.reset();
			
			removeChildren();
		}
		
		
		
		
		
		private function receiveEvent(e:GenericDataEvent):void{
			switch (e.type){
				case NavEvents.GO_CATEGORY:
					exitStory();
					break;
				case NavEvents.GO_HOME:
					exitStory();
					break;
				case NavEvents.GO_FWD:
					exitStory();
					break;
				case NavEvents.GO_BACK:
					exitStory();
					break;
				case NavEvents.GO_MYBOOKS:
					exitStory();
					break;
				case LoginEvents.INIT_LOGIN:
					exitStory();
					break;
			}
		}
		
		
		private function onStoryEvent(e:StoryEvent):void{
			log("onStoryEvent: "+e.type)
			
			switch (e.type){
				case StoryEvent.EXIT_STORY:
					break;
				case StoryEvent.LOAD_STORY:
					break;
				case StoryEvent.PLAY_LOADED_STORY:
					break;
			}
		}
		
		override public function destroy():void {
			log("destroy");
			removeChildren();
			removeListeners();
			super.destroy();
		}
	}
}
