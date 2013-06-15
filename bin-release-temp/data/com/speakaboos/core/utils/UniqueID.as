package com.speakaboos.core.utils
{
	
	import com.adobe.crypto.MD5;
	import com.speakaboos.core.network.NetworkInfoController;
	
	public class UniqueID
	{
		
		private static const LOGIN_SECRET:String = '948815c95d97f558fd896cc201ccec3e';
		public function UniqueID()
		{}
		
		
		public static function getUniqueID():String{
			
			var nic:NetworkInfoController = new NetworkInfoController();
			
			var hwAddr:String = nic.getFirstHwAddress();
			if(hwAddr == ""){
				hwAddr = nic.getActiveInterface();
			}
			
			nic.destroy();
			return hwAddr;
		}
		
		
		public static function getUniqueIDHash():String{
			var strHwAddrHash:String = MD5.hash(getUniqueID());
			return strHwAddrHash;
		}
		
		
		public static function get secret():String{
			return LOGIN_SECRET;
		}
		
	}
}