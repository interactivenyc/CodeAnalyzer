package com.inyc.components
{
	import com.inyc.core.CoreMovieClip;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.utils.MovieClipUtils;
	
	import flash.events.MouseEvent;
	
	public class DynamicLayoutContainer extends CoreMovieClip
	{
		private var _currentView:DynamicLayoutView;
		
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
		
		public function addView(view:DynamicLayoutView):void{
			log("addView");
			_currentView = view;
			addChild(view);
		}
		
		
		public function setSize(w:int,h:int):void{
			log("setSize");
			addChild(MovieClipUtils.getFilledMC(stage.width,stage.height, 0xFFFFFF));
			if (_currentView) addChild(_currentView);
		}
		
		
		
		private function onMouseEvent(e:MouseEvent):Boolean{
			log("onMouseEvent e.currentTarget: "+e.currentTarget + ", e.type: "+e.type);
			
			switch(e.type){
				case MouseEvent.MOUSE_DOWN:
					if (viewMode == VIEW_MODE_NAVIGATE){
						_currentView.startDrag();
					}
					break;
				case MouseEvent.MOUSE_UP:
					if (viewMode == VIEW_MODE_NAVIGATE){
						_currentView.stopDrag();
						log("_currentView loc ("+_currentView.x + ","+_currentView.y+")");
					}
					break;
				case MouseEvent.CLICK:
					log("clickLoc: ("+_currentView.mouseX + ","+_currentView.mouseY+")");
					
					switch(viewMode){
						case VIEW_MODE_ZOOM_IN:
							_currentView.scaleX = _currentView.scaleY = (_currentView.scaleX * 1.25);
							
							_currentView.x = -(_currentView.mouseX * _currentView.scaleX);
							_currentView.y = -(_currentView.mouseY * _currentView.scaleY);
							break;
						case VIEW_MODE_ZOOM_OUT:
							_currentView.scaleX = _currentView.scaleY = (_currentView.scaleX / 1.25);
							
							_currentView.x = -(_currentView.mouseX * _currentView.scaleX);
							_currentView.y = -(_currentView.mouseY * _currentView.scaleY);
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