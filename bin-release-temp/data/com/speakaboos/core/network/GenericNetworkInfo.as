package com.speakaboos.core.network
{
	
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;

	
	public class GenericNetworkInfo implements iNetworkInterface
	{
		public function GenericNetworkInfo()
		{
		}
		
		
		public function getAllInterfaces():Vector.<Object>{
		
			//trace("GenericNetworkInfo -> getAllInterfaces");
			
			var networkInfo:NetworkInfo = NetworkInfo.networkInfo; 
			var interfaces:Vector.<NetworkInterface> = networkInfo.findInterfaces(); 
			
			var vRet:Vector.<Object> = new Vector.<Object>();
			
			for each (var iFace:NetworkInterface in interfaces){
				vRet.push(iFace as Object);
			}
			
			return vRet;
			
		}
		
		
		public function getActiveInterface():String{
			
			var vInterfaces:Vector.<Object> = getAllInterfaces();
			
			for each (var ni:Object in vInterfaces) 
			{
				if(ni.active)
					return ni.hardwareAddress;
				
				
			}
			
			return "";
				
		
		}
		
		public function traceAllInterfaces():void{
		
			//trace("GenericNetworkInfo -> traceAllInterfaces");
			
			var vNetworkInterfaces:Vector.<Object> = getAllInterfaces();
			
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
				
				trace("*********** Interface Addresses in " + ((dName.length > 0) ? dName : name )  +"*************");
				
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
		
		}
		
		
	}
}