package com.speakaboos.ipad.models.data.product
{
	import com.milkmangames.nativeextensions.ios.events.StoreKitEvent;
	
	public class ITunesTransaction
	{
		
		private var _transId:String;
		private var _receipt:String;
		private var _productId:String;
		private var _origTransID:String;
		
		public function ITunesTransaction(ske:StoreKitEvent)
		{
			_transId = ske.transactionId;
			_receipt = ske.receipt;
			_productId = ske.productId;
			_origTransID = (ske.originalTransactionId != null) ? ske.originalTransactionId : "";
		}
		
		final public function get transactionID():String{
			return _transId;
		}
		
		final public function get receipt():String{
			return _receipt;
		}
		
		final public function get productID():String{
			return _productId;
		}
		
		final public function get originalTransID():String{
			return _origTransID;
		}
		
	}
}