package com.speakaboos.ipad.events
{
	
	import com.speakaboos.ipad.BaseClass;
	import com.speakaboos.ipad.events.GenericDataEvent;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
		
	public class CoreEventDispatcher extends BaseClass
	{
		private static var _instance:CoreEventDispatcher;
		private var _activeEventMap:Object;
		private var _activeFuncList:Vector.<Function>;
		private var _callbackTimer:Timer;
		private var _callFuncsFunc:Function;
		
		public function CoreEventDispatcher( enforcer:SingletonEnforcer ):void {
			super();
			if( enforcer == null ) throw new Error( "CoreEventDispatcher is a singleton class and should only be instantiated via its static getInstance() method" );
			log("constructor");
		}
		
		public static function get instantiated():Boolean {return Boolean(_instance)};
		
		public static function getInstance():CoreEventDispatcher {
			if( _instance == null ) {
				_instance = new CoreEventDispatcher( new SingletonEnforcer() );
				_instance.init();
			}
			return _instance;
		}
		public static function destroySingleton():void {
			if (instantiated) _instance.destroy();
		}
		
		//TODO: better destroy() function
		public function destroy():void {
			if (_activeEventMap) {
				for (var prop:String in _activeEventMap) {
					_activeEventMap[prop].length = 0;
					delete _activeEventMap[prop];
				}
				_activeEventMap = null;
			}
			if (_activeFuncList) _activeFuncList.length = 0;
			_activeFuncList = null;
			if (_callbackTimer) {
				_callbackTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _callFuncsFunc);
				_callbackTimer.stop();
			}
			_callbackTimer = null;
			_callFuncsFunc = null;
			_instance = null;
			log("destroy");
		}
		
		private function init():void {
			_activeEventMap = {};
			_callbackTimer = new Timer(1, 1);
			log("init _activeEventMap=",_activeEventMap);
		}
		
		public function addEventListener(type:String, listener:Function):void{
			_activeFuncList = _activeEventMap[type];
			if (_activeFuncList) {
				_activeFuncList.push(listener);
			} else {
				_activeEventMap[type] = Vector.<Function>([listener]);
			}
		}
		
		public function removeEventListener(type:String, listener:Function = null):void{
			_activeFuncList = _activeEventMap[type];
			if (_activeFuncList) {
				if (listener) {
					var i:int = _activeFuncList.indexOf(listener);
					if (i >= 0) {
						_activeFuncList.splice(i, 1);
					} else {
						//                      log("removeEventListener called with function not in the list for type "+type);
					}
				} else {
					//                  throw new Error("clearing whole listener list");
					_activeFuncList.length = 0;
					
				}
			} else {
				// fail silently if listener not found
			}
		}
		
		//TODO: might be able to handle event recycling here and perhaps this class would handle the event pool as well
		// I think it would work to add a refCount prop in the event which is incremented before doing a func call and decremented after
		// then checked at the end of this call, recycling the event object if it is back to zero
		public function dispatchEvent(e:GenericDataEvent, delay:Number = 0):Boolean{
			var result:Boolean = false;
			_activeFuncList = _activeEventMap[e.type];
			//log("*** dispatchEvent type="+e.type+", num ev:"+(_activeFuncList && _activeFuncList.length));
			if (_activeFuncList && _activeFuncList.length) {
				_callFuncsFunc = callFuncs(_activeFuncList.concat(), e);
				if (delay) {
					_callbackTimer.delay = delay;
					_callbackTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _callFuncsFunc);
					_callbackTimer.start();
				} else {
					_callFuncsFunc();
				}
				result = true;
			}
			_activeFuncList = null;
			return result;
		}
		
		private function callFuncs(funcs: Vector.<Function>, e:GenericDataEvent):Function {
			return function(timerEvent:TimerEvent=null):void {
				_callbackTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _callFuncsFunc);
				var func:Function;
				for (var i:int = 0; i<funcs.length; i++) {
					func = funcs[i]
					if (typeof func == "function") {
						if (func.length) func(e);
						else func(); // allow callbacks that do not take the event parameter
					}
					else log("dispatchEvent bad function entry "+typeof func+", "+func);
				}
			}
		}
		
	}
}

class SingletonEnforcer {
	public function SingletonEnforcer():void {}
}
