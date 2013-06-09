package com.inyc.components {		//REPLACE THESE IMPORTS FOR A MORE GENERIC IMPLEMENTATION		import com.inyc.components.IGridItem;	import com.inyc.models.GridItemData;	import com.inyc.events.AppEvents;	import com.inyc.events.GenericDataEvent;	import com.inyc.utils.MovieClipUtils;	import com.inyc.utils.debug.Logger;		import flash.display.Loader;	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.MouseEvent;	import flash.net.URLRequest;	import flash.system.LoaderContext;		/**	 * @author stevewarren	 */	public class GridItem extends MovieClip implements IGridItem {		protected var _thumbURL:String;		protected var _gridItemData:GridItemData;		protected var _loader:Loader;
		public function GridItem() {			//log("constructor");		}				protected function addListeners(){			buttonMode = true;						addEventListener(MouseEvent.CLICK, onMouseClick);			addEventListener(MouseEvent.ROLL_OVER, onRollOver);			addEventListener(MouseEvent.ROLL_OUT, onRollOut);		}						protected function removeListeners(){			removeEventListener(Event.REMOVED_FROM_STAGE, removeListeners);						removeEventListener(MouseEvent.CLICK, onMouseClick);			removeEventListener(MouseEvent.ROLL_OVER, onRollOver);			removeEventListener(MouseEvent.ROLL_OUT, onRollOut);		}								protected function onMouseClick(e:MouseEvent):void{			//log("onMouseEvent GridItem Clicked - dispatch event");			stage.dispatchEvent(new GenericDataEvent(AppEvents.GRID_ITEM_CLICKED,{gridItem:this, mouseEvent:e}));					}				protected function onRollOver(e:MouseEvent){					}				protected function onRollOut(e:MouseEvent){			//log("onRollOutMe");					}				public function set gridItemData(value:GridItemData):void{			_gridItemData = value;			if (_gridItemData.cellWidth > 0 && _gridItemData.cellHeight > 0){				addChildAt(MovieClipUtils.getFilledMC(_gridItemData.cellWidth, _gridItemData.cellHeight, 0xaaaaaa),0);			}		}				public function get gridItemData():GridItemData{			return _gridItemData;		}				public function set thumbURL(value:String):void{			_thumbURL = value;		}				public function get thumbURL():String{			return _thumbURL;		}		public function setLoader(loader:Loader, urlRequest:URLRequest, loaderContext:LoaderContext = null):void {			_loader = loader;						addChild(_loader);			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onGridItemLoaded);			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);						_loader.load(urlRequest, loaderContext);		}				protected function onGridItemLoaded(e:Event){			//log("onGridItemLoaded");						_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onGridItemLoaded);			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);			if (e != null) dispatchEvent(e);			addListeners();		}				protected function handleIOError(e:IOErrorEvent):void {			log("handleIOError:"+e.text);						_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onGridItemLoaded);			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);						onGridItemLoaded(null);		}				public function destroy(){			removeListeners();		}				private function log(logItem:*):void {			Logger.log(logItem,["GridItem"],true);		}	}}