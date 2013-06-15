package com.speakaboos.ipad.view.holders.components
{
	import com.speakaboos.ipad.events.DBEvents;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.events.ModalEvents;
	import com.speakaboos.ipad.models.data.Story;
	import com.speakaboos.ipad.models.services.SpeakaboosService;
	import com.speakaboos.ipad.models.services.StoryDbService;
	import com.speakaboos.ipad.utils.FileUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ManageStoriesPanel extends ListingsPanel
	{
		private var _dbServ:StoryDbService;
		private var _selectedStory:Story;

		public function ManageStoriesPanel(_mc:MovieClip) {
			super(_mc);
		}
		
		override public function onAddedToStage(e:Event = null):void{
			super.onAddedToStage(e);
			init();
		}
		
		override public function onRemovedFromStage(e:Event = null):void{
			super.onRemovedFromStage(e);
			_eventDispatcher.removeEventListener(ListingsItemBase.LISTINGS_ITEM_DELETE_CLICKED, onDeleteClicked);
			_eventDispatcher.removeEventListener(ModalEvents.DELETE_STORY_CLICKED, onDeleteConfirmed);
			_eventDispatcher.removeEventListener(ModalEvents.DELETE_ALL_STORIES_CLICKED, onDeleteAllStories);
		}
		
		private function init():void{
			_dbServ = StoryDbService.getInstance();
			_eventDispatcher.addEventListener(ListingsItemBase.LISTINGS_ITEM_DELETE_CLICKED, onDeleteClicked);
			_eventDispatcher.addEventListener(ModalEvents.DELETE_STORY_CLICKED, onDeleteConfirmed);
			_eventDispatcher.addEventListener(ModalEvents.DELETE_ALL_STORIES_CLICKED, onDeleteAllStories);
			var l:Array = getListings();
			log("current listings: " + ((l != null) ? l.length.toString() : "null"));
			var ss:Array = SpeakaboosService.getInstance().savedStories;
			log("new listings: " + ((ss != null) ? ss.length.toString() : "null"));
			setListings(ss);
		}
		
		private function deleteAllStories():void{
			_eventDispatcher.addEventListener(DBEvents.DELETE_SAVED_STORIES_SUCCESS, onSavedStoriesDeletedFromDB);
			_dbServ.deleteAllSavedStories();	
		}
		
		private function onDeleteAllStories(e:GenericDataEvent):void {
			var arrListings:Array = getListings();
			if(arrListings && arrListings.length){
				deleteAllStories();
			}
		}

		private function onDeleteConfirmed(e:GenericDataEvent):void{
			_eventDispatcher.addEventListener(DBEvents.DELETE_STORY_SUCCESS, onStoryDeleted);
			_dbServ.deleteStory(_selectedStory);
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.CLOSE_MODAL)); 
		}
		
		private function onDeleteClicked(e:GenericDataEvent):void {
			_selectedStory = e.data as Story;
			log("onDeleteClicked " + _selectedStory.name);
		}
		
		private function onStoryDeleted(e:GenericDataEvent):void{
			_eventDispatcher.removeEventListener(DBEvents.DELETE_STORY_SUCCESS, onStoryDeleted);
			
			var s:String =  e.data.story.slug;
			log("story deleted: " + s);
			deleteListing(s);
			//if(FileUtil.deleteDirectory(s))
			if (FileUtil.deleteSlugDir(s))
				log("Directory deleted");
			else
				log("Failed to delete directory");
			
		}
		
		private function onSavedStoriesDeletedFromDB(e:GenericDataEvent):void{
			//remove the confirmation modal
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.CLOSE_MODAL)); 
			
			_eventDispatcher.removeEventListener(DBEvents.DELETE_SAVED_STORIES_SUCCESS, onSavedStoriesDeletedFromDB);
			
			log("onSavedStoriesDeletedFromDB");
			log("deleting dirs from local file system...");
			
			if(FileUtil.deleteStoriesDir())
				log("stories directory successfully deleted!");
			else
				log("failed to delete stories directory!");
			
			
			setListings([]);
			refresh();
			
		}
		
	}
}