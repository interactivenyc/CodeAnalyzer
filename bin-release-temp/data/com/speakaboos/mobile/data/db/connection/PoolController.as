package com.speakaboos.mobile.data.db.connection
{
	import com.speakaboos.mobile.data.db.connection.ConnectionPool;
	//import com.speakaboos.ipad.utils.debug.Logger;
	
	import flash.data.SQLMode;
	
	public class PoolController
	{
		private static var _instance:PoolController;
		private var _readPool:ConnectionPool;
		private var _writePool:ConnectionPool;
		private var _createPool:ConnectionPool;
		
		public function PoolController(enforcer:SingletonEnforcer){}
		
		
		public static function getInstance():PoolController {
			if( _instance == null ) {
				_instance = new PoolController( new SingletonEnforcer() );
			}
			return _instance;
		}
		
		
		public static function isActivated():Boolean{
			return (_instance != null);
		}
		
		
		public function getConnection(cbFunc:Function, mode:String=SQLMode.READ):void{
			
			//Logger.log("getConnection: " + mode);
			
			var onGotConnection:Function = function(cs:ConnectionStruct):void{
				if(cs){
					//Logger.log("onGotConnection: " + cs.mode);
					cbFunc(cs);
				}
				else
					cbFunc(null);
			
			};
			
			
			
			switch(mode){
				case SQLMode.READ:
					readPool.getConnection(onGotConnection);
					break;
				
				case SQLMode.UPDATE:
					writePool.getConnection(onGotConnection);
					break;
				
				case SQLMode.CREATE:
					createPool.getConnection(onGotConnection);
					break;
		
				default:
	
			}
		
			
		}
		
		
		public function releaseConnection(cs:ConnectionStruct):void{
		
			if(!cs){
				//Logger.log("releaseConnection: cs:ConnectionStruct is null: " + cs);
				return;
			}
			
			//Logger.log("releaseConnection: " + cs.mode);
			
			switch(cs.mode){
			
				case SQLMode.READ:
					readPool.releaseConnection(cs);
					break;
				
				case SQLMode.UPDATE:
					writePool.releaseConnection(cs);
					break;
				
				case SQLMode.CREATE:
					createPool.releaseConnection(cs, false);
					break;
				
				default:
				
			
			}
		}
		
		
		public function destroy():void{
			
			if(_readPool)
				_readPool.destroy();
			
			if(_writePool)
				_writePool.destroy();
			
			if(_createPool)
				_createPool.destroy();
			
			_readPool = null;
			_writePool = null;
			_createPool = null;
			
			_instance = null;
		
		}
		
		
		final private function get readPool():ConnectionPool{
			if(!_readPool)
				_readPool = new ConnectionPool(SQLMode.READ);
			
			return _readPool;
		}
		
		final private function get writePool():ConnectionPool{
			if(!_writePool)
				_writePool = new ConnectionPool(SQLMode.UPDATE);
			
			return _writePool;
		}
		
		final private function get createPool():ConnectionPool{
			if(!_createPool)
				_createPool = new ConnectionPool(SQLMode.CREATE);
			
			return _createPool;
		}
		
		final private function log(str:String=""):void{
			str = "[PoolController] " + str;
			//Logger.log(str);
		}
		
	}
}



class SingletonEnforcer {
	public function SingletonEnforcer():void {}
}
