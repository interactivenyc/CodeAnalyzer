package com.speakaboos.ipad.models.data
{
	public class TextEntryInfo
	{
		public static const GENERIC_TYPE:String = "generic";
		public static const EMAIL_TYPE:String = "email";
		public static const PASSWORD_TYPE:String = "password";

		public var label:String;
		public var prompt:String;
		public var type:String;
		
		public function TextEntryInfo(l:String = "", p:String = "", t:String = GENERIC_TYPE)
		{
			label = l;
			prompt = p;
			type = t;
		}
		
		public function reset():void {
			label = null;
			prompt = null;
			type = null;
		}
	}
}