package com.speakaboos.ipad.models.services.test
{

	public class TestSubscriptionErrorCode
	{
		
		private static var _instance:TestSubscriptionErrorCode;
		private var _currCode:int = 0;
		private var _errorCodes:Array = [405, 501, 21030, 21006, 21005];//[21000, 21002, 21003, 21004, 21007, 21008, 21020, 21005, 21006, 501, 405, 21030];
		
		
		public function TestSubscriptionErrorCode( enforcer:SingletonEnforcer){
			super();
			if( enforcer == null ) throw new Error( "TestSubscriptionErrorCode is a singleton class and should only be instantiated via its static getInstance() method" );
		}
		
		
		public static function get instantiated():Boolean {return (_instance != null)};
		
		public static function getInstance():TestSubscriptionErrorCode {
			if( _instance == null ) {
				_instance = new TestSubscriptionErrorCode( new SingletonEnforcer() );
			}	
			return _instance;
		}
		
		public static function destroySingleton():void {
			if (instantiated) _instance.destroy();
		}
		
		
		final public function destroy():void {
			if (_instance) {
				_instance = null;
			}
		}
		
		
		final public function getTestErrorCode():int{
			var retVal:int = _errorCodes[_currCode++];
			/*
			var len:int = _errorCodes.length;
			_currCode = Math.min((len - 1), Math.max(0, _currCode));	
			*/
			if(_currCode >= _errorCodes.length){
				_currCode = 0;
			}
			return retVal;
		}
		
	}
}

class SingletonEnforcer {
	public function SingletonEnforcer():void {}
}