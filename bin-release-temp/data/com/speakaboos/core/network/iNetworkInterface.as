package com.speakaboos.core.network
{
	
	public interface iNetworkInterface
	{
		
		function getAllInterfaces():Vector.<Object>;
		function getActiveInterface():String;
		function traceAllInterfaces():void;
		function getFirstHwAddress():String;
		function destroy():void;
		
	}
}