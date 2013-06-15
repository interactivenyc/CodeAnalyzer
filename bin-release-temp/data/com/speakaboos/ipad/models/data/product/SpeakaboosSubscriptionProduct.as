package com.speakaboos.ipad.models.data.product
{
	public class SpeakaboosSubscriptionProduct extends Product
	{

		private var _isPromoted:Boolean;
		
		public function SpeakaboosSubscriptionProduct(productID:String, title:String, desc:String, isPromoted:Boolean)
		{
			super(productID, title, desc);
			
			_isPromoted = isPromoted;
			trace("isPromoted: " + _isPromoted);
		}
		
		public function get isPromoted():Boolean{
			return _isPromoted;
		}
		
	
	}
}