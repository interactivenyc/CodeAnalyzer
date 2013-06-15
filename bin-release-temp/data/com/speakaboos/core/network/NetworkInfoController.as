package com.speakaboos.core.network
{
	import com.speakaboos.core.network.GenericNetworkInfo;
	import com.speakaboos.core.utils.SystemUtils;
	
	public class NetworkInfoController implements iNetworkInterface
	{
		private var _netInfoObject:iNetworkInterface;
		
		public function NetworkInfoController(){}
		
		private function get networkInfoObj():iNetworkInterface{
			if(_netInfoObject){
				return _netInfoObject;
			}
			
			if(SystemUtils.isAppleIOS())
			{_netInfoObject = new IOSNetworkInfo();}
			else
			{_netInfoObject = new GenericNetworkInfo();}
			
			return _netInfoObject;
		}
		
		
		public function getAllInterfaces():Vector.<Object>{
			return networkInfoObj.getAllInterfaces();
		}
		
		public function getActiveInterface():String{
			
			return networkInfoObj.getActiveInterface();
			
		}
		
		public function traceAllInterfaces():void{
			//trace("traceAllInterfaces");
			networkInfoObj.traceAllInterfaces();		
		}
		
		public function getFirstHwAddress():String{
			return networkInfoObj.getFirstHwAddress();
		}
		
		public function destroy():void{
			if(_netInfoObject){
				_netInfoObject.destroy();
			}
		}
		
	}
}