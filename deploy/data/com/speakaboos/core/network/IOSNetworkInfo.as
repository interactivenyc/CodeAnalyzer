package com.speakaboos.core.network
{
	
	import com.adobe.nativeExtensions.Networkinfo.NetworkInfo;
	
	public class IOSNetworkInfo implements iNetworkInterface
	{
		public function IOSNetworkInfo(){}
		
		
		public function getAllInterfaces():Vector.<Object>{
			
			var vAll:Vector.<Object> = NetworkInfo.networkInfo.findInterfaces();// as Vector.<SpeakNetworkInterface>;
			
			return vAll;
			
			
		}
		
		
		public function getActiveInterface():String{
			
			var vNetworkInterfaces:Vector.<Object>; 
			
		
			trace("Using iOS ANE for NetworkInfo");
			//vNetworkInterfaces = getDefinitionByName('com.adobe.nativeExtensions.Networkinfo.NetworkInfo')['networkInfo']['findInterfaces'](); 
			vNetworkInterfaces = getAllInterfaces();
		
			
			for each (var ni:Object in vNetworkInterfaces) 
			{
				if(ni.active)
					return ni.hardwareAddress;
				
			}
			
			return "";
			
		}
		
		
		public function traceAllInterfaces():void{
			
			trace("Using iOS ANE for NetworkInfo");
			
			var vNetworkInterfaces:Vector.<Object>; 
			
			vNetworkInterfaces = getAllInterfaces();
			
			for each (var ni:Object in vNetworkInterfaces) 
			{
				
				// Access interfaceObj.name, interfaceObj.displayName, interfaceObj.active,
				// interfaceObj.hardwareAddress, and interfaceObj.mtu
				var name:String = ni.name;
				var dName:String = ni.displayName;
				var active:Boolean = ni.active;
				var hwAddy:String = ni.hardwareAddress;
				var mtu:int = ni.mtu;
				
				trace("************************");
				trace("Interface: " + name);
				trace("Name: " + dName);
				trace("Active: " + active);
				trace("Hardare Address: " + hwAddy);
				trace("MTU: "  + mtu);
				
				
				trace("*********** Interface Addresses in " + ((dName.length > 0) ? dName : name ) + "*************");
				
				for each(var address:Object in ni.addresses)
				{
					trace("////////////////////");
					
					// Access address.address, address.broadcast, address.ipVersion, and address.prefixLength
					var addr:String = address.address;
					var bCast:String = address.broadcast;
					var ipVer:String = address.ipVersion;
					var prefixLen:int = address.prefixLength;
					
					
					trace("Address: " + addr);
					trace("Broadcast: " + bCast);
					trace("ip Version: " + ipVer);
					trace("Prefix Length: " + prefixLen);
					
					//trace("////////////////////");
				}
				
				trace("************************");
				
			}
			
		}
		
		public function getFirstHwAddress():String{
			
			var vNetworkInterfaces:Vector.<Object> = getAllInterfaces();
			
			for each (var ni:Object in vNetworkInterfaces){
				if(ni.hardwareAddress == null)
					continue;
				
				var strAddress:String = ni.hardwareAddress;
				if(strAddress.length > 0)
					return strAddress;
				
			}
			
			return "";
			
		}
		
		public function destroy():void{
			//TODO: add dispose() method for ANE
		}
	}
}