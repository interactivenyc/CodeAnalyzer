package com.speakaboos.mobile.data.db.connection
{
	
	import flash.data.SQLConnection;
	//import flash.data.SQLMode;
	
	public class ConnectionStruct
	{
		private var _id:String;
		private var _conn:SQLConnection;
		private var _mode:String;
		private var _state:Boolean;
		
		public function ConnectionStruct(connectionId:String, sqlConn:SQLConnection, sqlMode:String){
			_id = connectionId;
			_conn = sqlConn;
			_mode = sqlMode;
			_state = false;
		}
		
		public function get id():String{
			return _id;
		}
		
		public function get connection():SQLConnection{
			return _conn;
		}
		
		public function get mode():String{
			return _mode;
		}
		
		/*
		public function get state():Boolean{
			return _state;
		}
		*/
		
		
		public function isEnabled():Boolean{
			return (_state == true);
		}
		
		
		public function enable():void{
			_state = true;
		}
		
		public function disable():void{
			_state = false;
		}
		
		public function destroy():void{
			_conn = null;
			_mode = null;
			_state = 0;
			_id = null;
		}
		
		
		
	}
}