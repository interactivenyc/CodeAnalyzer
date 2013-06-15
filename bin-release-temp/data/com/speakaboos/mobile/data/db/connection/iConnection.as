package com.speakaboos.mobile.data.db.connection
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	
	public interface iConnection
	{
		 function getConnection(cbFunc:Function, mode:String=SQLMode.READ):void;
		 function releaseConnection(conn:SQLConnection):void;
		 function destroy():void;
	}
}