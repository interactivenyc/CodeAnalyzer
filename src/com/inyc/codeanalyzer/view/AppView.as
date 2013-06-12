package com.inyc.codeanalyzer.view
{
	import com.inyc.codeanalyzer.models.AppModel;
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AppView extends CoreMovieClip
	{
		private var _appModel:AppModel;
		
		public function AppView(appModel:AppModel)
		{
			super();
			_appModel = appModel;
			
			init();
		}
		
		private function init():void{
			
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			addEventListeners();
		}
		
		override protected function onRemovedFromStage(e:Event):void{
			super.onRemovedFromStage(e);
			removeEventListeners();
		}
		
		private function addEventListeners():void{
			_eventDispatcher.addEventListener(AppEvents.LAYOUT_ITEM_LOADED, onItemLoaded);
			_eventDispatcher.addEventListener(AppEvents.ALL_LAYOUT_ITEMS_LOADED, onAllItemsLoaded);
		}
		
		private function removeEventListeners():void{
			_eventDispatcher.removeEventListener(AppEvents.LAYOUT_ITEM_LOADED, onItemLoaded);
			_eventDispatcher.removeEventListener(AppEvents.ALL_LAYOUT_ITEMS_LOADED, onAllItemsLoaded);
		}
		
		private function onItemLoaded(e:GenericDataEvent):void{
			log("onItemLoaded");
			var classView:ClassView = e.data.classView;
			addChild(classView);
			classView.x = Math.ceil(Math.random()*102);
			classView.y = Math.ceil(Math.random()*76);
			classView.addEventListener(MouseEvent.MOUSE_DOWN, sendUp);
		}
		
		private function onAllItemsLoaded(e:GenericDataEvent):void{
			log("onAllItemsLoaded");
		}
		
		private function sendUp(e:MouseEvent):void{
			addChild(e.currentTarget as MovieClip);
		}
		
		
	}
}