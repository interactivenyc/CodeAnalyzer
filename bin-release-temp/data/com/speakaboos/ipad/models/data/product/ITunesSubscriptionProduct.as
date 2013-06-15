package com.speakaboos.ipad.models.data.product
{
	public class ITunesSubscriptionProduct extends Product
	{
		private var _price:String;
		
		public function ITunesSubscriptionProduct(productID:String, title:String, desc:String, price:String)
		{
			super(productID, title, desc);
			_price = price;
		}
		
		final public function get price():String{
			return _price;
		}
	}
}