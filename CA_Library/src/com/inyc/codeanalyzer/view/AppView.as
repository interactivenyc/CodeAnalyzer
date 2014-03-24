package com.inyc.codeanalyzer.view
{
	import com.inyc.codeanalyzer.models.AppModel;
	import com.inyc.codeanalyzer.models.PackageItem;
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
		public static const STARTX:int = 50;

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

			var nextY:int = CELLPADDING;
			var classView:ClassView = e.data.classView;

			//TODO: THIS IS A SILLY WAY TO STACK PACKAGE MOVIECLIPS - FIND A BETTER ROUTINE ASAP
			var packageContainer:PackageView;
			var packageItem:PackageItem = classView.classItem.packageItem;
			var packageString:String = packageItem.packageString;

			if (!_packageContainers[packageItem.packageString]){
				log("create package container: "+packageString);
				packageContainer = new PackageView(packageItem);
				_packageContainers[packageString] = packageContainer;
				_packageArray.push(packageString);
				if (_packageArray.length > 1){
					var previousPackageContainer:MovieClip = _packageContainers[_packageArray[_packageArray.length-2]];
					nextY = previousPackageContainer.y + previousPackageContainer.height + CELLPADDING;
				}
				packageContainer.x = STARTX;
				packageContainer.y = nextY;
				addChild(packageContainer);
			}else{
				packageContainer = _packageContainers[packageString];
			}

			packageContainer.addClass(classView);
			packageContainer.addEventListener(MouseEvent.MOUSE_DOWN, sendUp);
		}

		private function onAllItemsLoaded(e:GenericDataEvent=null):void{
			log("onAllItemsLoaded");
			log("view size: "+width + ", "+height);
		}

		private function sendUp(e:MouseEvent):void{
			log("sendUp - PackageView");
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

