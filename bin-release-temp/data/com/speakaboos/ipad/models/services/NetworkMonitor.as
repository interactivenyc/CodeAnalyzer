package com.speakaboos.ipad.models.services
{
	import com.speakaboos.ipad.events.AppEvents;
	import com.speakaboos.ipad.events.CoreEventDispatcher;
	import com.speakaboos.ipad.events.GenericDataEvent;
	
	//import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import air.net.URLMonitor;

	public class NetworkMonitor
	{
		private static var _instance:NetworkMonitor;
		private static const MONITOR_URL:String = "http://img.speakaboos.com/1px.jpg";
		private var _eventDispatcher:CoreEventDispatcher;
		private var _urlMonitor:URLMonitor;
		private var _isOnline:Boolean = false;
		
		public function get isOnline():Boolean {
			return _isOnline;
		}

		public static function get instantiated():Boolean {return Boolean(_instance)};
		
		public function NetworkMonitor( enforcer:SingletonEnforcer):void {
			if( enforcer == null ) throw new Error( "NetworkMonitor is a singleton class and should only be instantiated via its static getInstance() method" );
		}
		
		public static function getInstance(url:String = MONITOR_URL):NetworkMonitor {
			if( _instance == null ) {
				_instance = new NetworkMonitor( new SingletonEnforcer());
				_instance.init(url);
			}
			return _instance;
		}
		public static function destroySingleton():void {
			if (instantiated) _instance.destroy();
		}
		
		private function onStatusUpdate(e:Event = null):void {
			setOnline(_urlMonitor.available);
		}
		
		private function setOnline(val:Boolean):void {
			if (_isOnline != val) {
				_isOnline = val;
				CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(AppEvents.NETWORK_STATUS, {isOnline:_isOnline}));
			}
		}
		
		private function init(url:String):void {
			var urlReq:URLRequest = new URLRequest(url);
			urlReq.method = URLRequestMethod.HEAD;
			_urlMonitor = new URLMonitor(urlReq);
			_urlMonitor.addEventListener(StatusEvent.STATUS, onStatusUpdate);
			_urlMonitor.start();
			//NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE, onStatusUpdate);
			onStatusUpdate();
		}

		public function destroy():void {
			_urlMonitor.removeEventListener(StatusEvent.STATUS, onStatusUpdate);
			_urlMonitor.stop();
			_urlMonitor = null;
			_instance = null;
		}
		
	}
	
	
	
	
}
class SingletonEnforcer{}
