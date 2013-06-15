package com.speakaboos.ipad.models.data.product
{
	public class Product
	{
		private var _productID:String;
		private var _description:String;
		private var _title:String;
		
		public function Product(productID:String, title:String, desc:String)
		{
			_productID = productID;
			_title = title;
			_description = desc;
		}
		
		final public function get productID():String{
			return _productID;
		}
		
		final public function get title():String{
			return _title;
		}
		
		final public function get description():String{
			return _description;
		}
	}
}