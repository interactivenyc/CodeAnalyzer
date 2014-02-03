package com.inyc.components
{
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.utils.KeyObject;
	import com.inyc.utils.MovieClipUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	public class DynamicLayoutContainer extends CoreMovieClip
	{
		private var _currentView:DynamicLayoutView;
		private var _scalingContainer:MovieClip;
		private var _keyObject:KeyObject;
		
		private var _dragging:Boolean = false;
		
		public var viewMode:String;
		public static var VIEW_MODE_SELECT:String = "VIEW_MODE_SELECT";
		public static var VIEW_MODE_NAVIGATE:String = "VIEW_MODE_NAVIGATE";
		public static var VIEW_MODE_ZOOM_IN:String = "VIEW_MODE_ZOOM_IN";
		public static var VIEW_MODE_ZOOM_OUT:String = "VIEW_MODE_ZOOM_OUT";
		
		public function DynamicLayoutContainer(){
			super();
			log("CONSTRUCTOR");
			
			addEventListener(MouseEvent.CLICK, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseEvent);
			
			
			_eventDispatcher.addEventListener(AppEvents.TOOLBAR_SELECT, receiveEvent);
			_eventDispatcher.addEventListener(AppEvents.TOOLBAR_MOVE, receiveEvent);
			_eventDispatcher.addEventListener(AppEvents.TOOLBAR_ZOOM_IN, receiveEvent);
			_eventDispatcher.addEventListener(AppEvents.TOOLBAR_ZOOM_OUT, receiveEvent);
			
			
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			
			_keyObject = new KeyObject(stage);
//			_keyObject.addEventListener(KeyboardEvent.KEY_DOWN, onKeyEvent);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyEvent);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyEvent);
			createContainer();
		}
		
		private function createContainer():void{
			log("createContainer");
			
			_scalingContainer = new MovieClip();
			_scalingContainer.x = stage.stageWidth/2;
			_scalingContainer.y = stage.stageHeight/2;
			addChild(_scalingContainer);
		}
		
		public function addView(view:DynamicLayoutView):void{
			log("addView");
			_currentView = view;
			_currentView.x = -stage.stageWidth/2;
			_currentView.y = -stage.stageHeight/2;
			_scalingContainer.addChild(_currentView);
		}
		
		
		public function setSize(w:int,h:int):void{
			log("setSize");
			addChild(MovieClipUtils.getFilledMC(stage.width,stage.height, 0xFFFFFF));
		}
		
		private function zoom(value:int=1):void{
			log("zoom: "+value);
			
			if (value > 0){
				_scalingContainer.scaleX = _scalingContainer.scaleY = (_scalingContainer.scaleX * (1.25*value));
			}else{
				_scalingContainer.scaleX = _scalingContainer.scaleY = (_scalingContainer.scaleX / -(1.25*value));
			}
			
			_currentView.x = -(_currentView.mouseX) + (_scalingContainer.mouseX);
			_currentView.y = -(_currentView.mouseY) + (_scalingContainer.mouseY);

		}
		
		
		private function onKeyEvent(e:KeyboardEvent):void{
			log("onKeyEvent");
			if (_keyObject.isDown(flash.ui.Keyboard.COMMAND)){
				if (_keyObject.isDown(flash.ui.Keyboard.NUMPAD_ADD)) zoom(1);
				if (_keyObject.isDown(flash.ui.Keyboard.NUMPAD_SUBTRACT)) zoom(-1);
				
			}
		}
		
		private function onMouseEvent(e:MouseEvent):Boolean{
			log("onMouseEvent e.currentTarget: "+e.currentTarget + ", e.type: "+e.type);
			
			switch(e.type){
				case MouseEvent.MOUSE_DOWN:
					if (_keyObject.isDown(flash.ui.Keyboard.SPACE) && _keyObject.isDown(flash.ui.Keyboard.SHIFT)){
						if (_keyObject.isDown(flash.ui.Keyboard.ALTERNATE)){
							zoom(-1);
						}else{
							zoom(1);
						}
					}
					
					if (viewMode == VIEW_MODE_NAVIGATE || _keyObject.isDown(flash.ui.Keyboard.SPACE) ){
						if (_dragging == false){
							_dragging = true;
							_currentView.startDrag();
						}
					}
					return true;
				case MouseEvent.MOUSE_UP:
					if (viewMode == VIEW_MODE_NAVIGATE || _dragging == true){
						if (_dragging == true){
							_dragging = false;
							_currentView.stopDrag();
							log("_currentView loc ("+_currentView.x + ","+_currentView.y+")");
						}
					}
					return true;
				case MouseEvent.CLICK:					
					switch(viewMode){
						case VIEW_MODE_ZOOM_IN:
							zoom(1);
							break;
						case VIEW_MODE_ZOOM_OUT:
							zoom(-1)
							break;
					}
					break;
				case MouseEvent.MOUSE_WHEEL:
					//log(e.currentTarget + " sez 'Wheeeee'");
					//e.stopPropagation();
					return false;
					break;
			}
			
			return true;
		}
		
		private function receiveEvent(e:GenericDataEvent):void{
			log("receiveEvent e.type: "+e.type);
			switch(e.type){
				case AppEvents.TOOLBAR_SELECT:		
					viewMode = DynamicLayoutContainer.VIEW_MODE_SELECT;
					break;
				case AppEvents.TOOLBAR_MOVE:	
					viewMode = DynamicLayoutContainer.VIEW_MODE_NAVIGATE;					
					break;
				case AppEvents.TOOLBAR_ZOOM_IN:
					viewMode = DynamicLayoutContainer.VIEW_MODE_ZOOM_IN;
					break;
				case AppEvents.TOOLBAR_ZOOM_OUT:	
					viewMode = DynamicLayoutContainer.VIEW_MODE_ZOOM_OUT
					break;
			}
		}
		
		
	}
}