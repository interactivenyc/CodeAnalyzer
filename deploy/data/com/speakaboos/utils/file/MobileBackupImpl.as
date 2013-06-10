package com.speakaboos.utils.file
{
	import ie.jampot.nativeExtensions.MobileBackup;
	
	public class MobileBackupImpl
	{
		//wrapper class for jampot ANE
		
		private static var _instance:MobileBackupImpl;
		private var _aneBackup:MobileBackup;
		
		public function MobileBackupImpl(enforcer:SingletonEnforcer )
		{
			this._aneBackup = new MobileBackup();
		}
		
		public static function getInstance():MobileBackupImpl {
			if( _instance == null ) {
				_instance = new MobileBackupImpl( new SingletonEnforcer() );
			}
			return _instance;
		}
		
		public function setBackUpFlag(filePath:String):Boolean{
			var result:Boolean = this._aneBackup.doNotBackup(filePath);
			return result;
		}
		
		
		public function destroy():void{
			if(MobileBackupImpl._instance != null){
				if(this._aneBackup != null)
				{this._aneBackup = null;}
				
				MobileBackupImpl._instance = null;
			}	
		}
		
	}
}



class SingletonEnforcer {
	public function SingletonEnforcer():void {}
}
