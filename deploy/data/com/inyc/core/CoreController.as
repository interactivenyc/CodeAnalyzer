package com.inyc.core
{
	import com.inyc.components.DialogButton;
	import com.inyc.components.LogDisplay;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.utils.MovieClipUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class CoreController extends CoreMovieClip
	{
		private static var _instance:CoreController;

		
		//Main Views
		protected var _viewContainer:CoreMovieClip;
		protected var _background:MovieClip;
		protected var _logButton:MovieClip;
		
		public static var topModal:CoreModal;
		protected var _openModals:Vector.<CoreModal>;
		
		//This sets the viewport size
		protected var _stageWidth:int = 1200; 
		protected var _stageHeight:int = 900; 
		
		public static var LOAD_FILES_FROM_CACHE:Boolean = true;
		public static var ANIMATING:Boolean = false;
		public static var LOADER_CONTEXT:LoaderContext;
		public static var LOG_OUTPUT:String = "";
			
		public function CoreController(){
			
			LOADER_CONTEXT = new LoaderContext(false,ApplicationDomain.currentDomain,null); //avoids some security sandbox headaches that plague many users.
			_openModals = new Vector.<CoreModal>;
			_viewContainer = new CoreMovieClip();
			addChild(_viewContainer);
			
			_logButton = MovieClipUtils.getLibraryMC("logButton");
			_logButton.x = 10;
			_logButton.y = 10;
			_logButton.addEventListener(MouseEvent.CLICK, showLog);
			addChild(_logButton);
		}
		
		public static function getInstance():CoreController {
			if( _instance == null ) {
				_instance = new CoreController( new SingletonEnforcer() );
			}
			return _instance;
		}
		
		protected function showLog(e:Event = null):void{
			log("showLog");
			var buttons:Vector.<DialogButton> = new Vector.<DialogButton>;
			var button:DialogButton = new DialogButton("OK", closeTopModal);
			buttons.push(button);
			button = new DialogButton("RESET LOG");
			buttons.push(button);
			
			var messageDialog:LogDisplay = new LogDisplay("Log File", LOG_OUTPUT, buttons);
			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.SHOW_MESSAGE_DIALOG, {messageDialog:messageDialog}));
		}
		
		protected function resetLog(e:Event = null):void{
			LOG_OUTPUT == "";
		}
		
		/*********************************************************************
		 * MODAL DISPLAY
		 *********************************************************************/
		
		
		protected function showLoaderMC():void{
			var modal:CoreModal;
			modal = new CoreModal();
			showModal(modal);
		}
		
		protected function showModal(modal:CoreModal):void{
			//log("showModal:"+modal);
			
			topModal = modal;
			
			_openModals.push(modal);
			centerDisplayObject(modal);
			_viewContainer.addChild(modal);
		}
		
		
		protected function centerDisplayObject(displayObject:DisplayObject):void{
			//log("centerDisplayObject");
			displayObject.x = (_stageWidth/2) - (displayObject.width/2);
			displayObject.y = (_stageHeight/2) - (displayObject.height/2);
			//log("width: "+displayObject.width+", height: "+displayObject.height);
			//log("x: "+displayObject.x+", y: "+displayObject.y);
		}
		
		
		public function closeTopModal():void{
			//log("closeTopModal");
			if (_openModals.length < 1) return;
			
			var modal:CoreModal = _openModals.pop();
			
			if (_openModals.length > 0) topModal = _openModals[_openModals.length -1];
			
			_viewContainer.removeChild(modal);
			modal.destroy();
			modal = null;
			
		}
		
		
		protected function closeAllModals():void{
			//log("closeAllModals:");
			for (var i:int=0; i<_openModals.length; i++){
				_viewContainer.removeChild(_openModals[i]);
				_openModals[i] = null;
			}
			_openModals = new Vector.<CoreModal>();
		}
		
		
		
		protected function numModalsOpen():int{
			var numModals:int = 0;
			for (var i:int=0;i<_viewContainer.numChildren;i++){
				if (_viewContainer.getChildAt(i) is CoreModal) numModals ++;
			}
			return numModals;
		}
		
		public function get openModals():Vector.<CoreModal>{
			return _openModals;
		}

	}
}

class SingletonEnforcer {
	public function SingletonEnforcer():void {}
}