package com.inyc.codeanalyzer.view
{
	import com.inyc.codeanalyzer.models.AppModel;
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.utils.MovieClipUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AppView extends CoreMovieClip
	{
		private var _appModel:AppModel;
		private var _bg:MovieClip;
		
		public function AppView(appModel:AppModel)
		{
			super();
			log("constructor");
			
			_appModel = appModel;
			
		}
		
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			log("onAddedToStage");
			
			addEventListeners();
			
			scaleX = .5;
			scaleY = .5;
			
			_bg = MovieClipUtils.getFilledMC(CodeAnalyzer.STAGE_WIDTH-1,CodeAnalyzer.STAGE_HEIGHT-1,0xffffcc, true);
			addChild(_bg);

			log("stage.width: "+stage.width+", stage.height: "+stage.height);

		}
		
		override protected function onRemovedFromStage(e:Event):void{
			super.onRemovedFromStage(e);
			removeEventListeners();
		}
		
		private function addEventListeners():void{
			log("addEventListeners");
			_eventDispatcher.addEventListener(AppEvents.LAYOUT_ITEM_LOADED, onItemLoaded);
			_eventDispatcher.addEventListener(AppEvents.ALL_LAYOUT_ITEMS_LOADED, onAllItemsLoaded);
		}
		
		private function removeEventListeners():void{
			_eventDispatcher.removeEventListener(AppEvents.LAYOUT_ITEM_LOADED, onItemLoaded);
			_eventDispatcher.removeEventListener(AppEvents.ALL_LAYOUT_ITEMS_LOADED, onAllItemsLoaded);
		}
		
		private function onItemLoaded(e:GenericDataEvent=null):void{
			log("onItemLoaded");
			log(e);
			
			var classView:ClassView = e.data.classView;
			addChild(classView);
			classView.x = Math.ceil(Math.random()*(CodeAnalyzer.STAGE_WIDTH-classView.width));
			classView.y = Math.ceil(Math.random()*(CodeAnalyzer.STAGE_HEIGHT-classView.height));
			
			log("classView.x: "+classView.x+", classView.y: "+classView.y);
			
			classView.addEventListener(MouseEvent.MOUSE_DOWN, sendUp);
		}
		
		private function onAllItemsLoaded(e:GenericDataEvent=null):void{
			log("onAllItemsLoaded");
		}
		
		private function sendUp(e:MouseEvent):void{
			addChild(e.currentTarget as MovieClip);
		}
		
		private function onEventReceived(e:GenericDataEvent):void{
			log("onEventReceived: "+e.type)
			
			switch(e.type){
				case AppEvents.LAYOUT_ITEM_LOADED:
					onItemLoaded(e);
					break;
				case AppEvents.ALL_LAYOUT_ITEMS_LOADED:
					onAllItemsLoaded();
					break;
				
			}
		}
		
		
	}
}