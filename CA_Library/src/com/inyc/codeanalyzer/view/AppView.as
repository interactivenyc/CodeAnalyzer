package com.inyc.codeanalyzer.view
{
	import com.inyc.codeanalyzer.models.AppModel;
	import com.inyc.components.DynamicLayoutView;
	import com.inyc.components.Toolbar;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AppView extends DynamicLayoutView
	{
		private var _appModel:AppModel;
		
		//private var _classViews:Vector.<ClassView>;
		private var _packageContainers:Object = new Object();
		private var _packageArray:Array = new Array();
		
		public static const CELLPADDING:int = 20;
		
		public function AppView(appModel:AppModel){
			super();
			log("constructor");
			
			_appModel = appModel;
			//_classViews = new Vector.<ClassView>;
		}
		
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			log("onAddedToStage");
			
			addEventListeners();
		}
		
		override protected function onRemovedFromStage(e:Event):void{
			super.onRemovedFromStage(e);
			removeEventListeners();
		}
		
		private function addEventListeners():void{
			log("addEventListeners");
			_eventDispatcher.addEventListener(AppEvents.FILE_LOADED, onItemLoaded);
			_eventDispatcher.addEventListener(AppEvents.ALL_FILES_LOADED, onAllItemsLoaded);
		}
		
		private function removeEventListeners():void{
			_eventDispatcher.removeEventListener(AppEvents.FILE_LOADED, onItemLoaded);
			_eventDispatcher.removeEventListener(AppEvents.ALL_FILES_LOADED, onAllItemsLoaded);
		}
		
		private function onItemLoaded(e:GenericDataEvent=null):void{
			//log("onItemLoaded");
			
			//var nextX:int = 50;
			var nextY:int = CELLPADDING;
//			if (_classViews.length > 0){
//				var previousClassView:ClassView = _classViews[_classViews.length-1];
//				nextX = nextX + previousClassView.x + ClassView.WIDTH;
//			}
			
			
			
			var classView:ClassView = e.data.classView;
			
			
			//TODO: THIS IS A SILLY WAY TO STACK PACKAGE MOVIECLIPS - FIND A BETTER ROUTINE ASAP
			var packageString:String = classView.classItem.packageString;
			var packageContainer:PackageView;
			if (!_packageContainers[packageString]){
				log("create package container: "+packageString);
				packageContainer = new PackageView();
				_packageContainers[packageString] = packageContainer;
				_packageArray.push(packageString);
				if (_packageArray.length > 1){
					var previousPackageContainer:MovieClip = _packageContainers[_packageArray[_packageArray.length-2]];
					nextY = previousPackageContainer.y + previousPackageContainer.height + CELLPADDING;
				}
				packageContainer.x = 50;
				packageContainer.y = nextY;
				addChild(packageContainer);
			}else{
				packageContainer = _packageContainers[packageString];
			}
			
			//_classViews.push(classView);
			
			packageContainer.addClass(classView);
			
			//log("classView.x: "+classView.x+", classView.y: "+classView.y);
			
			classView.addEventListener(MouseEvent.MOUSE_DOWN, sendUp);
			
		}
		
		private function onAllItemsLoaded(e:GenericDataEvent=null):void{
			log("onAllItemsLoaded");
			log("view size: "+width + ", "+height);
		}
		
		private function sendUp(e:MouseEvent):void{
			addChild(e.currentTarget as MovieClip);
		}
		

		
		
		
		private function onEventReceived(e:GenericDataEvent):void{
			log("onEventReceived: "+e.type)
			
			switch(e.type){
				case AppEvents.FILE_LOADED:
					onItemLoaded(e);
					break;
				case AppEvents.ALL_FILES_LOADED:
					onAllItemsLoaded();
					break;
				
			}
		}
		
		
	}
}