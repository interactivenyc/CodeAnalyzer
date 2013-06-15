/********************************************************************************************************
 * @file	RelatedStoryLoader.as
 * @author 	shaneculp
 * @date	Jan 31, 2013 12:32:45 PM
 *
 * Helper to manage and launch related stories from clicks on the end screen.
 * 
 ********************************************************************************************************/
package com.speakaboos.ipad.view.components
{
	import com.speakaboos.ipad.events.AppEvents;
	import com.speakaboos.ipad.events.CoreEventDispatcher;
	import com.speakaboos.ipad.events.DBEvents;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.events.ModalEvents;
	import com.speakaboos.ipad.events.SpeakaboosServiceEvents;
	import com.speakaboos.ipad.models.data.Category;
	import com.speakaboos.ipad.models.data.Story;
	import com.speakaboos.ipad.models.services.SpeakaboosService;
	import com.speakaboos.ipad.models.services.StoryDbService;
	import com.speakaboos.ipad.view.BookView;
	import com.speakaboos.story.events.CentralEventDispatcher;
	import com.speakaboos.story.events.StoryEvent;
	import com.speakaboos.story.model.SingleRelatedStoryModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	
	public class RelatedStoryLoader
	{
		private var _eventDispatcher:CoreEventDispatcher;
		private var _storyIcon: CacheLoader;
		private var _relatedStoryListing:Story;
		
		
		/************************************************************************************************
		 * Constructor
		 ************************************************************************************************/
		public function RelatedStoryLoader()
		{
			_eventDispatcher = CoreEventDispatcher.getInstance();
		}
		
		
		/////////////////////////////////////////////////////////////////////////////////////////////////
		//External Functions
		/////////////////////////////////////////////////////////////////////////////////////////////////
		
//		public function removeListeners():void {
//			_storyIcon.contentLoaderInfo.removeEventListener(Event.COMPLETE, onStoryIconLoadComplete);	
//			_storyIcon.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadStoryIconError);	
//		}
		
		
		public function handleRelatedStoryClick(evt:StoryEvent):void {
			_relatedStoryListing =	SpeakaboosService.getInstance().getStoryBySlug( evt.infoObj.slug);
			_relatedStoryListing.isPromo = false;
			
			
//			var relatedStoryModel:SingleRelatedStoryModel = new SingleRelatedStoryModel(evt.infoObj);
//			_relatedStoryListing =	new Story();
//			
//			_relatedStoryListing.slug =			relatedStoryModel.slug;
//			_relatedStoryListing.name =			relatedStoryModel.name;
//			_relatedStoryListing.title =		relatedStoryModel.short_title;
//			_relatedStoryListing.storyIcon = 	relatedStoryModel.story_icon;
//			_relatedStoryListing.storyType =	relatedStoryModel.story_type;
//			_relatedStoryListing.bgColor =		"0x" + relatedStoryModel.loadingScreenBGColor;
			
			
			
			SpeakaboosService.getInstance().setCategoryBySlug(_relatedStoryListing.categories[0]);
			_eventDispatcher.dispatchEvent(new GenericDataEvent(SpeakaboosServiceEvents.LOAD_STORY, {story:_relatedStoryListing}));
//			BookView.getInstance().showStory(_relatedStoryListing);
			
//			
//			//I'm not sure if this works like I think it should..
//			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_LOADER));
//			
//			checkDBforSaved();
			
		}
		
		
		/////////////////////////////////////////////////////////////////////////////////////////////////
		//Internal Functions
		/////////////////////////////////////////////////////////////////////////////////////////////////
		
//		private function checkDBforSaved():void{
//			_eventDispatcher.addEventListener(DBEvents.STORY_RETRIEVED, onCheckDBforSaved);
//			//SpeakaboosService.getInstance().setCategoryBySlug(_currentStory.categories[0]);
//			StoryDbService.getInstance().getStoryBySlug(_relatedStoryListing.slug);
//		}
//		
//		private function onCheckDBforSaved(e:GenericDataEvent):void{
//			_eventDispatcher.removeEventListener(DBEvents.STORY_RETRIEVED, onCheckDBforSaved);
//			
//			var storyQueryResults:Object = e.data.storyQueryResults;
//			if(storyQueryResults && storyQueryResults.slug == _relatedStoryListing.slug){
//				_relatedStoryListing.saved = true;
//			}
//			
//			loadStoryIcon();			
//		}
		
//		private function loadStoryIcon():void{
//			//load the story icon for the cover page
//			//TODO: may need to check if we already have this image before loading one
//			_storyIcon = new CacheLoader();
//			_storyIcon.contentLoaderInfo.addEventListener(Event.COMPLETE, onStoryIconLoadComplete,false,0,true);
//			_storyIcon.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadStoryIconError,false,0,true);
//			_storyIcon.loadUrl( _relatedStoryListing.storyIcon);
//		}
//		
//		
//		private function onLoadStoryIconError( evt:IOErrorEvent ):void {
//			removeListeners();
//			//TODO: may need a generic cover icon for this case?
//			//_relatedStoryListing.lowResIcon = ??
//			loadRelatedStory();
//		}
//		
//		
//		private function onStoryIconLoadComplete( evt:Event ):void {
//			
//			removeListeners();
//			
//			var thumbnail:Bitmap = Bitmap(_storyIcon.content);
//			var tempBD:BitmapData = new BitmapData(thumbnail.width, thumbnail.height, true, 0x000000);
//			
//			tempBD.draw(thumbnail);
//			_relatedStoryListing.lowResIcon = tempBD;
//			
//			loadRelatedStory();
//		}
//		
//		
//		private function loadRelatedStory():void {
//			
//			//let story controller know we have a new story
//			var theEvent:StoryEvent = new StoryEvent( StoryEvent.LOAD_STORY, _relatedStoryListing );			
//			CentralEventDispatcher.getInstance().dispatchEvent( theEvent );	
//			
//			//inform BookView we are returning to the title screen
//			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.SHOW_TITLE_SCREEN_RELATED_STORY));
//			
//		}
		
	}
}