package com.speakaboos.ipad.models.services
{
	
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.system.Capabilities;
	
	public class IOSNetworkInfo
	{
		public function getNetworkInfo():void
		{
			var _netInterface:Vector.<NetworkInterface> = com.adobe.nativeExtensions.Networkinfo.NetworkInfo.networkInfo.findInterfaces();
			for each (var interfaceObj:NetworkInterface in _netInterface){
				trace("Interface Name:" + interfaceObj.name + "\n" );
				trace("Hardware Address:" + interfaceObj.hardwareAddress + "\n");
			}
		}
		
		/**
		 * Get device address
		 */
		public function get deviceID():String
		{
			var address:String = NetworkInfo.networkInfo.findInterfaces()[1].hardwareAddress.toString();
			//var address:String = AirNetworkInfo.networkInfo.findInterfaces()[1].hardwareAddress.toString();
			return address;
		}

		/**
		 * Get OS
		 */
		public function get os():String
		{
			var _os:String = Capabilities.os;
			return Capabilities.os;
		}
		
		/*
		public function get isConnected():Boolean
		{
			return AirNetworkInfo.networkInfo.isConnected();
		}
		*/
		
		/*
		public function findInterface():void
		{
		
		var results:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
		
		for(var i:int=0; i<results.length; i++)
		{
		var output:String = output + "Name: " + results[i].name + "\n"
		+ "DisplayName: " + results[i].displayName + "\n"
		+ "MTU: " + results[i].mtu + "\n"
		+ "HardwareAddress: " + results[i].hardwareAddress + "\n"
		+ "Active: " + results[i].active + "\n";
		
		if(results[i].displayName == "Local Area Connection")
		{
		var currentUDID:String = results[i].hardwareAddress.toString();
		log("currentUDID = " + currentUDID);
		}
		
		for(var j:int=0; j<results[i].addresses.length; j++)
		{
		output = output + "Address: " + results[i].addresses[j].address + "\n"
		+ "Broadcast: " + results[i].addresses[j].broadcast + "\n"
		+ "PrefixLength: " + results[i].addresses[j].prefixLength + "\n"
		+ "IPVersion: " + results[i].addresses[j].ipVersion + "\n";
		}
		
		output = output + "\n";
		}
		
		log(output);
		}
		*/
		
		
	}
}

