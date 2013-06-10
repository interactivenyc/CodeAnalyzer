package com.speakaboos.ipad.events
{
	public class SubscriptionEvents
	{
		
		/*
		Subscription Events for Speakaboos 'subscribe' web service
		*/
		public static const SUBSCRIBE_SUCCEEDED:String = "000";
		public static const SUBSCRIBE_FAILED:String = "001";
		public static const SUBSCRIBE_RESTORE_SUCCEEDED:String = "002";
		public static const SUBSCRIBE_RESTORE_FAILED:String = "003";
	
		
		/*
			For Retrieval of ProductIDs from Speakaboos server
		*/
		public static const SPEAK_PRODUCT_IDS_LOADED:String="200";
		public static const SPEAK_PRODUCT_IDS_FAILED:String="201";
		
		
		/*
			iTunes product list events
		*/
		public static const ITUNES_PRODUCT_DETAILS_LOADED:String = "300";
		public static const ITUNES_PRODUCT_DETAILS_FAILED:String = "301";
		
		
		/*
			iTunes Subscription events
		*/
		public static const ITUNES_SUBSCRIBE_SUCCEEDED:String = "400";
		public static const ITUNES_SUBSCRIBE_FAILED:String = "401";
		public static const ITUNES_SUBSCRIBE_CANCELLED:String = "402";
		public static const ITUNES_TRANSACTION_RESTORE_SUCCEEDED:String = "403";
		public static const ITUNES_TRANSACTION_RESTORE_FAILED:String = "404";
		public static const ITUNES_TRANSACTIONS_RESTORED:String = "405";
		public static const ITUNES_TRANSACTION_RESTORE_EMPTY:String = "406";  //no transactions to restore
		
		public static const RESTORE_TRANSACTIONS:String = "RESTORE_TRANSACTIONS";
		
		public function SubscriptionEvents()
		{	
		}
	}
}